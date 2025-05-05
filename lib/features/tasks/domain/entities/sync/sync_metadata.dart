import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_metadata.freezed.dart';
part 'sync_metadata.g.dart';

enum SyncStatus {
  pending,    // Ожидает синхронизации
  synced,     // Синхронизировано успешно
  conflict,   // Конфликт при синхронизации
  error       // Ошибка синхронизации
}

enum SyncAction {
  create,
  update,
  delete
}

enum EntityType {
  category,
  task,
  tag,
  taskTag
}

@freezed
abstract class SyncMetadata with _$SyncMetadata {
  const factory SyncMetadata({
    required String id,                      // UUID для метаданных
    required String entityId,                // ID сущности
    required EntityType entityType,          // Тип сущности
    required SyncAction action,              // Действие
    required DateTime lastLocalUpdate,       // Время последнего локального изменения
    DateTime? lastSyncTime,                  // Время последней синхронизации
    required SyncStatus status,              // Статус синхронизации
    String? errorMessage,                    // Сообщение об ошибке (если есть)
    @Default(0) int retryCount,                          // Количество попыток синхронизации
    @Default({}) Map<String, dynamic> additionalData, // Дополнительные данные
  }) = _SyncMetadata;

  factory SyncMetadata.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataFromJson(json);
}