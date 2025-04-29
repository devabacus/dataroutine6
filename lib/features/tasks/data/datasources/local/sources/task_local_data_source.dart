import 'package:dataroutine6/core/database/local/interface/database_service.dart';
import 'package:dataroutine6/features/tasks/data/datasources/local/interfaces/task_local_datasource_service.dart';
import 'package:dataroutine6/features/tasks/data/models/extensions/task_model_extension.dart';
import 'package:dataroutine6/features/tasks/data/datasources/local/tables/extensions/task_table_extension.dart';

import '../../../models/task/task_model.dart';
import '../../local/dao/task_dao.dart';

class TaskLocalDataSource implements ITaskLocalDataSource{
  final TaskDao _taskDao;

  TaskLocalDataSource(IDatabaseService databaseService) : _taskDao = TaskDao(databaseService);

  @override
  Future<List<TaskModel>> getTask() async {
    final task = await _taskDao.getTask();
    return task.toModels();
  }

  @override
  Future<TaskModel> getTaskById(int id) async {
    final task = await _taskDao.getTaskById(id);
    return task.toModel();
  }

  @override
  Future<int> createTask(TaskModel task) {
    return _taskDao.createTask(task.toCompanion());
  }

  @override
  Future<void> updateTask(TaskModel task) {
    return _taskDao.updateTask(task.toCompanionWithId());
  }

  @override
  Future<void> deleteTask(int id) async {
    _taskDao.deleteTask(id);
  }
}
