import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/database/local/database.dart';
import '../../../../core/services/network_status_service.dart';
import '../../domain/entities/sync/sync_metadata.dart';
import '../../domain/entities/sync/sync_status_info.dart';
import '../../domain/services/sync_service.dart';
import 'sync/entity_handlers/base_entity_handler.dart';
import 'sync/entity_handlers/category_sync_handler.dart';
// --- НОВОЕ: Импорт менеджера слушателей ---
import 'sync/firestore_listener_manager.dart';
// TODO: Импортировать другие обработчики
import 'sync/sync_metadata_service.dart';
import 'sync/last_sync_time_service.dart';

class SyncServiceImpl implements ISyncService {
  final FirebaseFirestore _firestore;
  final AppDatabase _localDatabase;
  final SyncMetadataService _syncMetadataService;
  final LastSyncTimeService _lastSyncTimeService;
  final NetworkStatusService _networkStatusService; // Оставляем, т.к. нужен для SyncStatusInfo
  StreamSubscription<bool>? _networkStatusSubscription;


  final Map<EntityType, BaseEntitySyncHandler> _entityHandlers = {};
  final _statusController = StreamController<SyncStatusInfo>.broadcast();

  // --- НОВОЕ: Экземпляр менеджера слушателей ---
  late final FirestoreListenerManager _listenerManager;

  bool _isSyncing = false;
  DateTime? _lastGlobalSyncAttemptCompletionTime;
  String? _lastSyncErrorMessage;
  // --- УДАЛЕНО: Управление подпиской на сеть переехало в FirestoreListenerManager ---
  // StreamSubscription<bool>? _networkStatusSubscription;
  bool _isOnline = true; // Оставляем для getSyncStatus

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
        _networkStatusService = networkStatusService { // Передаем networkStatusService

    _registerHandler(CategorySyncHandler(
      firestore: _firestore,
      localDatabase: _localDatabase,
      syncMetadataService: _syncMetadataService,
    ));
    // TODO: Зарегистрировать другие обработчики

    // --- ИЗМЕНЕНО: Инициализация менеджера слушателей ---
    _listenerManager = FirestoreListenerManager(
      firestore: _firestore,
      entityHandlers: _entityHandlers, // Передаем карту обработчиков
      syncMetadataService: _syncMetadataService,
      networkStatusService: _networkStatusService, // Передаем сервис сети
      onRemoteChangeApplied: _notifyStatusUpdate, // Передаем колбэк для обновления статуса
    );

    // --- ИЗМЕНЕНО: Упрощенная инициализация слушателя сети ---
    // Просто получаем начальный статус сети для getSyncStatus
     _networkStatusService.isOnline().then((status) => _isOnline = status);
     // Подписка на статус сети для обновления _isOnline и уведомления UI
     // (слушатель Firestore управляется теперь менеджером)
      _networkStatusSubscription = _networkStatusService.onlineStatusStream.listen(
        (isOnlineUpdate) {
            if (_isOnline != isOnlineUpdate) {
              _isOnline = isOnlineUpdate;
              _notifyStatusUpdate(); // Уведомляем UI об изменении статуса сети
            }
        },
        onError: (e) {
            if (_isOnline) {
              _isOnline = false;
              _notifyStatusUpdate();
            }
            print("[ERROR] SyncServiceImpl: Error in network status stream: $e");
        }
      );


    print('[INFO] SyncServiceImpl initialized.');
  }

  void _registerHandler(BaseEntitySyncHandler handler) {
     if (_entityHandlers.containsKey(handler.entityType)) {
       print('[WARNING] SyncServiceImpl: Handler for ${handler.entityType} already registered. Overwriting.');
     }
     _entityHandlers[handler.entityType] = handler;
     print('[INFO] SyncServiceImpl: Registered handler for ${handler.entityType}');
   }

