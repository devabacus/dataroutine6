import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/database/local/database.dart';
import '../../domain/entities/sync/sync_metadata.dart';
import '../../domain/entities/sync/sync_status_info.dart';
import '../../domain/services/sync_service.dart';
import 'sync/entity_handlers/base_entity_handler.dart';
import 'sync/entity_handlers/category_sync_handler.dart';
// TODO: Импортировать другие обработчики (Task, Tag, TaskTagMap), когда они будут созданы
// import 'sync/entity_handlers/task_sync_handler.dart';
// import 'sync/entity_handlers/tag_sync_handler.dart';
// import 'sync/entity_handlers/task_tag_map_sync_handler.dart';
import 'sync/sync_metadata_service.dart';
import 'sync/last_sync_time_service.dart'; // Сервис для времени последней синхронизации
// TODO: Импортировать сервис проверки сети, когда он будет создан
// import 'sync/network_status_service.dart';
// import 'sync/remote_change_listener_service.dart'; // Пока не используем
// import 'sync/sync_conflict_resolver.dart'; // Пока не используем

class SyncServiceImpl implements ISyncService {
  final FirebaseFirestore _firestore;
  final AppDatabase _localDatabase;
  final SyncMetadataService _syncMetadataService;
  final LastSyncTimeService _lastSyncTimeService;
  // TODO: Добавить NetworkStatusService, когда он будет готов
  // final NetworkStatusService _networkStatusService;
  // final RemoteChangeListenerService _remoteChangeListenerService; // TODO: Добавить позже
  // final SyncConflictResolver _conflictResolver; // TODO: Добавить позже

  // Карта для хранения обработчиков для каждого типа сущности
  final Map<EntityType, BaseEntitySyncHandler> _entityHandlers = {};

  // StreamController для трансляции состояния синхронизации
  // Используем broadcast, чтобы разрешить несколько слушателей
  final _statusController = StreamController<SyncStatusInfo>.broadcast();

  // Флаг, указывающий, идет ли синхронизация в данный момент
  bool _isSyncing = false;
  // Время завершения последней *попытки* полной синхронизации (могла завершиться с ошибкой)
  DateTime? _lastGlobalSyncAttemptCompletionTime;
  // Сообщение последней ошибки синхронизации
  String? _lastSyncErrorMessage;
  // TODO: Добавить подписку на статус сети
  // StreamSubscription<bool>? _networkStatusSubscription;

  SyncServiceImpl({
    required FirebaseFirestore firestore,
    required AppDatabase localDatabase,
    required SyncMetadataService syncMetadataService,
    required LastSyncTimeService lastSyncTimeService,
    // TODO: Добавить остальные зависимости (NetworkStatusService и т.д.)
    // required NetworkStatusService networkStatusService,
  })  : _firestore = firestore,
        _localDatabase = localDatabase,
        _syncMetadataService = syncMetadataService,
        _lastSyncTimeService = lastSyncTimeService
        // _networkStatusService = networkStatusService // Сохраняем зависимость
         {
    // Регистрируем обработчики
    _registerHandler(CategorySyncHandler(
      firestore: _firestore,
      localDatabase: _localDatabase,
      syncMetadataService: _syncMetadataService,
    ));

    // TODO: Зарегистрировать другие обработчики здесь, когда они будут созданы
    // _registerHandler(TaskSyncHandler(...));
    // _registerHandler(TagSyncHandler(...));
    // _registerHandler(TaskTagMapSyncHandler(...));

    // TODO: Инициализировать NetworkStatusService и подписаться на изменения
    // _networkStatusSubscription = _networkStatusService.onlineStatusStream.listen((isOnline) {
    //    print("Network status changed: ${isOnline ? 'Online' : 'Offline'}");
    //   _notifyStatusUpdate(); // Уведомляем об изменении статуса сети
    // });

    print('[INFO] SyncServiceImpl initialized.');
  }

  /// Регистрация обработчика для типа сущности
  void _registerHandler(BaseEntitySyncHandler handler) {
    if (_entityHandlers.containsKey(handler.entityType)) {
      print('[WARNING] SyncServiceImpl: Handler for ${handler.entityType} already registered. Overwriting.');
    }
    _entityHandlers[handler.entityType] = handler;
    print('[INFO] SyncServiceImpl: Registered handler for ${handler.entityType}');
  }

