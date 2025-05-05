import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/sync/sync_metadata.dart';

part 'sync_metadata_model.freezed.dart';
part 'sync_metadata_model.g.dart';

@freezed
abstract class SyncMetadataModel with _$SyncMetadataModel {
  const factory SyncMetadataModel({
    required String id,
    required String entityId,
    required EntityType entityType,
    required SyncAction action,
    required DateTime lastLocalUpdate,
    DateTime? lastSyncTime,
    required SyncStatus status,
    String? errorMessage,
    @Default(0) int retryCount,
    @Default({}) Map<String, dynamic> additionalData,
  }) = _SyncMetadataModel;

  factory SyncMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataModelFromJson(json);
      
  factory SyncMetadataModel.fromEntity(SyncMetadata entity) => SyncMetadataModel(
    id: entity.id,
    entityId: entity.entityId,
    entityType: entity.entityType,
    action: entity.action,
    lastLocalUpdate: entity.lastLocalUpdate,
    lastSyncTime: entity.lastSyncTime,
    status: entity.status,
    errorMessage: entity.errorMessage,
    retryCount: entity.retryCount,
    additionalData: entity.additionalData,
  );
}

extension SyncMetadataModelExtension on SyncMetadataModel {
  SyncMetadata toEntity() => SyncMetadata(
    id: id,
    entityId: entityId,
    entityType: entityType,
    action: action,
    lastLocalUpdate: lastLocalUpdate,
    lastSyncTime: lastSyncTime,
    status: status,
    errorMessage: errorMessage,
    retryCount: retryCount,
    additionalData: additionalData,
  );
}

extension SyncMetadataModelListExtension on List<SyncMetadataModel> {
  List<SyncMetadata> toEntities() => map((model) => model.toEntity()).toList();
}