   Future<void> _notifyStatusUpdate() async {
     // Проверяем, не закрыт ли контроллер перед добавлением
     if (!_statusController.isClosed) {
        try {
          final currentStatus = await getSyncStatus(); // Получаем актуальный статус
          _statusController.add(currentStatus);
        } catch (e, s) {
           print("[ERROR] SyncServiceImpl: Failed to get and notify sync status.\nError: $e\nStackTrace: $s");
            _statusController.add(SyncStatusInfo(
              lastErrorMessage: "Failed to retrieve sync status: $e",
              isOnline: _isOnline, // Используем текущее известное значение
              isListening: _listenerManager.isListening, // Получаем от менеджера
            ));
        }
     } else {
        print("[WARNING] SyncServiceImpl: Attempted to notify status update on a closed controller.");
     }
   }


  @override
  Future<void> syncAll() async {
    if (_isSyncing) {
      print('[INFO] SyncServiceImpl: Sync already in progress. Skipping syncAll call.');
      return;
    }
    // --- ИЗМЕНЕНО: Проверяем _isOnline напрямую ---
    if (!_isOnline) {
      print('[WARNING] SyncServiceImpl: No network connection. Aborting full sync.');
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
        await Future.delayed(const Duration(milliseconds: 50)); // Небольшая задержка
        try {
          // --- ИЗМЕНЕНО: Передаем текущий _isOnline ---
          await syncEntityType(entityType, lastSyncTimeOverride: lastSyncTimeForType, currentOnlineStatus: _isOnline);
        } catch (e) {
           anySyncFailed = true;
           final errorMsg = 'Sync failed for $entityType: $e';
           _lastSyncErrorMessage = (_lastSyncErrorMessage == null) ? errorMsg : '$_lastSyncErrorMessage; $errorMsg';
           print('[ERROR] SyncServiceImpl: Error during sync for $entityType. Continuing. Error: $e');
           // Не вызываем _notifyStatusUpdate здесь, чтобы не спамить обновлениями
        }
      }
      stopwatch.stop();
      if (!anySyncFailed) {
        _lastGlobalSyncAttemptCompletionTime = DateTime.now();
        print('[INFO] SyncServiceImpl: Full sync completed successfully in ${stopwatch.elapsedMilliseconds}ms.');
      } else {
         _lastGlobalSyncAttemptCompletionTime = DateTime.now(); // Время завершения попытки
        print('[WARNING] SyncServiceImpl: Full sync completed with errors in ${stopwatch.elapsedMilliseconds}ms.');
      }
    } catch (e, s) {
      stopwatch.stop();
      _lastSyncErrorMessage = 'Overall sync failed critically: $e';
      print('[ERROR] SyncServiceImpl: Full sync failed critically in ${stopwatch.elapsedMilliseconds}ms.\nError: $e\nStackTrace: $s');
      _lastGlobalSyncAttemptCompletionTime = DateTime.now();
    } finally {
      _isSyncing = false;
      await _notifyStatusUpdate(); // Уведомляем о завершении синхронизации
    }
  }

   @override
  Future<void> syncEntityType(EntityType entityType, {DateTime? lastSyncTimeOverride, bool? currentOnlineStatus}) async {
    // --- ИЗМЕНЕНО: Используем переданный или текущий _isOnline ---
    final isOnline = currentOnlineStatus ?? _isOnline;

    if (!isOnline) {
      print('[WARNING] SyncServiceImpl ($entityType): No network connection. Skipping sync.');
      _lastSyncErrorMessage = 'Нет сети для синхронизации $entityType';
      // Не выбрасываем исключение, а просто выходим
      return;
    }
    // ... (остальная логика метода syncEntityType остается почти без изменений)
    // ... она отвечает за пакетную обработку и разрешение конфликтов ...
     if (!_entityHandlers.containsKey(entityType)) {
       print('[WARNING] SyncServiceImpl: No handler registered for entity type: $entityType. Skipping sync.');
       return;
     }
     final handler = _entityHandlers[entityType]!;
     print('[INFO] SyncServiceImpl: Starting sync for entity type: $entityType (Network: Online)');
     final Stopwatch stopwatch = Stopwatch()..start();
     bool operationFailed = false; // Флаг для отслеживания ошибок в этом вызове

     try {
       // --- 1. Отправка локальных изменений ---
       print('[DEBUG] SyncServiceImpl ($entityType): Pushing local changes...');
       final localChanges = await handler.getPendingLocalChanges();
       print('[DEBUG] SyncServiceImpl ($entityType): Found ${localChanges.length} local changes to push.');
       int pushedCount = 0;
       int pushErrors = 0;
       for (final metadata in localChanges) {
         // Проверка сети перед каждой отправкой (на случай, если пропала во время цикла)
         if (!_isOnline) {
           print('[WARNING] SyncServiceImpl ($entityType): Network lost during push loop. Aborting further pushes.');
           operationFailed = true;
           _lastSyncErrorMessage = 'Сеть пропала во время отправки изменений $entityType';
           break;
         }
         try {
           final localData = await handler.getLocalEntity(metadata.entityId);
           if (metadata.action != SyncAction.delete && localData == null) {
             print('[ERROR] SyncServiceImpl ($entityType): Local data for pending change ${metadata.id} (entity ${metadata.entityId}) not found, but action is ${metadata.action}. Marking as error.');
             await handler.markAsError(metadata, 'Local data not found for non-delete action.');
             pushErrors++;
             operationFailed = true;
             continue;
           }
           await handler.pushLocalChange(metadata, localData);
           pushedCount++;
         } catch (e) {
           print('[ERROR] SyncServiceImpl ($entityType): Failed to push change for ${metadata.entityId}. Error: $e');
           pushErrors++;
           operationFailed = true;
         }
         await Future.delayed(const Duration(milliseconds: 20)); // Небольшая пауза
       }
       print('[DEBUG] SyncServiceImpl ($entityType): Finished pushing local changes (Pushed: $pushedCount, Errors: $pushErrors).');


       // --- 2. Получение удаленных изменений ---
       // Проверяем сеть снова перед запросом
       if (!_isOnline) {
         print('[WARNING] SyncServiceImpl ($entityType): Network lost before fetching remote changes. Skipping fetch.');
         operationFailed = true;
         _lastSyncErrorMessage = 'Сеть пропала перед получением изменений $entityType';
       } else {
           print('[DEBUG] SyncServiceImpl ($entityType): Fetching remote changes...');
           DateTime? lastSync = lastSyncTimeOverride ?? await _lastSyncTimeService.getLastSyncTime(entityType);
           final remoteChangesMeta = await handler.fetchRemoteChanges(lastSync);
           print('[DEBUG] SyncServiceImpl ($entityType): Found ${remoteChangesMeta.length} remote changes to apply.');

           // --- 3. Применение удаленных изменений и разрешение конфликтов ---
           int appliedCount = 0;
           int applyErrors = 0;
           int conflictsResolved = 0;
           for (final remoteMeta in remoteChangesMeta) {
             // Проверка сети перед каждым применением
             if (!_isOnline) {
               print('[WARNING] SyncServiceImpl ($entityType): Network lost during apply loop. Aborting further applies.');
               operationFailed = true;
               _lastSyncErrorMessage = 'Сеть пропала во время применения изменений $entityType';
               break;
             }
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
                 operationFailed = true;
             }
             await Future.delayed(const Duration(milliseconds: 20)); // Небольшая пауза
           }
           print('[DEBUG] SyncServiceImpl ($entityType): Finished applying remote changes (Applied: $appliedCount, Conflicts: $conflictsResolved, Errors: $applyErrors).');


            // --- 4. Обновляем время последней *успешной* синхронизации ---
            // Обновляем только если ВСЯ операция (push и pull) для этого типа прошла без ошибок
            if (!operationFailed) {
               final successfulSyncTime = DateTime.now();
               await _lastSyncTimeService.setLastSyncTime(entityType, successfulSyncTime);
            } else {
               print('[WARNING] SyncServiceImpl ($entityType): Not updating last sync time due to errors during push/apply/resolve.');
            }
       } // end else (if online before fetch)

       stopwatch.stop();
       if (!operationFailed) {
           print('[INFO] SyncServiceImpl: Sync completed successfully for entity type: $entityType in ${stopwatch.elapsedMilliseconds}ms.');
       } else {
            print('[WARNING] SyncServiceImpl: Sync completed with errors for entity type: $entityType in ${stopwatch.elapsedMilliseconds}ms.');
            // Генерируем исключение, если были ошибки, чтобы syncAll() знал об этом
            throw Exception('Sync failed for $entityType due to push/apply/resolve errors.');
       }

     } catch (e, s) {
       stopwatch.stop();
       print('[ERROR] SyncServiceImpl: Sync failed critically for entity type: $entityType in ${stopwatch.elapsedMilliseconds}ms.\nError: $e\nStackTrace: $s');
       // Перевыбрасываем исключение, чтобы syncAll знал о критической ошибке
       // (например, ошибка при получении локальных изменений)
       throw Exception('Critical sync failure for $entityType: $e');
     }
   }


  @override
  Future<void> syncEntity(String entityId, EntityType entityType) async {
     // --- ИЗМЕНЕНО: Проверяем _isOnline напрямую ---
     if (!_isOnline) {
       print('[WARNING] SyncServiceImpl: No network connection. Skipping syncEntity for $entityType/$entityId.');
       _lastSyncErrorMessage = 'Нет сети для синхронизации $entityType/$entityId';
       await _notifyStatusUpdate();
       return;
     }

     if (!_entityHandlers.containsKey(entityType)) {
        print('[WARNING] SyncServiceImpl: No handler for $entityType. Cannot sync entity $entityId.');
        return;
     }
     final handler = _entityHandlers[entityType]!;
     final metadata = await _syncMetadataService.getMetadata(entityId, entityType);

     // Если метаданных нет или уже синхронизировано, делать нечего
     if (metadata == null || metadata.status == SyncStatus.synced) {
        print('[DEBUG] SyncServiceImpl: No pending change found for $entityType/$entityId. Skipping syncEntity.');
        return;
     }

     print('[INFO] SyncServiceImpl: Starting sync for specific entity: $entityType/$entityId (Action: ${metadata.action})');
     try {
       final localData = await handler.getLocalEntity(metadata.entityId);
       if (metadata.action != SyncAction.delete && localData == null) {
         print('[ERROR] SyncServiceImpl: Local data for entity $entityType/$entityId not found, but action is ${metadata.action}. Marking as error.');
         await handler.markAsError(metadata, 'Local data not found for non-delete action.');
         _lastSyncErrorMessage = 'Локальные данные не найдены для $entityType/$entityId';
       } else {
         await handler.pushLocalChange(metadata, localData);
         print('[INFO] SyncServiceImpl: Successfully pushed change for $entityType/$entityId.');
         // Очищаем общую ошибку, если эта конкретная синхронизация прошла успешно
         if (_lastSyncErrorMessage?.contains(entityId) ?? false) {
            _lastSyncErrorMessage = null;
         }
       }
     } catch (e, s) {
       print('[ERROR] SyncServiceImpl: Failed to push change for specific entity $entityType/$entityId.\nError: $e\nStackTrace: $s');
        _lastSyncErrorMessage = 'Ошибка отправки $entityType/$entityId: $e';
       // Ошибка уже обработана и записана в метаданные внутри pushLocalChange
     } finally {
       await _notifyStatusUpdate(); // Обновляем статус после попытки
     }
  }

  @override
  Future<SyncStatusInfo> getSyncStatus() async {
    // Эта логика остается, но использует _isOnline и isListening от менеджера
    final pending = await _syncMetadataService.getPendingChanges();
    final errors = pending.where((m) => m.status == SyncStatus.error).length;
    final pendingMap = <EntityType, int>{};
    for (var meta in pending) {
      pendingMap[meta.entityType] = (pendingMap[meta.entityType] ?? 0) + 1;
    }

    // Получаем статус слушателей от менеджера
    bool isListening = _listenerManager.isListening;

    return SyncStatusInfo(
      lastSuccessfulSync: _lastGlobalSyncAttemptCompletionTime, // Используем время завершения ПОПЫТКИ
      isSyncing: _isSyncing,
      isOnline: _isOnline, // Используем поле класса
      isListening: isListening, // Используем данные от менеджера
      autoSyncEnabled: true, // TODO: Сделать настраиваемым, если нужно
      pendingChangesCount: pendingMap,
      errorCount: errors,
      lastErrorMessage: _lastSyncErrorMessage,
    );
  }

  @override
  Stream<SyncStatusInfo> getSyncStatusStream() {
    // Запускаем начальное уведомление асинхронно
    Future.microtask(_notifyStatusUpdate);
    return _statusController.stream;
  }

  // --- ИЗМЕНЕНО: Делегирование менеджеру ---
  @override
  Future<void> startListeningToRemoteChanges() async {
    await _listenerManager.startListeners();
    await _notifyStatusUpdate(); // Обновить статус (isListening)
  }

  // --- ИЗМЕНЕНО: Делегирование менеджеру ---
  @override
  Future<void> stopListeningToRemoteChanges() async {
    await _listenerManager.stopListeners();
     await _notifyStatusUpdate(); // Обновить статус (isListening)
  }

  @override
  Future<bool> hasPendingChanges() async {
    final pending = await _syncMetadataService.getPendingChanges();
    return pending.isNotEmpty;
  }

  @override
  Future<void> cleanupSyncMetadata({Duration? olderThan}) async {
    final cleanupTime = DateTime.now().subtract(olderThan ?? const Duration(days: 7));
     try {
        await _syncMetadataService.cleanupOldRecords(cleanupTime);
        print('[INFO] SyncServiceImpl: Cleaned up old sync metadata before $cleanupTime.');
     } catch (e, s) {
        print('[ERROR] SyncServiceImpl: Failed to cleanup sync metadata.\nError: $e\nStackTrace: $s');
     }
  }

  @override
  Future<void> resetSyncState() async {
     print('[WARNING] SyncServiceImpl: Resetting sync state! All metadata will be cleared.');
      await stopListeningToRemoteChanges(); // Останавливаем слушателей
      _isSyncing = false;
      _lastGlobalSyncAttemptCompletionTime = null;
      _lastSyncErrorMessage = null;
      try {
          // Очищаем метаданные и время последней синхронизации
          await _syncMetadataService.getAllMetadata().then((allMeta) async {
              for (final meta in allMeta) {
                  await _syncMetadataService.deleteMetadata(meta.id);
              }
          });
          await _lastSyncTimeService.clearAllLastSyncTimes();
          print('[INFO] SyncServiceImpl: Sync state reset complete.');
      } catch (e, s) {
          print('[ERROR] SyncServiceImpl: Failed to fully reset sync state.\nError: $e\nStackTrace: $s');
          _lastSyncErrorMessage = 'Ошибка при сбросе состояния синхронизации: $e';
      } finally {
         await _notifyStatusUpdate();
      }
  }

  // --- ИЗМЕНЕНО: Вызываем dispose у менеджера ---
  @override
  void dispose() {
    print('[INFO] SyncServiceImpl disposing...');
    _networkStatusSubscription?.cancel(); // Отписываемся от сети
    _listenerManager.dispose(); // Освобождаем ресурсы менеджера слушателей
    _statusController.close(); // Закрываем свой StreamController
    print('[INFO] SyncServiceImpl disposed.');
  }
}