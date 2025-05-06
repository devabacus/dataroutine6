import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/database/local/database.dart';
import '../../../../core/services/network_status_service.dart'; // Убедитесь, что импорт правильный
import '../../domain/entities/sync/sync_metadata.dart';
import '../../domain/entities/sync/sync_status_info.dart';
import '../../domain/services/sync_service.dart';
import 'sync/entity_handlers/base_entity_handler.dart';
import 'sync/entity_handlers/category_sync_handler.dart';
// TODO: Импортировать другие обработчики
import 'sync/sync_metadata_service.dart';
import 'sync/last_sync_time_service.dart';

class SyncServiceImpl implements ISyncService {
  final FirebaseFirestore _firestore;
  final AppDatabase _localDatabase;
  final SyncMetadataService _syncMetadataService;
  final LastSyncTimeService _lastSyncTimeService;
  final NetworkStatusService _networkStatusService; // Поле

  final Map<EntityType, BaseEntitySyncHandler> _entityHandlers = {};
  final _statusController = StreamController<SyncStatusInfo>.broadcast();

  bool _isSyncing = false;
  DateTime? _lastGlobalSyncAttemptCompletionTime;
  String? _lastSyncErrorMessage;
  StreamSubscription<bool>? _networkStatusSubscription; // Подписка
  bool _isOnline = true; // Текущий статус

  SyncServiceImpl({
    required FirebaseFirestore firestore,
    required AppDatabase localDatabase,
    required SyncMetadataService syncMetadataService,
    required LastSyncTimeService lastSyncTimeService,
    required NetworkStatusService networkStatusService,
  })  : _firestore = firestore,
        _localDatabase = localDatabase,
        _syncMetadataService = syncMetadataService,
        _lastSyncTimeService = lastSyncTimeService,
        _networkStatusService = networkStatusService {

    // Регистрация обработчиков
    _registerHandler(CategorySyncHandler(
      firestore: _firestore,
      localDatabase: _localDatabase,
      syncMetadataService: _syncMetadataService,
    ));
    // TODO: Зарегистрировать другие обработчики

    // Инициализация слушателя сети - РАСКОММЕНТИРОВАНО
    _initializeNetworkListener();

    print('[INFO] SyncServiceImpl initialized.');
  }

  /// Инициализация слушателя состояния сети - РАСКОММЕНТИРОВАНО
  void _initializeNetworkListener() {
      _networkStatusService.isOnline().then((status) {
        _isOnline = status;
        print("[INFO] SyncServiceImpl: Initial network status: ${_isOnline ? 'Online' : 'Offline'}");
        _notifyStatusUpdate(); // Уведомляем начальным статусом
      }).catchError((e) {
         print("[ERROR] SyncServiceImpl: Failed to get initial network status: $e");
         _isOnline = false; // Считаем оффлайн при ошибке
         _notifyStatusUpdate();
      });

      _networkStatusSubscription = _networkStatusService.onlineStatusStream.listen(
        (isOnlineUpdate) {
           if (_isOnline != isOnlineUpdate) { // Реагируем только на изменения
              print("[INFO] SyncServiceImpl: Network status changed via stream: ${isOnlineUpdate ? 'Online' : 'Offline'}");
              _isOnline = isOnlineUpdate;
              _notifyStatusUpdate(); // Уведомляем об изменении статуса сети
              if (_isOnline) {
                 print("[INFO] SyncServiceImpl: Network is back online. Pending changes might be synced on next trigger.");
              }
           }
        },
        onError: (error) {
           print("[ERROR] SyncServiceImpl: Error in network status stream: $error");
           if (!_isOnline) return;
           _isOnline = false;
           _notifyStatusUpdate();
        }
      );
  }

  void _registerHandler(BaseEntitySyncHandler handler) {
    if (_entityHandlers.containsKey(handler.entityType)) {
       print('[WARNING] SyncServiceImpl: Handler for ${handler.entityType} already registered. Overwriting.');
    }
    _entityHandlers[handler.entityType] = handler;
    print('[INFO] SyncServiceImpl: Registered handler for ${handler.entityType}');
  }

