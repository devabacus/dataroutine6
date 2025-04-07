import '../entities/task/task.dart';

abstract class ITaskRepository {
  Future<List<TaskEntity>> getTask();
  Future<TaskEntity> getTaskById(int id);
  Future<int> createTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(int id);
}