  /// Внутренний метод для обновления и трансляции текущего статуса синхронизации
  Future<void> _notifyStatusUpdate() async {
    try {
      final currentStatus = await getSyncStatus(); // Получаем актуальный статус
      if (!_statusController.isClosed) {
        _statusController.add(currentStatus); // Отправляем в поток
      }
    } catch (e, s) {
      print("[ERROR] SyncServiceImpl: Failed to get and notify sync status.\nError: $e\nStackTrace: $s");
      // Можно добавить 'ошибочный' статус в поток, если необходимо
       if (!_statusController.isClosed) {
         _statusController.add(SyncStatusInfo(
             lastErrorMessage: "Failed to retrieve sync status: $e",
             isOnline: false // Предполагаем худшее
             ));
       }
    }
  }

  @override
  Future<void> syncAll() async {
    if (_isSyncing) {
      print('[INFO] SyncServiceImpl: Sync already in progress. Skipping syncAll call.');
      return;
    }
    _isSyncing = true;
    _lastSyncErrorMessage = null; // Сбрасываем ошибку перед началом
    await _notifyStatusUpdate(); // Уведомляем о начале синхронизации
    print('[INFO] SyncServiceImpl: Starting full sync...');

    bool anySyncFailed = false;
    final Stopwatch stopwatch = Stopwatch()..start(); // Замеряем время

    try {
      // TODO: Проверить статус сети перед началом
      // final bool isOnline = await _networkStatusService.isOnline();
      // if (!isOnline) {
      //   print('[WARNING] SyncServiceImpl: No network connection. Aborting full sync.');
      //   _lastSyncErrorMessage = 'Нет сетевого подключения';
      //   throw Exception(_lastSyncErrorMessage);
      // }

      // Получаем времена последней синхронизации для всех типов *до* начала цикла
      final lastSyncTimes = await _lastSyncTimeService.getAllLastSyncTimes();

      // Синхронизируем последовательно все зарегистрированные типы
      for (final entityType in _entityHandlers.keys) {
        final lastSyncTimeForType = lastSyncTimes[entityType];
        await Future.delayed(const Duration(milliseconds: 50)); // Небольшая пауза
        try {
          await syncEntityType(entityType, lastSyncTimeOverride: lastSyncTimeForType);
        } catch (e) {
          anySyncFailed = true; // Помечаем, что была ошибка
          final errorMsg = 'Sync failed for $entityType: $e';
          _lastSyncErrorMessage = errorMsg; // Сохраняем последнюю ошибку
          print('[ERROR] SyncServiceImpl: Error during sync for $entityType. Continuing with next type. Error: $e');
          // Не прерываем всю синхронизацию, продолжаем с другими типами
          await _notifyStatusUpdate(); // Обновляем статус с ошибкой
        }
      }

      stopwatch.stop();
      if (!anySyncFailed) {
        _lastGlobalSyncAttemptCompletionTime = DateTime.now(); // Обновляем время успешного завершения
        print('[INFO] SyncServiceImpl: Full sync completed successfully in ${stopwatch.elapsedMilliseconds}ms.');
      } else {
        _lastGlobalSyncAttemptCompletionTime = DateTime.now(); // Обновляем время попытки (с ошибками)
        print('[WARNING] SyncServiceImpl: Full sync completed with errors in ${stopwatch.elapsedMilliseconds}ms.');
      }

    } catch (e, s) { // Ловим критические ошибки (например, проверка сети в начале)
      stopwatch.stop();
      _lastSyncErrorMessage = 'Overall sync failed critically: $e';
      print('[ERROR] SyncServiceImpl: Full sync failed critically in ${stopwatch.elapsedMilliseconds}ms.\nError: $e\nStackTrace: $s');
       _lastGlobalSyncAttemptCompletionTime = DateTime.now(); // Время попытки
    } finally {
      _isSyncing = false;
      await _notifyStatusUpdate(); // Уведомляем о завершении синхронизации (с любым результатом)
    }
  }

