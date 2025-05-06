import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/database/local/database.dart';
import '../../domain/entities/sync/sync_metadata.dart';
import '../../domain/entities/sync/sync_status_info.dart';
import '../../domain/services/sync_service.dart';
import 'sync/entity_handlers/base_entity_handler.dart';
import 'sync/entity_handlers/category_sync_handler.dart';
import 'sync/sync_metadata_service.dart';
// import 'sync/network_status_service.dart'; // Пока не используем
// import 'sync/remote_change_listener_service.dart'; // Пока не используем
// import 'sync/sync_conflict_resolver.dart'; // Пока не используем

class SyncServiceImpl implements ISyncService {
  final FirebaseFirestore _firestore;
  final AppDatabase _localDatabase;
  final SyncMetadataService _syncMetadataService;
  // final NetworkStatusService _networkStatusService; // TODO: Добавить позже
  // final RemoteChangeListenerService _remoteChangeListenerService; // TODO: Добавить позже
  // final SyncConflictResolver _conflictResolver; // TODO: Добавить позже

  // Карта для хранения обработчиков для каждого типа сущности
  final Map<EntityType, BaseEntitySyncHandler> _entityHandlers = {};

  // Состояние синхронизации (упрощенное)
  // TODO: Заменить на StreamController и полноценное управление состоянием
  bool _isSyncing = false;
  DateTime? _lastSuccessfulSync;

  SyncServiceImpl({
    required FirebaseFirestore firestore,
    required AppDatabase localDatabase,
    required SyncMetadataService syncMetadataService,
    // TODO: Добавить остальные зависимости позже
  })  : _firestore = firestore,
        _localDatabase = localDatabase,
        _syncMetadataService = syncMetadataService {
    // Регистрируем обработчик категорий
    _registerHandler(CategorySyncHandler(
      firestore: _firestore,
      localDatabase: _localDatabase,
      syncMetadataService: _syncMetadataService,
      // TODO: Передать реальный логгер или убрать зависимость
      // log: /* SimpleLogger() ?? */ print, // Используем print как заглушку
    ));

    // TODO: Зарегистрировать другие обработчики (Tag, Task) здесь, когда они будут готовы
  }

  /// Регистрирует обработчик сущности.
  void _registerHandler(BaseEntitySyncHandler handler) {
    if (_entityHandlers.containsKey(handler.entityType)) {
      print(
          '[WARNING] SyncServiceImpl: Handler for ${handler.entityType} already registered. Overwriting.');
    }
    _entityHandlers[handler.entityType] = handler;
    print('[INFO] SyncServiceImpl: Registered handler for ${handler.entityType}');
  }

  @override
  Future<void> syncAll() async {
     // Простая проверка, чтобы не запускать несколько синхронизаций одновременно
    if (_isSyncing) {
      print('[INFO] SyncServiceImpl: Sync already in progress. Skipping syncAll call.');
      return;
    }
    _isSyncing = true;
    print('[INFO] SyncServiceImpl: Starting full sync...');

    try {
      // TODO: Проверить статус сети через _networkStatusService

      // Синхронизируем все зарегистрированные типы сущностей
      // Пока только категории
      for (final entityType in _entityHandlers.keys) {
         // Небольшая задержка между типами, чтобы снизить нагрузку
        await Future.delayed(Duration(milliseconds: 100));
        await syncEntityType(entityType);
      }

      _lastSuccessfulSync = DateTime.now(); // Обновляем время последней *успешной* синхронизации
      print('[INFO] SyncServiceImpl: Full sync completed successfully.');

    } catch (e, s) {
      print('[ERROR] SyncServiceImpl: Full sync failed.\nError: $e\nStackTrace: $s');
      // Здесь можно обновить статус с ошибкой
    } finally {
      _isSyncing = false; // Снимаем флаг в любом случае
    }
  }

