import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final int duration;
  final DateTime createdAt;
  final DateTime dueDateTime;
  final int categoryId;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.createdAt,
    required this.dueDateTime,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    duration,
    createdAt,
    dueDateTime,
    categoryId,
  ];
}