  @override
  Future<void> syncEntityType(EntityType entityType, {DateTime? lastSyncTimeOverride}) async {
    if (!_entityHandlers.containsKey(entityType)) {
      print('[WARNING] SyncServiceImpl: No handler registered for entity type: $entityType. Skipping sync.');
      return;
    }
    final handler = _entityHandlers[entityType]!;
    print('[INFO] SyncServiceImpl: Starting sync for entity type: $entityType');
    final Stopwatch stopwatch = Stopwatch()..start();

    // TODO: Здесь тоже можно добавить проверку сети, если syncEntityType может вызываться независимо
    // final bool isOnline = await _networkStatusService.isOnline();
    // if (!isOnline) {
    //   print('[WARNING] SyncServiceImpl ($entityType): No network connection. Skipping sync.');
    //   throw Exception('Нет сетевого подключения для синхронизации $entityType');
    // }

    try {
      // --- 1. Отправка локальных изменений ---
      print('[DEBUG] SyncServiceImpl ($entityType): Pushing local changes...');
      final localChanges = await handler.getPendingLocalChanges();
      print('[DEBUG] SyncServiceImpl ($entityType): Found ${localChanges.length} local changes to push.');
      int pushedCount = 0;
      int pushErrors = 0;
      for (final metadata in localChanges) {
        try {
          final localData = await handler.getLocalEntity(metadata.entityId);
          if (metadata.action != SyncAction.delete && localData == null) {
            print('[ERROR] SyncServiceImpl ($entityType): Local data for pending change ${metadata.id} (entity ${metadata.entityId}) not found, but action is ${metadata.action}. Marking as error.');
            await handler.markAsError(metadata, 'Local data not found for non-delete action.');
            pushErrors++;
            continue; // Пропускаем эту запись
          }
          await handler.pushLocalChange(metadata, localData);
          pushedCount++;
        } catch (e) {
           print('[ERROR] SyncServiceImpl ($entityType): Failed to push change for ${metadata.entityId}. Error: $e');
           pushErrors++;
           // Ошибка уже обработана и помечена в pushLocalChange или markAsError
        }
        await Future.delayed(const Duration(milliseconds: 20)); // Небольшая пауза
      }
      print('[DEBUG] SyncServiceImpl ($entityType): Finished pushing local changes (Pushed: $pushedCount, Errors: $pushErrors).');
      if (pushErrors > 0) await _notifyStatusUpdate(); // Обновить статус, если были ошибки отправки

      // --- 2. Получение удаленных изменений ---
      print('[DEBUG] SyncServiceImpl ($entityType): Fetching remote changes...');
      // Используем переданное время или получаем из сервиса
      DateTime? lastSync = lastSyncTimeOverride ?? await _lastSyncTimeService.getLastSyncTime(entityType);
      final remoteChangesMeta = await handler.fetchRemoteChanges(lastSync);
      print('[DEBUG] SyncServiceImpl ($entityType): Found ${remoteChangesMeta.length} remote changes to apply.');

      // --- 3. Применение удаленных изменений и разрешение конфликтов ---
      int appliedCount = 0;
      int applyErrors = 0;
      int conflictsResolved = 0;
      for (final remoteMeta in remoteChangesMeta) {
        try {
          final remoteData = remoteMeta.additionalData['remoteData'] as Map<String, dynamic>?;
          // Проверяем, есть ли смысл обрабатывать (например, если нет данных для не-удаления)
          if (remoteData == null && remoteMeta.action != SyncAction.delete) {
            print('[WARNING] SyncServiceImpl ($entityType): Remote metadata ${remoteMeta.id} (entity ${remoteMeta.entityId}) has no remoteData for non-delete action. Skipping.');
            continue;
          }

          final localMeta = await _syncMetadataService.getMetadata(remoteMeta.entityId, entityType);

          if (localMeta != null && localMeta.status != SyncStatus.synced) {
            // КОНФЛИКТ
            conflictsResolved++;
            print('[WARNING] SyncServiceImpl ($entityType): Conflict detected for entity ${remoteMeta.entityId}. Local status: ${localMeta.status}. Resolving...');
            final localData = await handler.getLocalEntity(localMeta.entityId);
            await handler.resolveConflict(localMeta, localData, remoteData);
          } else {
            // Нет конфликта, просто применяем
            print('[DEBUG] SyncServiceImpl ($entityType): Applying remote change for entity ${remoteMeta.entityId}.');
            await handler.applyRemoteChange(remoteMeta, remoteData ?? {});
            appliedCount++;
          }
        } catch (e) {
            print('[ERROR] SyncServiceImpl ($entityType): Failed to apply/resolve change for ${remoteMeta.entityId}. Error: $e');
            applyErrors++;
            // Можно попытаться пометить локальные метаданные (если они есть) как ошибочные,
            // но основная проблема - применение удаленного изменения.
            // Возможно, стоит просто залогировать и продолжить.
        }
        await Future.delayed(const Duration(milliseconds: 20)); // Небольшая пауза
      }
      print('[DEBUG] SyncServiceImpl ($entityType): Finished applying remote changes (Applied: $appliedCount, Conflicts: $conflictsResolved, Errors: $applyErrors).');
       if (applyErrors > 0 || conflictsResolved > 0) await _notifyStatusUpdate(); // Обновить статус

      // --- 4. Обновляем время последней *успешной* синхронизации для этого типа ---
      // Обновляем только если не было критических ошибок на этом шаге
      if (applyErrors == 0) { // Обновляем, даже если были конфликты, но они разрешились без ошибок
        final successfulSyncTime = DateTime.now();
        await _lastSyncTimeService.setLastSyncTime(entityType, successfulSyncTime);
      } else {
         print('[WARNING] SyncServiceImpl ($entityType): Not updating last sync time due to apply/resolve errors.');
      }

      stopwatch.stop();
      print('[INFO] SyncServiceImpl: Sync completed for entity type: $entityType in ${stopwatch.elapsedMilliseconds}ms.');

    } catch (e, s) { // Ловим ошибки конкретно для этого типа (например, ошибка сети при fetch)
      stopwatch.stop();
      print('[ERROR] SyncServiceImpl: Sync failed for entity type: $entityType in ${stopwatch.elapsedMilliseconds}ms.\nError: $e\nStackTrace: $s');
      throw Exception('Sync failed for $entityType: $e'); // Перевыбрасываем
    }
  }

