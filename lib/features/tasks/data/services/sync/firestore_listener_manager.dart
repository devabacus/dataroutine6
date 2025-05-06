import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/services/network_status_service.dart';
import '../../../domain/entities/sync/sync_metadata.dart';
import 'entity_handlers/base_entity_handler.dart';
import 'sync_metadata_service.dart';

/// Управляет активными слушателями Firestore для обновлений в реальном времени.
class FirestoreListenerManager {
  final FirebaseFirestore firestore;
  final Map<EntityType, BaseEntitySyncHandler> entityHandlers;
  final SyncMetadataService syncMetadataService;
  final NetworkStatusService networkStatusService;
  final Function()? onRemoteChangeApplied; // Опциональный колбэк для уведомления SyncService

  // Карта для хранения активных подписок на слушателей Firestore
  final Map<EntityType, StreamSubscription> _listeners = {};
  // Подписка на статус сети
  StreamSubscription<bool>? _networkSubscription;
  // Внутренний статус сети
  bool _isOnline = true;

  FirestoreListenerManager({
    required this.firestore,
    required this.entityHandlers,
    required this.syncMetadataService,
    required this.networkStatusService,
    this.onRemoteChangeApplied, // Передаем колбэк
  }) {
    // Начинаем слушать сеть при инициализации
    _listenToNetwork();
  }

  /// Проверяет, активны ли слушатели Firestore.
  bool get isListening => _listeners.isNotEmpty;

  /// Инициализирует слушателя состояния сети.
  void _listenToNetwork() {
    // Отменяем предыдущую подписку, если она есть
    _networkSubscription?.cancel();

    // Получаем начальный статус сети
    networkStatusService.isOnline().then((status) {
      _isOnline = status;
      print("[INFO] FirestoreListenerManager: Initial network status: ${_isOnline ? 'Online' : 'Offline'}");
      if (_isOnline) {
        startListeners(); // Запускаем слушателей, если изначально онлайн
      }
    }).catchError((e) {
      print("[ERROR] FirestoreListenerManager: Failed to get initial network status: $e");
      _isOnline = false; // Считаем оффлайн при ошибке
    });

    // Подписываемся на изменения статуса сети
    _networkSubscription = networkStatusService.onlineStatusStream.listen(
      (isOnlineUpdate) {
        if (_isOnline != isOnlineUpdate) {
          print("[INFO] FirestoreListenerManager: Network status changed: ${isOnlineUpdate ? 'Online' : 'Offline'}");
          _isOnline = isOnlineUpdate;
          if (_isOnline) {
            startListeners(); // Запускаем слушателей при появлении сети
          } else {
            stopListeners(); // Останавливаем слушателей при потере сети
          }
          onRemoteChangeApplied?.call(); // Уведомляем об изменении статуса сети
        }
      },
      onError: (error) {
        print("[ERROR] FirestoreListenerManager: Error in network status stream: $error");
        if (_isOnline) {
          _isOnline = false;
          stopListeners(); // Останавливаем слушателей при ошибке сети
           onRemoteChangeApplied?.call(); // Уведомляем
        }
      },
    );
     print("[INFO] FirestoreListenerManager: Network listener initialized.");
  }

  /// Запускает слушателей Firestore для всех зарегистрированных обработчиков.
  Future<void> startListeners() async {
    if (!_isOnline) {
      print('[WARNING] FirestoreListenerManager: Cannot start listeners while offline.');
      return;
    }
    if (_listeners.isNotEmpty) {
      print('[INFO] FirestoreListenerManager: Listeners seem to be already active. Restarting...');
      await stopListeners(); // Перезапускаем для чистоты
    }

    print('[INFO] FirestoreListenerManager: Starting listeners for ${entityHandlers.length} handlers...');
    for (final entry in entityHandlers.entries) {
      final entityType = entry.key;
      final handler = entry.value;
      final collectionRef = handler.collectionReference;

      print('[DEBUG] FirestoreListenerManager: Setting up listener for $entityType');

      // Отменяем предыдущую подписку для этого типа, если вдруг осталась
      await _listeners[entityType]?.cancel();

      _listeners[entityType] = collectionRef
          .snapshots(includeMetadataChanges: true)
          .listen(
            (snapshot) => _processSnapshot(entityType, handler, snapshot), // Передаем handler
            onError: (error, stackTrace) {
              print('[ERROR] FirestoreListenerManager ($entityType): Listener error: $error\nStackTrace: $stackTrace');
              // TODO: Рассмотреть более надежную обработку ошибок (например, retry)
              stopListeners(); // Останавливаем все при ошибке одного
              onRemoteChangeApplied?.call(); // Уведомляем
            },
            onDone: () {
              print('[INFO] FirestoreListenerManager ($entityType): Listener stream closed.');
              _listeners.remove(entityType); // Очистка при закрытии
              onRemoteChangeApplied?.call(); // Уведомляем
            },
            cancelOnError: false, // Продолжать слушать после ошибок?
          );
      print('[INFO] FirestoreListenerManager: Listener started for $entityType.');
    }
     print('[INFO] FirestoreListenerManager: All listeners started.');
     onRemoteChangeApplied?.call(); // Уведомляем, что слушатели запущены
  }

