import 'package:dataroutine6/features/tasks/data/models/extensions/task_model_extension.dart';
import 'package:dataroutine6/features/tasks/domain/entities/extensions/task_entity_extension.dart';

import '../../domain/entities/task/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local/interface/task_local_datasource_service.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final ITaskLocalDataSource _localDataSource;

  TaskRepositoryImpl(this._localDataSource);
  // ---------auto generated------------------//
  @override
  Future<List<TaskEntity>> getTask() async {
    final taskModels = await _localDataSource.getTask();
    return taskModels.toEntities();
  }

  @override
  Future<TaskEntity> getTaskById(int id) async {
    final model = await _localDataSource.getTaskById(id);
    return model.toEntity();
  }

  @override
  Future<int> createTask(TaskEntity task) {
    return _localDataSource.createTask(task.toModel());
  }

  @override
  Future<void> deleteTask(int id) async {
    _localDataSource.deleteTask(id);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    _localDataSource.updateTask(task.toModel());
  }
}
