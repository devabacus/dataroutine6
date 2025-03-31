// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskEntity _$TaskEntityFromJson(Map<String, dynamic> json) => _TaskEntity(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  duration: (json['duration'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  dueDateTime: DateTime.parse(json['dueDateTime'] as String),
  categoryId: (json['categoryId'] as num).toInt(),
);

Map<String, dynamic> _$TaskEntityToJson(_TaskEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'duration': instance.duration,
      'createdAt': instance.createdAt.toIso8601String(),
      'dueDateTime': instance.dueDateTime.toIso8601String(),
      'categoryId': instance.categoryId,
    };
