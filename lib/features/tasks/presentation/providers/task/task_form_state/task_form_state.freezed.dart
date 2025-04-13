// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskFormState {

 bool get isInitialized; int? get taskId; int? get categoryId; String get categoryTitle; TaskEntity? get currentTask;
/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFormStateCopyWith<TaskFormState> get copyWith => _$TaskFormStateCopyWithImpl<TaskFormState>(this as TaskFormState, _$identity);

  /// Serializes this TaskFormState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormState&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryTitle, categoryTitle) || other.categoryTitle == categoryTitle)&&(identical(other.currentTask, currentTask) || other.currentTask == currentTask));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isInitialized,taskId,categoryId,categoryTitle,currentTask);

@override
String toString() {
  return 'TaskFormState(isInitialized: $isInitialized, taskId: $taskId, categoryId: $categoryId, categoryTitle: $categoryTitle, currentTask: $currentTask)';
}


}

/// @nodoc
abstract mixin class $TaskFormStateCopyWith<$Res>  {
  factory $TaskFormStateCopyWith(TaskFormState value, $Res Function(TaskFormState) _then) = _$TaskFormStateCopyWithImpl;
@useResult
$Res call({
 bool isInitialized, int? taskId, int? categoryId, String categoryTitle, TaskEntity? currentTask
});


$TaskEntityCopyWith<$Res>? get currentTask;

}
/// @nodoc
class _$TaskFormStateCopyWithImpl<$Res>
    implements $TaskFormStateCopyWith<$Res> {
  _$TaskFormStateCopyWithImpl(this._self, this._then);

  final TaskFormState _self;
  final $Res Function(TaskFormState) _then;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isInitialized = null,Object? taskId = freezed,Object? categoryId = freezed,Object? categoryTitle = null,Object? currentTask = freezed,}) {
  return _then(_self.copyWith(
isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,categoryTitle: null == categoryTitle ? _self.categoryTitle : categoryTitle // ignore: cast_nullable_to_non_nullable
as String,currentTask: freezed == currentTask ? _self.currentTask : currentTask // ignore: cast_nullable_to_non_nullable
as TaskEntity?,
  ));
}
/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskEntityCopyWith<$Res>? get currentTask {
    if (_self.currentTask == null) {
    return null;
  }

  return $TaskEntityCopyWith<$Res>(_self.currentTask!, (value) {
    return _then(_self.copyWith(currentTask: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _TaskFormState implements TaskFormState {
  const _TaskFormState({this.isInitialized = false, this.taskId, this.categoryId, this.categoryTitle = '', this.currentTask});
  factory _TaskFormState.fromJson(Map<String, dynamic> json) => _$TaskFormStateFromJson(json);

@override@JsonKey() final  bool isInitialized;
@override final  int? taskId;
@override final  int? categoryId;
@override@JsonKey() final  String categoryTitle;
@override final  TaskEntity? currentTask;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskFormStateCopyWith<_TaskFormState> get copyWith => __$TaskFormStateCopyWithImpl<_TaskFormState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskFormStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskFormState&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryTitle, categoryTitle) || other.categoryTitle == categoryTitle)&&(identical(other.currentTask, currentTask) || other.currentTask == currentTask));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isInitialized,taskId,categoryId,categoryTitle,currentTask);

@override
String toString() {
  return 'TaskFormState(isInitialized: $isInitialized, taskId: $taskId, categoryId: $categoryId, categoryTitle: $categoryTitle, currentTask: $currentTask)';
}


}

/// @nodoc
abstract mixin class _$TaskFormStateCopyWith<$Res> implements $TaskFormStateCopyWith<$Res> {
  factory _$TaskFormStateCopyWith(_TaskFormState value, $Res Function(_TaskFormState) _then) = __$TaskFormStateCopyWithImpl;
@override @useResult
$Res call({
 bool isInitialized, int? taskId, int? categoryId, String categoryTitle, TaskEntity? currentTask
});


@override $TaskEntityCopyWith<$Res>? get currentTask;

}
/// @nodoc
class __$TaskFormStateCopyWithImpl<$Res>
    implements _$TaskFormStateCopyWith<$Res> {
  __$TaskFormStateCopyWithImpl(this._self, this._then);

  final _TaskFormState _self;
  final $Res Function(_TaskFormState) _then;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isInitialized = null,Object? taskId = freezed,Object? categoryId = freezed,Object? categoryTitle = null,Object? currentTask = freezed,}) {
  return _then(_TaskFormState(
isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,categoryTitle: null == categoryTitle ? _self.categoryTitle : categoryTitle // ignore: cast_nullable_to_non_nullable
as String,currentTask: freezed == currentTask ? _self.currentTask : currentTask // ignore: cast_nullable_to_non_nullable
as TaskEntity?,
  ));
}

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskEntityCopyWith<$Res>? get currentTask {
    if (_self.currentTask == null) {
    return null;
  }

  return $TaskEntityCopyWith<$Res>(_self.currentTask!, (value) {
    return _then(_self.copyWith(currentTask: value));
  });
}
}

// dart format on
