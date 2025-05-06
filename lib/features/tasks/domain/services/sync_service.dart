// lib/features/tasks/domain/services/sync_service.dart

import '../entities/sync/sync_metadata.dart';
import '../entities/sync/sync_status_info.dart';

/// Интерфейс сервиса синхронизации
abstract class ISyncService {
  /// Инициировать синхронизацию всех данных
  Future<void> syncAll();
  
  /// Синхронизировать только определенный тип сущностей
  Future<void> syncEntityType(EntityType entityType);
  
  /// Синхронизировать конкретную сущность
  Future<void> syncEntity(String entityId, EntityType entityType);
  
  /// Получить состояние синхронизации
  Future<SyncStatusInfo> getSyncStatus();
  
  /// Запустить слушатель изменений в Firestore
  Future<void> startListeningToRemoteChanges();
  
  /// Остановить слушатель изменений
  Future<void> stopListeningToRemoteChanges();
  
  /// Проверить, есть ли несинхронизированные данные
  Future<bool> hasPendingChanges();
  
  /// Очистить старые метаданные синхронизации
  Future<void> cleanupSyncMetadata({Duration? olderThan});
  
  /// Сбросить все метаданные и состояние синхронизации
  Future<void> resetSyncState();
}