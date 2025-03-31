
import 'package:drift/drift.dart';
import '../../../../../../../core/database/local/database.dart';
import '../tables/task_table.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [TaskTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Future<List<TaskTableData>> getTask() => select(taskTable).get();
  
  Future<TaskTableData> getTaskById(int id) => 
      (select(taskTable)..where((t) => t.id.equals(id)))
      .getSingle();
  
  Future<int> createTask(TaskTableCompanion task) =>
      into(taskTable).insert(task);
  
  Future<void> updateTask(TaskTableCompanion task) =>
      update(taskTable).replace(task);
  
  Future<void> deleteTask(int id) =>
      (delete(taskTable)..where((t) => t.id.equals(id))).go();
}

