// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_status_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncStatusInfo {

/// Время последней *успешной* синхронизации всех данных.
/// Может быть null, если синхронизация еще не проводилась успешно.
 DateTime? get lastSuccessfulSync;/// Указывает, выполняется ли операция синхронизации в данный момент.
 bool get isSyncing;/// Указывает, доступно ли сетевое подключение в данный момент.
 bool get isOnline; bool get isListening;/// Указывает, включена ли автоматическая фоновая синхронизация.
 bool get autoSyncEnabled;/// Карта, показывающая количество ожидающих (несинхронизированных)
/// изменений для каждого типа сущности ([EntityType]).
 Map<EntityType, int> get pendingChangesCount;/// Общее количество элементов, синхронизация которых завершилась с ошибкой
/// и требует внимания или повторной попытки.
 int get errorCount;/// Текстовое сообщение последней возникшей ошибки синхронизации.
/// Null, если ошибок не было или последняя операция была успешной.
 String? get lastErrorMessage;/// Карта для хранения любой дополнительной, специфичной для приложения,
/// информации о состоянии синхронизации.
 Map<String, dynamic> get additionalInfo;
/// Create a copy of SyncStatusInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStatusInfoCopyWith<SyncStatusInfo> get copyWith => _$SyncStatusInfoCopyWithImpl<SyncStatusInfo>(this as SyncStatusInfo, _$identity);

  /// Serializes this SyncStatusInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStatusInfo&&(identical(other.lastSuccessfulSync, lastSuccessfulSync) || other.lastSuccessfulSync == lastSuccessfulSync)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.isListening, isListening) || other.isListening == isListening)&&(identical(other.autoSyncEnabled, autoSyncEnabled) || other.autoSyncEnabled == autoSyncEnabled)&&const DeepCollectionEquality().equals(other.pendingChangesCount, pendingChangesCount)&&(identical(other.errorCount, errorCount) || other.errorCount == errorCount)&&(identical(other.lastErrorMessage, lastErrorMessage) || other.lastErrorMessage == lastErrorMessage)&&const DeepCollectionEquality().equals(other.additionalInfo, additionalInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastSuccessfulSync,isSyncing,isOnline,isListening,autoSyncEnabled,const DeepCollectionEquality().hash(pendingChangesCount),errorCount,lastErrorMessage,const DeepCollectionEquality().hash(additionalInfo));

@override
String toString() {
  return 'SyncStatusInfo(lastSuccessfulSync: $lastSuccessfulSync, isSyncing: $isSyncing, isOnline: $isOnline, isListening: $isListening, autoSyncEnabled: $autoSyncEnabled, pendingChangesCount: $pendingChangesCount, errorCount: $errorCount, lastErrorMessage: $lastErrorMessage, additionalInfo: $additionalInfo)';
}


}

