import 'package:dataroutine6/core/database/local/database.dart';
import 'package:dataroutine6/features/tasks/data/models/task_model.dart';

extension TaskTableDataExtension on TaskTableData {
  TaskModel toModel() => TaskModel(
    id: id,
    title: title,
    description: description,
    duration: duration,
    createdAt: createdAt,
    dueDateTime: dueDateTime,
    categoryId: categoryId,
  );
}

extension TaskTableDataListExtension on List<TaskTableData> {
  List<TaskModel> toModels() => map((data) => data.toModel()).toList();
}
