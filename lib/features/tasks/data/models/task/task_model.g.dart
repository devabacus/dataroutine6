// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => _TaskModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  duration: (json['duration'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  dueDateTime: DateTime.parse(json['dueDateTime'] as String),
  categoryId: json['categoryId'] as String,
);

Map<String, dynamic> _$TaskModelToJson(_TaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'duration': instance.duration,
      'createdAt': instance.createdAt.toIso8601String(),
      'dueDateTime': instance.dueDateTime.toIso8601String(),
      'categoryId': instance.categoryId,
    };