  @override
  Future<void> syncEntityType(EntityType entityType) async {
    print('[INFO] SyncServiceImpl: Starting sync for entity type: $entityType');
    final handler = _entityHandlers[entityType];
    if (handler == null) {
      print('[WARNING] SyncServiceImpl: No handler registered for entity type: $entityType. Skipping.');
      return;
    }

    // TODO: Проверить статус сети

    try {
      // 1. Отправка локальных изменений
      print('[DEBUG] SyncServiceImpl ($entityType): Pushing local changes...');
      final localChanges = await handler.getPendingLocalChanges();
      print('[DEBUG] SyncServiceImpl ($entityType): Found ${localChanges.length} local changes to push.');
      for (final metadata in localChanges) {
         // Получаем актуальные локальные данные перед отправкой
         // ID сущности берем из метаданных
         final localData = await handler.getLocalEntity(metadata.entityId);
         // Если действие не delete, а данных нет - это ошибка метаданных
         if (metadata.action != SyncAction.delete && localData == null) {
            print('[ERROR] SyncServiceImpl ($entityType): Local data for pending change ${metadata.id} (entity ${metadata.entityId}) not found, but action is ${metadata.action}. Marking as error.');
            await handler.markAsError(metadata, 'Local data not found for non-delete action.');
            continue; // Пропускаем эту запись
         }
         // Отправляем изменение (даже если localData null для delete)
         await handler.pushLocalChange(metadata, localData);
         await Future.delayed(Duration(milliseconds: 50)); // Небольшая пауза
      }
       print('[DEBUG] SyncServiceImpl ($entityType): Finished pushing local changes.');

      // 2. Получение удаленных изменений
      print('[DEBUG] SyncServiceImpl ($entityType): Fetching remote changes...');
      // TODO: Получать реальное время последней синхронизации для этого типа
      DateTime? lastSync = await _getLastSyncTimeForType(entityType); // Заглушка
      final remoteChangesMeta = await handler.fetchRemoteChanges(lastSync);
      print('[DEBUG] SyncServiceImpl ($entityType): Found ${remoteChangesMeta.length} remote changes to apply.');

      // 3. Применение удаленных изменений и разрешение конфликтов
      for (final remoteMeta in remoteChangesMeta) {
        final remoteData = remoteMeta.additionalData['remoteData'] as Map<String, dynamic>?;
        if (remoteData == null && remoteMeta.action != SyncAction.delete) {
           print('[WARNING] SyncServiceImpl ($entityType): Remote metadata ${remoteMeta.id} (entity ${remoteMeta.entityId}) has no remoteData for non-delete action. Skipping.');
           continue;
        }

        // Проверяем наличие локальных метаданных для этой же сущности
        final localMeta = await _syncMetadataService.getMetadata(remoteMeta.entityId, entityType);

        if (localMeta != null && localMeta.status != SyncStatus.synced) {
          // КОНФЛИКТ! Локальные изменения еще не синхронизированы или в ошибке.
          print('[WARNING] SyncServiceImpl ($entityType): Conflict detected for entity ${remoteMeta.entityId}. Local status: ${localMeta.status}.');
          final localData = await handler.getLocalEntity(localMeta.entityId);
          // Передаем разрешение конфликта обработчику
          await handler.resolveConflict(localMeta, localData, remoteData);
        } else {
          // Нет конфликта, просто применяем удаленное изменение
          print('[DEBUG] SyncServiceImpl ($entityType): Applying remote change for entity ${remoteMeta.entityId}.');
          await handler.applyRemoteChange(remoteMeta, remoteData ?? {}); // Передаем пустой map для delete
        }
         await Future.delayed(Duration(milliseconds: 50)); // Небольшая пауза
      }
       print('[DEBUG] SyncServiceImpl ($entityType): Finished applying remote changes.');

      // 4. Обновляем время последней синхронизации для данного типа (успешной)
      await _updateLastSyncTimeForType(entityType, DateTime.now()); // Заглушка

      print('[INFO] SyncServiceImpl: Sync completed for entity type: $entityType');

    } catch (e, s) {
      print('[ERROR] SyncServiceImpl: Sync failed for entity type: $entityType.\nError: $e\nStackTrace: $s');
      // Можно пометить все ожидающие записи этого типа как ошибочные или выбросить исключение выше
      throw Exception('Sync failed for $entityType: $e');
    }
  }

