import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart'; // Для DataClass
import '../../../../../../core/database/local/database.dart';
import '../../../../domain/entities/sync/sync_metadata.dart';
import '../sync_metadata_service.dart';

/// Абстрактный базовый класс для обработчиков синхронизации конкретных типов сущностей.
///
/// Каждый подкласс отвечает за логику получения/отправки изменений и разрешения
/// конфликтов для своего типа данных (например, Категории, Задачи, Теги).
///
/// Типы-параметры:
///   [L] - Тип локальной сущности Drift (должен наследоваться от DataClass)
///   [R] - Тип удаленной сущности (обычно Map<String, dynamic> для Firestore)
abstract class BaseEntitySyncHandler<L extends DataClass, R> {
  final FirebaseFirestore firestore;
  final AppDatabase localDatabase;
  final SyncMetadataService syncMetadataService;

  BaseEntitySyncHandler({
    required this.firestore,
    required this.localDatabase,
    required this.syncMetadataService,
  });

  /// Тип сущности, за которую отвечает этот обработчик.
  /// Должен быть реализован в подклассах.
  EntityType get entityType;

  /// Получает ссылку на коллекцию Firestore для данного типа сущности.
  /// Должен быть реализован в подклассах.
  CollectionReference<R> get collectionReference;

  /// Получает последние изменения из удаленного хранилища (Firestore)
  /// для данного типа сущности, произошедшие после [lastSyncTime].
  /// Возвращает список метаданных для обработки.
  Future<List<SyncMetadata>> fetchRemoteChanges(DateTime? lastSyncTime);

  /// Применяет одно удаленное изменение [remoteData] к локальной базе данных.
  /// [metadata] содержит информацию об изменении (ID, действие и т.д.).
  Future<void> applyRemoteChange(SyncMetadata metadata, R remoteData);

  /// Получает список локальных изменений [SyncMetadata], ожидающих отправки
  /// в удаленное хранилище для данного типа сущности.
  Future<List<SyncMetadata>> getPendingLocalChanges();

  /// Отправляет одно локальное изменение в удаленное хранилище.
  /// [metadata] содержит информацию об изменении. Требуется получить
  /// локальные данные [localData] перед отправкой.
  Future<void> pushLocalChange(SyncMetadata metadata, L? localData);

  /// Получает локальную сущность по ее [id].
  /// Используется для получения данных при отправке или разрешении конфликтов.
  Future<L?> getLocalEntity(String id);

  /// Преобразует удаленные данные [remoteData] (например, из Firestore)
  /// в локальную сущность [L] для сохранения в базе данных.
  /// Должен быть реализован в подклассах.
  Future<L> mapRemoteToLocal(String docId, R remoteData);

  /// Преобразует локальную сущность [localData] в формат [R]
  /// для отправки в удаленное хранилище.
  /// Должен быть реализован в подклассах.
  R mapLocalToRemote(L localData);

  /// Обрабатывает конфликт синхронизации для сущности.
  /// [localMetadata] - локальные метаданные.
  /// [localData] - локальные данные (могут быть null, если локально удалено).
  /// [remoteData] - удаленные данные (могут быть null, если удаленно удалено).
  ///
  /// Реализация этого метода определяет стратегию разрешения конфликтов
  /// (например, "последняя запись побеждает", "локальная копия побеждает" и т.д.).
  Future<void> resolveConflict(
    SyncMetadata localMetadata,
    L? localData,
    R? remoteData,
  );

  // --- Вспомогательные методы ---

  /// Обновляет метаданные синхронизации [metadata], помечая их как успешно
  /// синхронизированные в [syncTime].
  Future<void> markAsSynced(SyncMetadata metadata, DateTime syncTime) async {
    await syncMetadataService.updateSyncStatus(
      metadata.id,
      SyncStatus.synced,
      syncTime,
      null, // Очищаем сообщение об ошибке
    );
  }

  /// Обновляет метаданные синхронизации [metadata], помечая их как ошибочные
  /// с сообщением [errorMessage] и увеличивает счетчик попыток.
  Future<void> markAsError(SyncMetadata metadata, String errorMessage) async {
    await syncMetadataService.incrementRetryCount(metadata.id);
    await syncMetadataService.updateSyncStatus(
      metadata.id,
      SyncStatus.error,
      metadata.lastSyncTime, // Время ошибки - время последней попытки
      errorMessage,
    );
    // Можно добавить логирование ошибки
    print(
        "Sync Error for ${entityType.name} (${metadata.entityId}): $errorMessage");
  }
}