
import '../../../../../../core/database/local/database.dart';
import '../../local/dao/task_dao.dart';
import '../../../../data/models/task_model.dart';
import 'package:drift/drift.dart';

class TaskLocalDataSource {
  final TaskDao _taskDao;

  TaskLocalDataSource(AppDatabase db) : _taskDao = TaskDao(db);

  Future<List<TaskModel>> getTask() async {
    final task = await _taskDao.getTask();
    return task
        .map(
          (task) => TaskModel(id: task.id, title: task.title, description: task.description, duration: task.duration, createdAt: task.createdAt, dueDateTime: task.dueDateTime, categoryId: task.categoryId),
        )
        .toList();
  }

  Future<TaskModel> getTaskById(int id) async {
    final task = await _taskDao.getTaskById(id);
    return TaskModel(id: task.id, title: task.title, description: task.description, duration: task.duration, createdAt: task.createdAt, dueDateTime: task.dueDateTime, categoryId: task.categoryId);
  }

  Future<int> createTask(TaskModel task) {
    return _taskDao.createTask(
      TaskTableCompanion.insert(title: task.title, description: task.description, duration: task.duration, createdAt: task.createdAt, dueDateTime: task.dueDateTime, categoryId: task.categoryId),
    );
  }

  Future<void> updateTask(TaskModel task) {
    return _taskDao.updateTask(
      TaskTableCompanion(id: Value(task.id), title: Value(task.title), description: Value(task.description), duration: Value(task.duration), createdAt: Value(task.createdAt), dueDateTime: Value(task.dueDateTime), categoryId: Value(task.categoryId)),
    );
  }

  Future<void> deleteTask(int id) async {
      _taskDao.deleteTask(id);
    }

}
