import 'package:dataroutine6/core/database/local/interface/database_service.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../../core/database/local/database.dart';
import '../tables/task_table.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [TaskTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(IDatabaseService databaseService) : super(databaseService.database);

final Uuid _uuid = Uuid();

  Future<List<TaskTableData>> getTask() => select(taskTable).get();

  Future<TaskTableData> getTaskById(String id) =>
      (select(taskTable)..where((t) => t.id.equals(id))).getSingle();

Future<String> createTask(TaskTableCompanion companion) async {
  String idToInsert;
  TaskTableCompanion companionForInsert;

  if (companion.id.present && companion.id.value.isNotEmpty) {
    idToInsert = companion.id.value;
    companionForInsert = companion;
  } else {
    idToInsert = _uuid.v7(); 
    companionForInsert = companion.copyWith(id: Value(idToInsert));
  }
  
  await into(taskTable).insert(companionForInsert);
  return idToInsert;
}

  Future<void> updateTask(TaskTableCompanion task) =>
      update(taskTable).replace(task);

  Future<void> deleteTask(String id) =>
      (delete(taskTable)..where((t) => t.id.equals(id))).go();
}
