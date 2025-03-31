
import '../../data/datasources/local/sources/task_local_data_source.dart';

import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;

  TaskRepositoryImpl(this._localDataSource);
// ---------auto generated------------------//
  @override
  Future<List<TaskEntity>> getTask() async {
    final taskModels = await _localDataSource.getTask();
    return taskModels
        .map((model) => TaskEntity(id: model.id, title: model.title, description: model.description, duration: model.duration, createdAt: model.createdAt, dueDateTime: model.dueDateTime, categoryId: model.categoryId))
        .toList();
  }

  @override
  Future<TaskEntity> getTaskById(int id) async {
    final model = await _localDataSource.getTaskById(id);
    return TaskEntity(id: model.id, title: model.title, description: model.description, duration: model.duration, createdAt: model.createdAt, dueDateTime: model.dueDateTime, categoryId: model.categoryId);
  }

  @override
  Future<int> createTask(TaskEntity task) {
    return _localDataSource.createTask(
      TaskModel(id: task.id, title: task.title, description: task.description, duration: task.duration, createdAt: task.createdAt, dueDateTime: task.dueDateTime, categoryId: task.categoryId),
    );
  }

  @override
  Future<void> deleteTask(int id) async {
    _localDataSource.deleteTask(id);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    _localDataSource.updateTask(
      TaskModel(id: task.id, title: task.title, description: task.description, duration: task.duration, createdAt: task.createdAt, dueDateTime: task.dueDateTime, categoryId: task.categoryId),
    );
  }
    // ---------auto generated------------------//
    //custom methods
}
