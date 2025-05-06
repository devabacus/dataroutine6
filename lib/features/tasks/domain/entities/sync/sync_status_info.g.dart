// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_status_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncStatusInfo _$SyncStatusInfoFromJson(
  Map<String, dynamic> json,
) => _SyncStatusInfo(
  lastSuccessfulSync:
      json['lastSuccessfulSync'] == null
          ? null
          : DateTime.parse(json['lastSuccessfulSync'] as String),
  isSyncing: json['isSyncing'] as bool? ?? false,
  isOnline: json['isOnline'] as bool? ?? false,
  autoSyncEnabled: json['autoSyncEnabled'] as bool? ?? true,
  pendingChangesCount:
      (json['pendingChangesCount'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$EntityTypeEnumMap, k), (e as num).toInt()),
      ) ??
      const {},
  errorCount: (json['errorCount'] as num?)?.toInt() ?? 0,
  lastErrorMessage: json['lastErrorMessage'] as String?,
  additionalInfo: json['additionalInfo'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$SyncStatusInfoToJson(_SyncStatusInfo instance) =>
    <String, dynamic>{
      'lastSuccessfulSync': instance.lastSuccessfulSync?.toIso8601String(),
      'isSyncing': instance.isSyncing,
      'isOnline': instance.isOnline,
      'autoSyncEnabled': instance.autoSyncEnabled,
      'pendingChangesCount': instance.pendingChangesCount.map(
        (k, e) => MapEntry(_$EntityTypeEnumMap[k]!, e),
      ),
      'errorCount': instance.errorCount,
      'lastErrorMessage': instance.lastErrorMessage,
      'additionalInfo': instance.additionalInfo,
    };

const _$EntityTypeEnumMap = {
  EntityType.category: 'category',
  EntityType.task: 'task',
  EntityType.tag: 'tag',
  EntityType.taskTag: 'taskTag',
};