  // --- Заглушки для времени последней синхронизации по типу ---
  // TODO: Реализовать хранение времени последней синхронизации для каждого типа,
  // например, в SharedPreferences или отдельной таблице/записи в БД/Firestore.
  Future<DateTime?> _getLastSyncTimeForType(EntityType entityType) async {
     print('[WARNING] SyncServiceImpl: _getLastSyncTimeForType is a placeholder!');
     // Пока возвращаем общее время или null для полной загрузки
     return _lastSuccessfulSync;
     // return null; // Для теста полной загрузки
  }
  Future<void> _updateLastSyncTimeForType(EntityType entityType, DateTime time) async {
     print('[WARNING] SyncServiceImpl: _updateLastSyncTimeForType is a placeholder!');
     // Пока просто обновляем общее время
     _lastSuccessfulSync = time;
  }
  // --- Конец заглушек ---


  @override
  Future<void> syncEntity(String entityId, EntityType entityType) async {
    // TODO: Реализовать логику синхронизации для одной сущности
    // 1. Найти обработчик
    // 2. Получить метаданные для этой сущности
    // 3. Если есть - вызвать pushLocalChange
    print('[WARNING] SyncServiceImpl: syncEntity is not implemented yet.');
     throw UnimplementedError('syncEntity is not implemented yet.');
  }

  @override
  Future<SyncStatusInfo> getSyncStatus() async {
    // TODO: Реализовать получение реального статуса
    // - Учесть _isSyncing
    // - Получить статус сети из _networkStatusService
    // - Подсчитать pendingChanges и errorCount из _syncMetadataService
    print('[WARNING] SyncServiceImpl: getSyncStatus provides placeholder data.');
    final pending = await _syncMetadataService.getPendingChanges();
    final errors = pending.where((m) => m.status == SyncStatus.error).length;
    final pendingMap = <EntityType, int>{};
    for (var meta in pending) {
       pendingMap[meta.entityType] = (pendingMap[meta.entityType] ?? 0) + 1;
    }

    return SyncStatusInfo(
      lastSuccessfulSync: _lastSuccessfulSync,
      isSyncing: _isSyncing,
      isOnline: true, // Заглушка
      pendingChangesCount: pendingMap,
      errorCount: errors,
    );
  }

  @override
  Stream<SyncStatusInfo> getSyncStatusStream() {
    // TODO: Реализовать через StreamController, который обновляется
    // при изменении статуса (_isSyncing, _lastSuccessfulSync, ошибки, network status)
     print('[WARNING] SyncServiceImpl: getSyncStatusStream is not implemented yet.');
    // Временная заглушка: возвращает текущий статус раз в 5 секунд
    return Stream.periodic(Duration(seconds: 5), (_) => getSyncStatus()).asyncMap((event) async => await event);
     // throw UnimplementedError('getSyncStatusStream is not fully implemented yet.');
  }


  @override
  Future<void> startListeningToRemoteChanges() async {
    // TODO: Использовать _remoteChangeListenerService
     print('[WARNING] SyncServiceImpl: startListeningToRemoteChanges is not implemented yet.');
    throw UnimplementedError('startListeningToRemoteChanges is not implemented yet.');
  }

  @override
  Future<void> stopListeningToRemoteChanges() async {
    // TODO: Использовать _remoteChangeListenerService
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
    // Удаляем записи старше недели по умолчанию
    final threshold = DateTime.now().subtract(olderThan ?? const Duration(days: 7));
    print('[INFO] SyncServiceImpl: Cleaning up sync metadata older than $threshold');
    await _syncMetadataService.cleanupOldRecords(threshold);
  }

  @override
  Future<void> resetSyncState() async {
    // TODO: Реализовать полный сброс
    // - Остановить слушатели
    // - Удалить ВСЕ метаданные
    // - Сбросить время последней синхронизации
    print('[WARNING] SyncServiceImpl: resetSyncState is not fully implemented yet.');
    _lastSuccessfulSync = null;
    // await _syncMetadataService.deleteAllMetadata(); // Нужен метод в DAO/Service
    print('[INFO] SyncServiceImpl: Sync state partially reset (last sync time cleared). Metadata deletion required.');
    throw UnimplementedError('resetSyncState requires deleteAllMetadata implementation.');
  }
}