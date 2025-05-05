// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncMetadataModel _$SyncMetadataModelFromJson(Map<String, dynamic> json) =>
    _SyncMetadataModel(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      entityType: $enumDecode(_$EntityTypeEnumMap, json['entityType']),
      action: $enumDecode(_$SyncActionEnumMap, json['action']),
      lastLocalUpdate: DateTime.parse(json['lastLocalUpdate'] as String),
      lastSyncTime:
          json['lastSyncTime'] == null
              ? null
              : DateTime.parse(json['lastSyncTime'] as String),
      status: $enumDecode(_$SyncStatusEnumMap, json['status']),
      errorMessage: json['errorMessage'] as String?,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      additionalData:
          json['additionalData'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$SyncMetadataModelToJson(_SyncMetadataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'entityType': _$EntityTypeEnumMap[instance.entityType]!,
      'action': _$SyncActionEnumMap[instance.action]!,
      'lastLocalUpdate': instance.lastLocalUpdate.toIso8601String(),
      'lastSyncTime': instance.lastSyncTime?.toIso8601String(),
      'status': _$SyncStatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
      'retryCount': instance.retryCount,
      'additionalData': instance.additionalData,
    };

const _$EntityTypeEnumMap = {
  EntityType.category: 'category',
  EntityType.task: 'task',
  EntityType.tag: 'tag',
  EntityType.taskTag: 'taskTag',
};

const _$SyncActionEnumMap = {
  SyncAction.create: 'create',
  SyncAction.update: 'update',
  SyncAction.delete: 'delete',
};

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'pending',
  SyncStatus.synced: 'synced',
  SyncStatus.conflict: 'conflict',
  SyncStatus.error: 'error',
};
