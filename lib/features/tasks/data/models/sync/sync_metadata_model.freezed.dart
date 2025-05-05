// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_metadata_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncMetadataModel {

 String get id; String get entityId; EntityType get entityType; SyncAction get action; DateTime get lastLocalUpdate; DateTime? get lastSyncTime; SyncStatus get status; String? get errorMessage; int get retryCount; Map<String, dynamic> get additionalData;
/// Create a copy of SyncMetadataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncMetadataModelCopyWith<SyncMetadataModel> get copyWith => _$SyncMetadataModelCopyWithImpl<SyncMetadataModel>(this as SyncMetadataModel, _$identity);

  /// Serializes this SyncMetadataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncMetadataModel&&(identical(other.id, id) || other.id == id)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.action, action) || other.action == action)&&(identical(other.lastLocalUpdate, lastLocalUpdate) || other.lastLocalUpdate == lastLocalUpdate)&&(identical(other.lastSyncTime, lastSyncTime) || other.lastSyncTime == lastSyncTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&const DeepCollectionEquality().equals(other.additionalData, additionalData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entityId,entityType,action,lastLocalUpdate,lastSyncTime,status,errorMessage,retryCount,const DeepCollectionEquality().hash(additionalData));

@override
String toString() {
  return 'SyncMetadataModel(id: $id, entityId: $entityId, entityType: $entityType, action: $action, lastLocalUpdate: $lastLocalUpdate, lastSyncTime: $lastSyncTime, status: $status, errorMessage: $errorMessage, retryCount: $retryCount, additionalData: $additionalData)';
}


}

/// @nodoc
abstract mixin class $SyncMetadataModelCopyWith<$Res>  {
  factory $SyncMetadataModelCopyWith(SyncMetadataModel value, $Res Function(SyncMetadataModel) _then) = _$SyncMetadataModelCopyWithImpl;
@useResult
$Res call({
 String id, String entityId, EntityType entityType, SyncAction action, DateTime lastLocalUpdate, DateTime? lastSyncTime, SyncStatus status, String? errorMessage, int retryCount, Map<String, dynamic> additionalData
});




}
/// @nodoc
class _$SyncMetadataModelCopyWithImpl<$Res>
    implements $SyncMetadataModelCopyWith<$Res> {
  _$SyncMetadataModelCopyWithImpl(this._self, this._then);

  final SyncMetadataModel _self;
  final $Res Function(SyncMetadataModel) _then;

/// Create a copy of SyncMetadataModel
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

class _SyncMetadataModel implements SyncMetadataModel {
  const _SyncMetadataModel({required this.id, required this.entityId, required this.entityType, required this.action, required this.lastLocalUpdate, this.lastSyncTime, required this.status, this.errorMessage, this.retryCount = 0, final  Map<String, dynamic> additionalData = const {}}): _additionalData = additionalData;
  factory _SyncMetadataModel.fromJson(Map<String, dynamic> json) => _$SyncMetadataModelFromJson(json);

@override final  String id;
@override final  String entityId;
@override final  EntityType entityType;
@override final  SyncAction action;
@override final  DateTime lastLocalUpdate;
@override final  DateTime? lastSyncTime;
@override final  SyncStatus status;
@override final  String? errorMessage;
@override@JsonKey() final  int retryCount;
 final  Map<String, dynamic> _additionalData;
@override@JsonKey() Map<String, dynamic> get additionalData {
  if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_additionalData);
}


/// Create a copy of SyncMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncMetadataModelCopyWith<_SyncMetadataModel> get copyWith => __$SyncMetadataModelCopyWithImpl<_SyncMetadataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncMetadataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncMetadataModel&&(identical(other.id, id) || other.id == id)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.action, action) || other.action == action)&&(identical(other.lastLocalUpdate, lastLocalUpdate) || other.lastLocalUpdate == lastLocalUpdate)&&(identical(other.lastSyncTime, lastSyncTime) || other.lastSyncTime == lastSyncTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&const DeepCollectionEquality().equals(other._additionalData, _additionalData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entityId,entityType,action,lastLocalUpdate,lastSyncTime,status,errorMessage,retryCount,const DeepCollectionEquality().hash(_additionalData));

@override
String toString() {
  return 'SyncMetadataModel(id: $id, entityId: $entityId, entityType: $entityType, action: $action, lastLocalUpdate: $lastLocalUpdate, lastSyncTime: $lastSyncTime, status: $status, errorMessage: $errorMessage, retryCount: $retryCount, additionalData: $additionalData)';
}


}

/// @nodoc
abstract mixin class _$SyncMetadataModelCopyWith<$Res> implements $SyncMetadataModelCopyWith<$Res> {
  factory _$SyncMetadataModelCopyWith(_SyncMetadataModel value, $Res Function(_SyncMetadataModel) _then) = __$SyncMetadataModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String entityId, EntityType entityType, SyncAction action, DateTime lastLocalUpdate, DateTime? lastSyncTime, SyncStatus status, String? errorMessage, int retryCount, Map<String, dynamic> additionalData
});




}
/// @nodoc
class __$SyncMetadataModelCopyWithImpl<$Res>
    implements _$SyncMetadataModelCopyWith<$Res> {
  __$SyncMetadataModelCopyWithImpl(this._self, this._then);

  final _SyncMetadataModel _self;
  final $Res Function(_SyncMetadataModel) _then;

/// Create a copy of SyncMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? entityId = null,Object? entityType = null,Object? action = null,Object? lastLocalUpdate = null,Object? lastSyncTime = freezed,Object? status = null,Object? errorMessage = freezed,Object? retryCount = null,Object? additionalData = null,}) {
  return _then(_SyncMetadataModel(
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
