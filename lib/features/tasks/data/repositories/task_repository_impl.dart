
import 'package:dataroutine6/features/tasks/data/models/extensions/task_model_extension.dart';
import 'package:dataroutine6/features/tasks/domain/entities/extensions/task_entity_extension.dart';

import '../../data/datasources/local/sources/task_local_data_source.dart';
import '../../domain/entities/task/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;

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
    return _localDataSource.createTask(
      task.toModel()
    );
  }

  @override
  Future<void> deleteTask(int id) async {
    _localDataSource.deleteTask(id);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    _localDataSource.updateTask(
      task.toModel()
    );
  }
    // ---------auto generated------------------//
    //custom methods
}
