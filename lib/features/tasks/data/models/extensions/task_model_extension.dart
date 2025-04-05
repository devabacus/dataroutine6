import 'package:dataroutine6/core/database/local/database.dart';
import 'package:dataroutine6/features/tasks/domain/entities/task/task.dart';
import 'package:drift/drift.dart';

import '../task/task_model.dart';

extension TaskModelExtension on TaskModel {
  // for insert
  TaskTableCompanion toCompanion() => TaskTableCompanion.insert(
    title: title,
    description: description,
    duration: duration,
    createdAt: createdAt,
    dueDateTime: dueDateTime,
    categoryId: categoryId,
  );

  // for update
  TaskTableCompanion toCompanionWithId() => TaskTableCompanion(
    id: Value(id),
    title: Value(title),
    description: Value(description),
    duration: Value(duration),
    createdAt: Value(createdAt),
    dueDateTime: Value(dueDateTime),
    categoryId: Value(categoryId),
  );

  TaskEntity toEntity() => TaskEntity(
    id: id,
    title: title,
    description: description,
    duration: duration,
    createdAt: createdAt,
    dueDateTime: dueDateTime,
    categoryId: categoryId,
  );
}

extension TaskModelListExtension on List<TaskModel> {
  List<TaskEntity> toEntities() => map((data) => data.toEntity()).toList();
}
