// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TagEntity {

 String get id; String get title;
/// Create a copy of TagEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagEntityCopyWith<TagEntity> get copyWith => _$TagEntityCopyWithImpl<TagEntity>(this as TagEntity, _$identity);

  /// Serializes this TagEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'TagEntity(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class $TagEntityCopyWith<$Res>  {
  factory $TagEntityCopyWith(TagEntity value, $Res Function(TagEntity) _then) = _$TagEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class _$TagEntityCopyWithImpl<$Res>
    implements $TagEntityCopyWith<$Res> {
  _$TagEntityCopyWithImpl(this._self, this._then);

  final TagEntity _self;
  final $Res Function(TagEntity) _then;

/// Create a copy of TagEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TagEntity implements TagEntity {
  const _TagEntity({required this.id, required this.title});
  factory _TagEntity.fromJson(Map<String, dynamic> json) => _$TagEntityFromJson(json);

@override final  String id;
@override final  String title;

/// Create a copy of TagEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagEntityCopyWith<_TagEntity> get copyWith => __$TagEntityCopyWithImpl<_TagEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TagEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'TagEntity(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class _$TagEntityCopyWith<$Res> implements $TagEntityCopyWith<$Res> {
  factory _$TagEntityCopyWith(_TagEntity value, $Res Function(_TagEntity) _then) = __$TagEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class __$TagEntityCopyWithImpl<$Res>
    implements _$TagEntityCopyWith<$Res> {
  __$TagEntityCopyWithImpl(this._self, this._then);

  final _TagEntity _self;
  final $Res Function(_TagEntity) _then;

/// Create a copy of TagEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,}) {
  return _then(_TagEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
