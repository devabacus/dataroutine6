// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncMetadata {

 String get id;// UUID для метаданных
 String get entityId;// ID сущности
 EntityType get entityType;// Тип сущности
 SyncAction get action;// Действие
 DateTime get lastLocalUpdate;// Время последнего локального изменения
 DateTime? get lastSyncTime;// Время последней синхронизации
 SyncStatus get status;// Статус синхронизации
 String? get errorMessage;// Сообщение об ошибке (если есть)
 int get retryCount;// Количество попыток синхронизации
 Map<String, dynamic> get additionalData;
/// Create a copy of SyncMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncMetadataCopyWith<SyncMetadata> get copyWith => _$SyncMetadataCopyWithImpl<SyncMetadata>(this as SyncMetadata, _$identity);

  /// Serializes this SyncMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncMetadata&&(identical(other.id, id) || other.id == id)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.action, action) || other.action == action)&&(identical(other.lastLocalUpdate, lastLocalUpdate) || other.lastLocalUpdate == lastLocalUpdate)&&(identical(other.lastSyncTime, lastSyncTime) || other.lastSyncTime == lastSyncTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&const DeepCollectionEquality().equals(other.additionalData, additionalData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entityId,entityType,action,lastLocalUpdate,lastSyncTime,status,errorMessage,retryCount,const DeepCollectionEquality().hash(additionalData));

@override
String toString() {
  return 'SyncMetadata(id: $id, entityId: $entityId, entityType: $entityType, action: $action, lastLocalUpdate: $lastLocalUpdate, lastSyncTime: $lastSyncTime, status: $status, errorMessage: $errorMessage, retryCount: $retryCount, additionalData: $additionalData)';
}


}

/// @nodoc
abstract mixin class $SyncMetadataCopyWith<$Res>  {
  factory $SyncMetadataCopyWith(SyncMetadata value, $Res Function(SyncMetadata) _then) = _$SyncMetadataCopyWithImpl;
@useResult
$Res call({
 String id, String entityId, EntityType entityType, SyncAction action, DateTime lastLocalUpdate, DateTime? lastSyncTime, SyncStatus status, String? errorMessage, int retryCount, Map<String, dynamic> additionalData
});




}
/// @nodoc
class _$SyncMetadataCopyWithImpl<$Res>
    implements $SyncMetadataCopyWith<$Res> {
  _$SyncMetadataCopyWithImpl(this._self, this._then);

  final SyncMetadata _self;
  final $Res Function(SyncMetadata) _then;

/// Create a copy of SyncMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? entityId = null,Object? entityType = null,Object? action = null,Object? lastLocalUpdate = null,Object? lastSyncTime = freezed,Object? status = null,Object? errorMessage = freezed,Object? retryCount = null,Object? additionalData = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as EntityType,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as SyncAction,lastLocalUpdate: null == lastLocalUpdate ? _self.lastLocalUpdate : lastLocalUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,lastSyncTime: freezed == lastSyncTime ? _self.lastSyncTime : lastSyncTime // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,additionalData: null == additionalData ? _self.additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SyncMetadata implements SyncMetadata {
  const _SyncMetadata({required this.id, required this.entityId, required this.entityType, required this.action, required this.lastLocalUpdate, this.lastSyncTime, required this.status, this.errorMessage, this.retryCount = 0, final  Map<String, dynamic> additionalData = const {}}): _additionalData = additionalData;
  factory _SyncMetadata.fromJson(Map<String, dynamic> json) => _$SyncMetadataFromJson(json);

@override final  String id;
// UUID для метаданных
@override final  String entityId;
// ID сущности
@override final  EntityType entityType;
// Тип сущности
@override final  SyncAction action;
// Действие
@override final  DateTime lastLocalUpdate;
// Время последнего локального изменения
@override final  DateTime? lastSyncTime;
// Время последней синхронизации
@override final  SyncStatus status;
// Статус синхронизации
@override final  String? errorMessage;
// Сообщение об ошибке (если есть)
@override@JsonKey() final  int retryCount;
// Количество попыток синхронизации
 final  Map<String, dynamic> _additionalData;
// Количество попыток синхронизации
@override@JsonKey() Map<String, dynamic> get additionalData {
  if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_additionalData);
}


/// Create a copy of SyncMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncMetadataCopyWith<_SyncMetadata> get copyWith => __$SyncMetadataCopyWithImpl<_SyncMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncMetadata&&(identical(other.id, id) || other.id == id)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.action, action) || other.action == action)&&(identical(other.lastLocalUpdate, lastLocalUpdate) || other.lastLocalUpdate == lastLocalUpdate)&&(identical(other.lastSyncTime, lastSyncTime) || other.lastSyncTime == lastSyncTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&const DeepCollectionEquality().equals(other._additionalData, _additionalData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entityId,entityType,action,lastLocalUpdate,lastSyncTime,status,errorMessage,retryCount,const DeepCollectionEquality().hash(_additionalData));

@override
String toString() {
  return 'SyncMetadata(id: $id, entityId: $entityId, entityType: $entityType, action: $action, lastLocalUpdate: $lastLocalUpdate, lastSyncTime: $lastSyncTime, status: $status, errorMessage: $errorMessage, retryCount: $retryCount, additionalData: $additionalData)';
}


}

/// @nodoc
abstract mixin class _$SyncMetadataCopyWith<$Res> implements $SyncMetadataCopyWith<$Res> {
  factory _$SyncMetadataCopyWith(_SyncMetadata value, $Res Function(_SyncMetadata) _then) = __$SyncMetadataCopyWithImpl;
@override @useResult
$Res call({
 String id, String entityId, EntityType entityType, SyncAction action, DateTime lastLocalUpdate, DateTime? lastSyncTime, SyncStatus status, String? errorMessage, int retryCount, Map<String, dynamic> additionalData
});




}
/// @nodoc
class __$SyncMetadataCopyWithImpl<$Res>
    implements _$SyncMetadataCopyWith<$Res> {
  __$SyncMetadataCopyWithImpl(this._self, this._then);

  final _SyncMetadata _self;
  final $Res Function(_SyncMetadata) _then;

/// Create a copy of SyncMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? entityId = null,Object? entityType = null,Object? action = null,Object? lastLocalUpdate = null,Object? lastSyncTime = freezed,Object? status = null,Object? errorMessage = freezed,Object? retryCount = null,Object? additionalData = null,}) {
  return _then(_SyncMetadata(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as EntityType,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as SyncAction,lastLocalUpdate: null == lastLocalUpdate ? _self.lastLocalUpdate : lastLocalUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,lastSyncTime: freezed == lastSyncTime ? _self.lastSyncTime : lastSyncTime // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,additionalData: null == additionalData ? _self._additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