  @override
  Future<void> syncEntity(String entityId, EntityType entityType) async {
    print('[INFO] SyncServiceImpl: Starting sync for specific entity: $entityType/$entityId');
     if (!_entityHandlers.containsKey(entityType)) {
      print('[WARNING] SyncServiceImpl: No handler registered for entity type: $entityType. Skipping syncEntity.');
      return;
    }
    final handler = _entityHandlers[entityType]!;
    final metadata = await _syncMetadataService.getMetadata(entityId, entityType);

    if (metadata == null || metadata.status == SyncStatus.synced) {
       print('[INFO] SyncServiceImpl: No pending changes found locally for $entityType/$entityId. Skipping push.');
       // Можно опционально добавить проверку удаленных изменений для этой сущности,
       // но это усложнит логику и может быть избыточно, если есть фоновая полная синхронизация.
       return;
    }

    // TODO: Проверить статус сети
    // if (!await _networkStatusService.isOnline()) { ... }

    try {
        print('[DEBUG] SyncServiceImpl: Pushing specific entity change for $entityType/$entityId, action: ${metadata.action}');
        final localData = await handler.getLocalEntity(metadata.entityId);
        if (metadata.action != SyncAction.delete && localData == null) {
           print('[ERROR] SyncServiceImpl ($entityType): Local data for pending change ${metadata.id} (entity ${metadata.entityId}) not found, but action is ${metadata.action}. Marking as error.');
           await handler.markAsError(metadata, 'Local data not found for non-delete action.');
        } else {
           await handler.pushLocalChange(metadata, localData);
           print('[INFO] SyncServiceImpl: Successfully pushed change for $entityType/$entityId.');
        }
    } catch (e, s) {
        print('[ERROR] SyncServiceImpl: Failed to push change for specific entity $entityType/$entityId.\nError: $e\nStackTrace: $s');
        // Ошибка уже должна быть обработана и статус обновлен в pushLocalChange/markAsError
    } finally {
       await _notifyStatusUpdate(); // Обновить статус в любом случае
    }
  }

  @override
  Future<SyncStatusInfo> getSyncStatus() async {
    final pending = await _syncMetadataService.getPendingChanges();
    final errors = pending.where((m) => m.status == SyncStatus.error).length;
    final pendingMap = <EntityType, int>{};
    for (var meta in pending) {
      pendingMap[meta.entityType] = (pendingMap[meta.entityType] ?? 0) + 1;
    }

    // TODO: Получить реальный статус сети
    bool isOnline = true; // ЗАГЛУШКА
    // try {
    //   isOnline = await _networkStatusService.isOnline();
    // } catch (e) {
    //   print("[ERROR] Failed to get network status: $e");
    //   isOnline = false; // Считаем оффлайн при ошибке
    // }

    return SyncStatusInfo(
      // Время последней УСПЕШНОЙ синхронизации пока не отслеживаем глобально,
      // используем время последней ПОПЫТКИ завершения syncAll
      lastSuccessfulSync: _lastGlobalSyncAttemptCompletionTime,
      isSyncing: _isSyncing,
      isOnline: isOnline,
      pendingChangesCount: pendingMap,
      errorCount: errors,
      lastErrorMessage: _lastSyncErrorMessage,
      // autoSyncEnabled: true, // Можно добавить поле, если нужно
    );
  }