/// @nodoc
abstract mixin class $SyncStatusInfoCopyWith<$Res>  {
  factory $SyncStatusInfoCopyWith(SyncStatusInfo value, $Res Function(SyncStatusInfo) _then) = _$SyncStatusInfoCopyWithImpl;
@useResult
$Res call({
 DateTime? lastSuccessfulSync, bool isSyncing, bool isOnline, bool isListening, bool autoSyncEnabled, Map<EntityType, int> pendingChangesCount, int errorCount, String? lastErrorMessage, Map<String, dynamic> additionalInfo
});




}
/// @nodoc
class _$SyncStatusInfoCopyWithImpl<$Res>
    implements $SyncStatusInfoCopyWith<$Res> {
  _$SyncStatusInfoCopyWithImpl(this._self, this._then);

  final SyncStatusInfo _self;
  final $Res Function(SyncStatusInfo) _then;

/// Create a copy of SyncStatusInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastSuccessfulSync = freezed,Object? isSyncing = null,Object? isOnline = null,Object? isListening = null,Object? autoSyncEnabled = null,Object? pendingChangesCount = null,Object? errorCount = null,Object? lastErrorMessage = freezed,Object? additionalInfo = null,}) {
  return _then(_self.copyWith(
lastSuccessfulSync: freezed == lastSuccessfulSync ? _self.lastSuccessfulSync : lastSuccessfulSync // ignore: cast_nullable_to_non_nullable
as DateTime?,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,isListening: null == isListening ? _self.isListening : isListening // ignore: cast_nullable_to_non_nullable
as bool,autoSyncEnabled: null == autoSyncEnabled ? _self.autoSyncEnabled : autoSyncEnabled // ignore: cast_nullable_to_non_nullable
as bool,pendingChangesCount: null == pendingChangesCount ? _self.pendingChangesCount : pendingChangesCount // ignore: cast_nullable_to_non_nullable
as Map<EntityType, int>,errorCount: null == errorCount ? _self.errorCount : errorCount // ignore: cast_nullable_to_non_nullable
as int,lastErrorMessage: freezed == lastErrorMessage ? _self.lastErrorMessage : lastErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,additionalInfo: null == additionalInfo ? _self.additionalInfo : additionalInfo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SyncStatusInfo implements SyncStatusInfo {
  const _SyncStatusInfo({this.lastSuccessfulSync, this.isSyncing = false, this.isOnline = false, this.isListening = false, this.autoSyncEnabled = true, final  Map<EntityType, int> pendingChangesCount = const {}, this.errorCount = 0, this.lastErrorMessage, final  Map<String, dynamic> additionalInfo = const {}}): _pendingChangesCount = pendingChangesCount,_additionalInfo = additionalInfo;
  factory _SyncStatusInfo.fromJson(Map<String, dynamic> json) => _$SyncStatusInfoFromJson(json);

/// Время последней *успешной* синхронизации всех данных.
/// Может быть null, если синхронизация еще не проводилась успешно.
@override final  DateTime? lastSuccessfulSync;
/// Указывает, выполняется ли операция синхронизации в данный момент.
@override@JsonKey() final  bool isSyncing;
/// Указывает, доступно ли сетевое подключение в данный момент.
@override@JsonKey() final  bool isOnline;
@override@JsonKey() final  bool isListening;
/// Указывает, включена ли автоматическая фоновая синхронизация.
@override@JsonKey() final  bool autoSyncEnabled;
/// Карта, показывающая количество ожидающих (несинхронизированных)
/// изменений для каждого типа сущности ([EntityType]).
 final  Map<EntityType, int> _pendingChangesCount;
/// Карта, показывающая количество ожидающих (несинхронизированных)
/// изменений для каждого типа сущности ([EntityType]).
@override@JsonKey() Map<EntityType, int> get pendingChangesCount {
  if (_pendingChangesCount is EqualUnmodifiableMapView) return _pendingChangesCount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pendingChangesCount);
}

/// Общее количество элементов, синхронизация которых завершилась с ошибкой
/// и требует внимания или повторной попытки.
@override@JsonKey() final  int errorCount;
/// Текстовое сообщение последней возникшей ошибки синхронизации.
/// Null, если ошибок не было или последняя операция была успешной.
@override final  String? lastErrorMessage;
/// Карта для хранения любой дополнительной, специфичной для приложения,
/// информации о состоянии синхронизации.
 final  Map<String, dynamic> _additionalInfo;
/// Карта для хранения любой дополнительной, специфичной для приложения,
/// информации о состоянии синхронизации.
@override@JsonKey() Map<String, dynamic> get additionalInfo {
  if (_additionalInfo is EqualUnmodifiableMapView) return _additionalInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_additionalInfo);
}


/// Create a copy of SyncStatusInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStatusInfoCopyWith<_SyncStatusInfo> get copyWith => __$SyncStatusInfoCopyWithImpl<_SyncStatusInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncStatusInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncStatusInfo&&(identical(other.lastSuccessfulSync, lastSuccessfulSync) || other.lastSuccessfulSync == lastSuccessfulSync)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.isListening, isListening) || other.isListening == isListening)&&(identical(other.autoSyncEnabled, autoSyncEnabled) || other.autoSyncEnabled == autoSyncEnabled)&&const DeepCollectionEquality().equals(other._pendingChangesCount, _pendingChangesCount)&&(identical(other.errorCount, errorCount) || other.errorCount == errorCount)&&(identical(other.lastErrorMessage, lastErrorMessage) || other.lastErrorMessage == lastErrorMessage)&&const DeepCollectionEquality().equals(other._additionalInfo, _additionalInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastSuccessfulSync,isSyncing,isOnline,isListening,autoSyncEnabled,const DeepCollectionEquality().hash(_pendingChangesCount),errorCount,lastErrorMessage,const DeepCollectionEquality().hash(_additionalInfo));

@override
String toString() {
  return 'SyncStatusInfo(lastSuccessfulSync: $lastSuccessfulSync, isSyncing: $isSyncing, isOnline: $isOnline, isListening: $isListening, autoSyncEnabled: $autoSyncEnabled, pendingChangesCount: $pendingChangesCount, errorCount: $errorCount, lastErrorMessage: $lastErrorMessage, additionalInfo: $additionalInfo)';
}


}

/// @nodoc
abstract mixin class _$SyncStatusInfoCopyWith<$Res> implements $SyncStatusInfoCopyWith<$Res> {
  factory _$SyncStatusInfoCopyWith(_SyncStatusInfo value, $Res Function(_SyncStatusInfo) _then) = __$SyncStatusInfoCopyWithImpl;
@override @useResult
$Res call({
 DateTime? lastSuccessfulSync, bool isSyncing, bool isOnline, bool isListening, bool autoSyncEnabled, Map<EntityType, int> pendingChangesCount, int errorCount, String? lastErrorMessage, Map<String, dynamic> additionalInfo
});




}
/// @nodoc
class __$SyncStatusInfoCopyWithImpl<$Res>
    implements _$SyncStatusInfoCopyWith<$Res> {
  __$SyncStatusInfoCopyWithImpl(this._self, this._then);

  final _SyncStatusInfo _self;
  final $Res Function(_SyncStatusInfo) _then;

/// Create a copy of SyncStatusInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastSuccessfulSync = freezed,Object? isSyncing = null,Object? isOnline = null,Object? isListening = null,Object? autoSyncEnabled = null,Object? pendingChangesCount = null,Object? errorCount = null,Object? lastErrorMessage = freezed,Object? additionalInfo = null,}) {
  return _then(_SyncStatusInfo(
lastSuccessfulSync: freezed == lastSuccessfulSync ? _self.lastSuccessfulSync : lastSuccessfulSync // ignore: cast_nullable_to_non_nullable
as DateTime?,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,isListening: null == isListening ? _self.isListening : isListening // ignore: cast_nullable_to_non_nullable
as bool,autoSyncEnabled: null == autoSyncEnabled ? _self.autoSyncEnabled : autoSyncEnabled // ignore: cast_nullable_to_non_nullable
as bool,pendingChangesCount: null == pendingChangesCount ? _self._pendingChangesCount : pendingChangesCount // ignore: cast_nullable_to_non_nullable
as Map<EntityType, int>,errorCount: null == errorCount ? _self.errorCount : errorCount // ignore: cast_nullable_to_non_nullable
as int,lastErrorMessage: freezed == lastErrorMessage ? _self.lastErrorMessage : lastErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,additionalInfo: null == additionalInfo ? _self._additionalInfo : additionalInfo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
