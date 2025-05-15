import '../entities/task/task.dart';

abstract class ITaskRepository {
  Future<List<TaskEntity>> getTask();
  Future<TaskEntity> getTaskById(String id);
  Future<String> createTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String id);
}
