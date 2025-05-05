import 'package:drift/drift.dart';
import '../../../../../../core/database/local/database.dart';
import '../../../../../../core/database/local/interface/database_service.dart';
import '../../../../domain/entities/sync/sync_metadata.dart';
import '../tables/sync_metadata_table.dart';

part 'sync_metadata_dao.g.dart';

@DriftAccessor(tables: [SyncMetadataTable])
class SyncMetadataDao extends DatabaseAccessor<AppDatabase> with _$SyncMetadataDaoMixin {
  SyncMetadataDao(IDatabaseService databaseService) : super(databaseService.database);

  // Получение всех метаданных
  Future<List<SyncMetadataTableData>> getAllMetadata() => select(syncMetadataTable).get();

  // Получение метаданных по ID сущности и типу
  Future<SyncMetadataTableData?> getMetadataByEntityId(String entityId, EntityType entityType) {
    return (select(syncMetadataTable)
          // ИЗМЕНЕНО: используем entityType.name
          ..where((t) => t.entityId.equals(entityId) &
                       t.entityType.equals(entityType.name))) // <-- .name
      .getSingleOrNull();
  }

// Получение всех несинхронизированных записей
Future<List<SyncMetadataTableData>> getPendingMetadata() {
  return (select(syncMetadataTable)
        ..where((t) => t.status.equals(SyncStatus.pending.name) | 
                     t.status.equals(SyncStatus.error.name))
        ..orderBy([(t) => OrderingTerm.asc(t.lastLocalUpdate)]))
    .get();
}

  // Получение метаданных по статусу
  Future<List<SyncMetadataTableData>> getMetadataByStatus(SyncStatus status) {
    return (select(syncMetadataTable)
          // ИЗМЕНЕНО: используем status.name
          ..where((t) => t.status.equals(status.name))) // <-- .name
      .get();
  }

  // Создание или обновление метаданных
  Future<void> upsertMetadata(SyncMetadataTableCompanion metadata) {
    // Здесь преобразование не нужно, т.к. TypeConverter работает при записи Companion
    return into(syncMetadataTable).insertOnConflictUpdate(metadata);
  }

  // Обновление статуса синхронизации
  Future<void> updateSyncStatus(
    String id,
    SyncStatus status, // <-- Тип параметра остается Enum
    DateTime? syncTime,
    String? errorMessage,
  ) {
    return (update(syncMetadataTable)..where((t) => t.id.equals(id)))
      .write(SyncMetadataTableCompanion(
        // TypeConverter автоматически обработает status при записи
        status: Value(status),
        lastSyncTime: Value(syncTime),
        errorMessage: Value(errorMessage),
      ));
  }

  // Увеличение счетчика попыток (оптимизированный вариант)
  Future<void> incrementRetryCount(String id) {
    return customUpdate(
      'UPDATE sync_metadata_table SET retry_count = retry_count + 1 WHERE id = ?',
      variables: [Variable.withString(id)],
      updates: {syncMetadataTable},
    );
  }

  // Удаление метаданных
  Future<void> deleteMetadata(String id) {
    return (delete(syncMetadataTable)..where((t) => t.id.equals(id))).go();
  }

  // Удаление метаданных по сущности
  Future<void> deleteMetadataByEntity(String entityId, EntityType entityType) {
    return (delete(syncMetadataTable)
          // ИЗМЕНЕНО: используем entityType.name
          ..where((t) => t.entityId.equals(entityId) &
                       t.entityType.equals(entityType.name))) // <-- .name
      .go();
  }

  // Очистка старых синхронизированных записей
  Future<void> cleanupOldSyncedRecords(DateTime before) {
    return (delete(syncMetadataTable)
          ..where((t) =>
              // ИЗМЕНЕНО: используем SyncStatus.synced.name
              t.status.equals(SyncStatus.synced.name) & // <-- .name
              t.lastSyncTime.isSmallerThanValue(before)))
      .go();
  }

  // Получение всех метаданных для определенного типа сущности
  Future<List<SyncMetadataTableData>> getMetadataByEntityType(EntityType entityType) {
    return (select(syncMetadataTable)
          // ИЗМЕНЕНО: используем entityType.name
          ..where((t) => t.entityType.equals(entityType.name))) // <-- .name
      .get();
  }
}