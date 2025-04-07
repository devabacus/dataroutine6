import '../../../models/task/task_model.dart';

abstract class ITaskLocalDataSource {
  Future<List<TaskModel>> getTask();
  Future<TaskModel> getTaskById(int id);
  Future<int> createTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(int id);
}