  /// Останавливает всех активных слушателей Firestore.
  Future<void> stopListeners() async {
    if (_listeners.isEmpty) {
      return;
    }
    print('[INFO] FirestoreListenerManager: Stopping ${_listeners.length} listeners...');
    // Создаем копию ключей перед итерацией, т.к. map может изменяться
    final typesToCancel = _listeners.keys.toList();
    for (final entityType in typesToCancel) {
        final subscription = _listeners.remove(entityType);
        try {
            await subscription?.cancel();
            print('[DEBUG] FirestoreListenerManager: Cancelled listener for $entityType.');
        } catch (e) {
             print('[ERROR] FirestoreListenerManager: Error cancelling listener for $entityType: $e');
        }
    }
    _listeners.clear(); // Убеждаемся, что map пуст
    print('[INFO] FirestoreListenerManager: All listeners stopped.');
    onRemoteChangeApplied?.call(); // Уведомляем
  }

  /// Обрабатывает входящий снимок (snapshot) от Firestore.
  Future<void> _processSnapshot(
      EntityType entityType,
      BaseEntitySyncHandler handler, // Получаем handler
      QuerySnapshot snapshot) async {
    print('[DEBUG] Listener ($entityType): Received snapshot with ${snapshot.docChanges.length} changes.');
    for (final change in snapshot.docChanges) {
      await _handleDocumentChange(entityType, handler, change); // Передаем handler
    }
  }

  /// Обрабатывает отдельное изменение документа из Firestore.
  Future<void> _handleDocumentChange(
    EntityType entityType,
    BaseEntitySyncHandler handler, // Получаем handler
    DocumentChange change,
  ) async {
    final doc = change.doc;

    // Пропускаем локальные изменения (эхо)
    if (doc.metadata.hasPendingWrites) {
      print('[DEBUG] Listener ($entityType): Skipping local echo for doc ID ${doc.id}');
      return;
    }

    print('[DEBUG] Listener ($entityType): Processing remote change for doc ID ${doc.id}, Type: ${change.type}');
    final remoteData = doc.data() as Map<String, dynamic>?; // Предполагаем Map

    final SyncAction action;
    switch (change.type) {
      case DocumentChangeType.added:
      case DocumentChangeType.modified:
        action = SyncAction.update; // Обрабатываем как upsert
        break;
      case DocumentChangeType.removed:
        action = SyncAction.delete;
        break;
    }

    // Временные метаданные для вызова applyRemoteChange
    final applyMeta = SyncMetadata(
        id: '${entityType.name}_${doc.id}_realtime', // Уникальный временный ID
        entityId: doc.id,
        entityType: entityType,
        action: action,
        lastLocalUpdate: DateTime.now(), // Текущее время как время "обнаружения"
        status: SyncStatus.pending,
    );

    try {
      // Проверка конфликта с ЛОКАЛЬНО НЕсинхронизированными изменениями
      final localMeta = await syncMetadataService.getMetadata(doc.id, entityType);
      if (localMeta != null && localMeta.status != SyncStatus.synced) {
        print('[WARNING] Listener ($entityType): Conflict detected for entity ${doc.id}. Local status: ${localMeta.status}. Deferring resolution to syncAll.');
        // Откладываем разрешение конфликта до syncAll
      } else {
        // Нет конфликта или локальная запись синхронизирована: применяем удаленное изменение
        print('[DEBUG] Listener ($entityType): Applying remote change for entity ${doc.id}.');
        if (action == SyncAction.delete) {
            await handler.applyRemoteChange(applyMeta, <String, dynamic>{});
        } else if (remoteData != null) {
            await handler.applyRemoteChange(applyMeta, remoteData);
        } else {
            print('[WARNING] Listener ($entityType): Remote data is null for add/modify change: ${doc.id}');
        }
        // Уведомляем SyncService, что произошло изменение, чтобы он обновил свой статус
        onRemoteChangeApplied?.call();
      }
    } catch (e, s) {
      print('[ERROR] Listener ($entityType): Failed to apply real-time change for ${doc.id}. Error: $e\nStackTrace: $s');
      // Обработка ошибок слушателя
    }
  }

  /// Освобождает ресурсы (отписывается от сети и слушателей Firestore).
  void dispose() {
    print('[INFO] FirestoreListenerManager disposing...');
    _networkSubscription?.cancel();
    stopListeners(); // Важно остановить слушателей
    print('[INFO] FirestoreListenerManager disposed.');
  }
}