  Future<void> _notifyStatusUpdate() async {
     try {
       final currentStatus = await getSyncStatus();
       if (!_statusController.isClosed) {
         _statusController.add(currentStatus);
       }
     } catch (e, s) {
       print("[ERROR] SyncServiceImpl: Failed to get and notify sync status.\nError: $e\nStackTrace: $s");
        if (!_statusController.isClosed) {
          _statusController.add(SyncStatusInfo(
              lastErrorMessage: "Failed to retrieve sync status: $e",
              isOnline: false
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
    // Проверка сети ПЕРЕД началом - РАСКОММЕНТИРОВАНО
    if (!_isOnline) {
      print('[WARNING] SyncServiceImpl: No network connection (_isOnline=false). Aborting full sync.');
      _lastSyncErrorMessage = 'Нет сетевого подключения';
      await _notifyStatusUpdate();
      return;
    }

    _isSyncing = true;
    _lastSyncErrorMessage = null;
    await _notifyStatusUpdate();
    print('[INFO] SyncServiceImpl: Starting full sync (Network: Online)...');

    bool anySyncFailed = false;
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      final lastSyncTimes = await _lastSyncTimeService.getAllLastSyncTimes();

      for (final entityType in _entityHandlers.keys) {
        final lastSyncTimeForType = lastSyncTimes[entityType];
        await Future.delayed(const Duration(milliseconds: 50));
        try {
          // Передаем текущий статус сети
          await syncEntityType(entityType, lastSyncTimeOverride: lastSyncTimeForType, currentOnlineStatus: _isOnline);
        } catch (e) {
          anySyncFailed = true;
          final errorMsg = 'Sync failed for $entityType: $e';
          _lastSyncErrorMessage = errorMsg;
          print('[ERROR] SyncServiceImpl: Error during sync for $entityType. Continuing. Error: $e');
          await _notifyStatusUpdate();
        }
      }
      stopwatch.stop();
      if (!anySyncFailed) {
        _lastGlobalSyncAttemptCompletionTime = DateTime.now();
        print('[INFO] SyncServiceImpl: Full sync completed successfully in ${stopwatch.elapsedMilliseconds}ms.');
      } else {
        _lastGlobalSyncAttemptCompletionTime = DateTime.now();
        print('[WARNING] SyncServiceImpl: Full sync completed with errors in ${stopwatch.elapsedMilliseconds}ms.');
      }
    } catch (e, s) {
      stopwatch.stop();
      _lastSyncErrorMessage = 'Overall sync failed critically: $e';
      print('[ERROR] SyncServiceImpl: Full sync failed critically in ${stopwatch.elapsedMilliseconds}ms.\nError: $e\nStackTrace: $s');
       _lastGlobalSyncAttemptCompletionTime = DateTime.now();
    } finally {
      _isSyncing = false;
      await _notifyStatusUpdate();
    }
  }

  @override
  Future<void> syncEntityType(EntityType entityType, {DateTime? lastSyncTimeOverride, bool? currentOnlineStatus}) async {
    final isOnline = currentOnlineStatus ?? _isOnline;

    // Проверка сети в начале метода - РАСКОММЕНТИРОВАНО
    if (!isOnline) {
      print('[WARNING] SyncServiceImpl ($entityType): No network connection. Skipping sync.');
      _lastSyncErrorMessage = 'Нет сети для синхронизации $entityType';
      await _notifyStatusUpdate(); // Обновляем статус, чтобы показать ошибку сети
      // Не выбрасываем исключение, чтобы syncAll мог продолжить
      return;
    }

    if (!_entityHandlers.containsKey(entityType)) {
       print('[WARNING] SyncServiceImpl: No handler registered for entity type: $entityType. Skipping sync.');
       return;
    }
    final handler = _entityHandlers[entityType]!;
    print('[INFO] SyncServiceImpl: Starting sync for entity type: $entityType (Network: Online)');
    final Stopwatch stopwatch = Stopwatch()..start();

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
            continue;
          }
          await handler.pushLocalChange(metadata, localData);
          pushedCount++;
        } catch (e) {
           print('[ERROR] SyncServiceImpl ($entityType): Failed to push change for ${metadata.entityId}. Error: $e');
           pushErrors++;
        }
        await Future.delayed(const Duration(milliseconds: 20));
      }
      print('[DEBUG] SyncServiceImpl ($entityType): Finished pushing local changes (Pushed: $pushedCount, Errors: $pushErrors).');
      if (pushErrors > 0) await _notifyStatusUpdate();

      // --- 2. Получение удаленных изменений ---
      print('[DEBUG] SyncServiceImpl ($entityType): Fetching remote changes...');
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
          if (remoteData == null && remoteMeta.action != SyncAction.delete) {
            print('[WARNING] SyncServiceImpl ($entityType): Remote metadata ${remoteMeta.id} (entity ${remoteMeta.entityId}) has no remoteData for non-delete action. Skipping.');
            continue;
          }
          final localMeta = await _syncMetadataService.getMetadata(remoteMeta.entityId, entityType);

          if (localMeta != null && localMeta.status != SyncStatus.synced) {
            conflictsResolved++;
            print('[WARNING] SyncServiceImpl ($entityType): Conflict detected for entity ${remoteMeta.entityId}. Local status: ${localMeta.status}. Resolving...');
            final localData = await handler.getLocalEntity(localMeta.entityId);
            await handler.resolveConflict(localMeta, localData, remoteData);
          } else {
            print('[DEBUG] SyncServiceImpl ($entityType): Applying remote change for entity ${remoteMeta.entityId}.');
            await handler.applyRemoteChange(remoteMeta, remoteData ?? {});
            appliedCount++;
          }
        } catch (e) {
            print('[ERROR] SyncServiceImpl ($entityType): Failed to apply/resolve change for ${remoteMeta.entityId}. Error: $e');
            applyErrors++;
        }
        await Future.delayed(const Duration(milliseconds: 20));
      }
      print('[DEBUG] SyncServiceImpl ($entityType): Finished applying remote changes (Applied: $appliedCount, Conflicts: $conflictsResolved, Errors: $applyErrors).');
       if (applyErrors > 0 || conflictsResolved > 0) await _notifyStatusUpdate();

      // --- 4. Обновляем время последней *успешной* синхронизации ---
      if (applyErrors == 0) {
        final successfulSyncTime = DateTime.now();
        await _lastSyncTimeService.setLastSyncTime(entityType, successfulSyncTime);
      } else {
         print('[WARNING] SyncServiceImpl ($entityType): Not updating last sync time due to apply/resolve errors.');
      }

      stopwatch.stop();
      print('[INFO] SyncServiceImpl: Sync completed for entity type: $entityType in ${stopwatch.elapsedMilliseconds}ms.');

    } catch (e, s) {
      stopwatch.stop();
      print('[ERROR] SyncServiceImpl: Sync failed for entity type: $entityType in ${stopwatch.elapsedMilliseconds}ms.\nError: $e\nStackTrace: $s');
      throw Exception('Sync failed for $entityType: $e');
    }
  }

  @override
  Future<void> syncEntity(String entityId, EntityType entityType) async {
     if (!_isOnline) { // <-- ПРОВЕРКА СЕТИ - РАСКОММЕНТИРОВАНО
       print('[WARNING] SyncServiceImpl: No network connection. Skipping syncEntity for $entityType/$entityId.');
        _lastSyncErrorMessage = 'Нет сети для синхронизации $entityType/$entityId';
        await _notifyStatusUpdate();
       return;
     }

     // ... (остальная логика syncEntity) ...
      if (!_entityHandlers.containsKey(entityType)) { return; }
      final handler = _entityHandlers[entityType]!;
      final metadata = await _syncMetadataService.getMetadata(entityId, entityType);
      if (metadata == null || metadata.status == SyncStatus.synced) { return; }

      try {
          print('[DEBUG] SyncServiceImpl: Pushing specific entity change for $entityType/$entityId, action: ${metadata.action}');
          final localData = await handler.getLocalEntity(metadata.entityId);
          if (metadata.action != SyncAction.delete && localData == null) {
            await handler.markAsError(metadata, 'Local data not found for non-delete action.');
          } else {
            await handler.pushLocalChange(metadata, localData);
            print('[INFO] SyncServiceImpl: Successfully pushed change for $entityType/$entityId.');
          }
      } catch (e, s) {
          print('[ERROR] SyncServiceImpl: Failed to push change for specific entity $entityType/$entityId.\nError: $e\nStackTrace: $s');
      } finally {
          await _notifyStatusUpdate();
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

    // Используем актуальное состояние сети из поля _isOnline - РАСКОММЕНТИРОВАНО
    // (оно обновляется слушателем)
    bool currentIsOnline = _isOnline;

    return SyncStatusInfo(
      lastSuccessfulSync: _lastGlobalSyncAttemptCompletionTime,
      isSyncing: _isSyncing,
      isOnline: currentIsOnline, // <-- Используем _isOnline
      pendingChangesCount: pendingMap,
      errorCount: errors,
      lastErrorMessage: _lastSyncErrorMessage,
    );
  }

  @override
  Stream<SyncStatusInfo> getSyncStatusStream() {
    Future.microtask(() => _notifyStatusUpdate());
    return _statusController.stream;
  }

  Future<Map<EntityType, DateTime?>> getLastSyncTimesForAllEntities() async {
    return await _lastSyncTimeService.getAllLastSyncTimes();
  }

  @override
  Future<void> startListeningToRemoteChanges() async {
    // TODO: Реализовать
    print('[WARNING] SyncServiceImpl: startListeningToRemoteChanges is not implemented yet.');
    throw UnimplementedError('startListeningToRemoteChanges is not implemented yet.');
  }

  @override
  Future<void> stopListeningToRemoteChanges() async {
    // TODO: Реализовать
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
     // ... (код без изменений)
  }

  @override
  Future<void> resetSyncState() async {
    // ... (код без изменений)
  }

  /// Метод для очистки ресурсов сервиса.
  void dispose() {
    print('[INFO] SyncServiceImpl disposing...');
    // Отменяем подписку на сеть - РАСКОММЕНТИРОВАНО
    _networkStatusSubscription?.cancel();
    _statusController.close();
    // TODO: Остановить слушатели Firestore, если они запущены
    // stopListeningToRemoteChanges();
    print('[INFO] SyncServiceImpl disposed.');
  }
}