  @override
  Stream<SyncStatusInfo> getSyncStatusStream() {
    // При первой подписке отправляем текущее состояние
    Future.microtask(() => _notifyStatusUpdate());
    return _statusController.stream;
  }

  /// Получает последне сохраненные времена синхронизации для всех типов сущностей.
  Future<Map<EntityType, DateTime?>> getLastSyncTimesForAllEntities() async {
    return await _lastSyncTimeService.getAllLastSyncTimes();
  }

  @override
  Future<void> startListeningToRemoteChanges() async {
    // TODO: Реализовать с использованием Firestore snapshots и _remoteChangeListenerService
    print('[WARNING] SyncServiceImpl: startListeningToRemoteChanges is not implemented yet.');
    throw UnimplementedError('startListeningToRemoteChanges is not implemented yet.');
  }

  @override
  Future<void> stopListeningToRemoteChanges() async {
    // TODO: Реализовать с использованием Firestore snapshots и _remoteChangeListenerService
    print('[WARNING] SyncServiceImpl: stopListeningToRemoteChanges is not implemented yet.');
    throw UnimplementedError('stopListeningToRemoteChanges is not implemented yet.');
  }

  @override
  Future<bool> hasPendingChanges() async {
    final pending = await _syncMetadataService.getPendingChanges();
    return pending.isNotEmpty;
  }

  @override
  Future<void> cleanupSyncMetadata({Duration? olderThan}) async {
    final threshold = DateTime.now().subtract(olderThan ?? const Duration(days: 7));
    print('[INFO] SyncServiceImpl: Cleaning up sync metadata older than $threshold');
    await _syncMetadataService.cleanupOldRecords(threshold);
    await _notifyStatusUpdate(); // Обновляем статус, т.к. количество ошибок/ожидающих могло измениться
  }

  @override
  Future<void> resetSyncState() async {
    print('[WARNING] SyncServiceImpl: Resetting sync state...');
    if (_isSyncing) {
        print('[WARNING] SyncServiceImpl: Cannot reset state while sync is in progress. Please wait.');
        return; // Не сбрасываем, если синхронизация идет
    }
    _isSyncing = true; // Блокируем на время сброса
    await _notifyStatusUpdate();

    try {
      // TODO: Остановить слушатели, если они реализованы
      // await stopListeningToRemoteChanges();
      // _networkStatusSubscription?.cancel(); // Отписываемся от сети

      // Удаляем все метаданные
      print('[INFO] SyncServiceImpl: Deleting all sync metadata...');
      final allMeta = await _syncMetadataService.getAllMetadata();
      int deletedCount = 0;
      for (final meta in allMeta) {
        try {
          await _syncMetadataService.deleteMetadata(meta.id);
          deletedCount++;
        } catch (e) {
           print('[ERROR] SyncServiceImpl: Failed to delete metadata ${meta.id} during reset. Error: $e');
        }
      }
      print('[INFO] SyncServiceImpl: Deleted $deletedCount sync metadata records.');

      // Сбрасываем время последней синхронизации для всех типов
      await _lastSyncTimeService.clearAllLastSyncTimes();
      _lastGlobalSyncAttemptCompletionTime = null;
      _lastSyncErrorMessage = null;

      print('[INFO] SyncServiceImpl: Sync state reset completed.');
    } catch(e, s) {
        print('[ERROR] SyncServiceImpl: Critical error during resetSyncState.\nError: $e\nStackTrace: $s');
        _lastSyncErrorMessage = "Failed to reset sync state: $e";
    } finally {
       _isSyncing = false; // Снимаем блокировку
       await _notifyStatusUpdate(); // Уведомляем об итоговом статусе
    }
     // Примечание: Этот метод НЕ удаляет сами данные (категории, задачи и т.д.).
  }

  /// Метод для очистки ресурсов сервиса. Вызывать при уничтожении провайдера.
  void dispose() {
    _statusController.close();
    // TODO: Отменить подписку на статус сети
    // _networkStatusSubscription?.cancel();
    // TODO: Остановить слушатели Firestore, если они запущены
    // stopListeningToRemoteChanges();
    print('[INFO] SyncServiceImpl disposed.');
  }
}