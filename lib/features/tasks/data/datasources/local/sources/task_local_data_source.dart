import 'package:dataroutine6/features/tasks/data/models/extensions/task_model_extension.dart';
import 'package:dataroutine6/features/tasks/data/models/extensions/task_table_extension.dart';

import '../../../../../../core/database/local/database.dart';
import '../../../../data/models/task_model.dart';
import '../../local/dao/task_dao.dart';

class TaskLocalDataSource {
  final TaskDao _taskDao;

  TaskLocalDataSource(AppDatabase db) : _taskDao = TaskDao(db);

  Future<List<TaskModel>> getTask() async {
    final task = await _taskDao.getTask();
    return task.toModels();
  }

  Future<TaskModel> getTaskById(int id) async {
    final task = await _taskDao.getTaskById(id);
    return task.toModel();
  }

  Future<int> createTask(TaskModel task) {
    return _taskDao.createTask(task.toCompanion());
  }

  Future<void> updateTask(TaskModel task) {
    return _taskDao.updateTask(task.toCompanionWithId());
  }

  Future<void> deleteTask(int id) async {
    _taskDao.deleteTask(id);
  }
}
