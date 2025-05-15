import '../../../models/task/task_model.dart';

abstract class ITaskLocalDataSource {
  Future<List<TaskModel>> getTask();
  Future<TaskModel> getTaskById(String id);
  Future<String> createTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}
