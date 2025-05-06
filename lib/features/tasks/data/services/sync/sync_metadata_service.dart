import 'package:uuid/uuid.dart';

import '../../../domain/entities/sync/sync_metadata.dart';
import '../../datasources/local/dao/sync_metadata_dao.dart';
// Импортируем расширения для преобразования между TableData и Entity/Model
import '../../datasources/local/tables/extensions/sync_metadata_table_extension.dart';
import '../../models/sync/sync_metadata_model.dart'; // Для toEntity() / fromEntity()

/// Сервис для управления метаданными синхронизации в локальной базе данных.
/// Предоставляет API для создания, чтения, обновления и удаления записей SyncMetadata.
class SyncMetadataService {
  final SyncMetadataDao _dao;
  final Uuid _uuid;

  SyncMetadataService(this._dao) : _uuid = const Uuid();

  /// Создает или обновляет запись метаданных для сущности.
  /// Если метаданные для [entityId] и [entityType] уже существуют, они обновляются.
  /// Если нет, создается новая запись с уникальным ID.
  /// [action] указывает на тип изменения (create, update, delete).
  /// [additionalData] можно использовать для хранения специфичной информации.
  Future<SyncMetadata> createOrUpdateMetadata({
    required String entityId,
    required EntityType entityType,
    required SyncAction action,
    Map<String, dynamic> additionalData = const {},
  }) async {
    final existing = await getMetadata(entityId, entityType);
    final now = DateTime.now();

    if (existing != null) {
      // Обновляем существующую запись
      final updatedMeta = existing.copyWith(
        action: action, // Обновляем действие (например, было create, стало update)
        lastLocalUpdate: now,
        status: SyncStatus.pending, // Сбрасываем статус на pending при любом изменении
        retryCount: 0, // Сбрасываем счетчик попыток
        errorMessage: null, // Очищаем сообщение об ошибке
        additionalData: additionalData,
        // lastSyncTime остается прежним до успешной синхронизации
      );
      final companion = SyncMetadataModel.fromEntity(updatedMeta).toCompanion();
      await _dao.upsertMetadata(companion);
      return updatedMeta;
    } else {
      // Создаем новую запись
      final newMeta = SyncMetadata(
        id: _uuid.v4(), // Генерируем новый UUID
        entityId: entityId,
        entityType: entityType,
        action: action,
        lastLocalUpdate: now,
        status: SyncStatus.pending,
        additionalData: additionalData,
        // остальные поля будут по умолчанию (null или 0)
      );
      final companion = SyncMetadataModel.fromEntity(newMeta).toCompanion();
      await _dao.upsertMetadata(companion);
      return newMeta;
    }
  }

  /// Получает метаданные синхронизации для конкретной сущности.
  /// Возвращает [SyncMetadata] или null, если запись не найдена.
  Future<SyncMetadata?> getMetadata(String entityId, EntityType entityType) async {
    final data = await _dao.getMetadataByEntityId(entityId, entityType);
    return data?.toModel().toEntity();
  }

   /// Получает метаданные синхронизации по их уникальному ID.
  Future<SyncMetadata?> getMetadataById(String id) async {
     // Предполагаем, что в DAO есть метод getById(String id) или реализуем его
     // Например, так (если его нет):
     final data = await (_dao.select(_dao.syncMetadataTable)..where((t) => t.id.equals(id))).getSingleOrNull();
     return data?.toModel().toEntity();
  }


  /// Получает список всех метаданных, ожидающих синхронизации (статус pending или error).
  Future<List<SyncMetadata>> getPendingChanges() async {
    final dataList = await _dao.getPendingMetadata();
    // Преобразуем List<SyncMetadataTableData> в List<SyncMetadata>
    return dataList.toModels().toEntities();
  }

  /// Обновляет статус синхронизации для записи метаданных по ее [id].
  Future<void> updateSyncStatus(
    String id,
    SyncStatus status,
    DateTime? syncTime,
    String? errorMessage,
  ) {
    return _dao.updateSyncStatus(id, status, syncTime, errorMessage);
  }

  /// Увеличивает счетчик попыток синхронизации для записи по ее [id].
  Future<void> incrementRetryCount(String id) {
    return _dao.incrementRetryCount(id);
  }

  /// Удаляет запись метаданных по ее уникальному [id].
  Future<void> deleteMetadata(String id) {
    return _dao.deleteMetadata(id);
  }

  /// Удаляет запись метаданных по идентификатору и типу сущности.
  Future<void> deleteMetadataByEntity(String entityId, EntityType entityType) {
    return _dao.deleteMetadataByEntity(entityId, entityType);
  }

  /// Удаляет старые, успешно синхронизированные записи метаданных,
  /// которые были синхронизированы до указанной даты [before].
  Future<void> cleanupOldRecords(DateTime before) {
    return _dao.cleanupOldSyncedRecords(before);
  }

  /// Получает все записи метаданных (может быть полезно для отладки).
  Future<List<SyncMetadata>> getAllMetadata() async {
     final dataList = await _dao.getAllMetadata();
     return dataList.toModels().toEntities();
  }
}