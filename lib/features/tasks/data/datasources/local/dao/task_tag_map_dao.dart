import 'package:drift/drift.dart';
import '../../../../../../core/database/local/database.dart';
import '../tables/tag_table.dart';
import '../tables/task_table.dart';
import '../tables/task_tag_map_table.dart';

part 'task_tag_map_dao.g.dart';

@DriftAccessor(tables: [TaskTagMapTable, TaskTable, TagTable])
class TaskTagMapDao extends DatabaseAccessor<AppDatabase> with _$TaskTagMapDaoMixin {
  TaskTagMapDao(super.db);

  // Получить все теги задачи
  Future<List<TagTableData>> getTagsForTask(int taskId) {
    return (select(tagTable)
      ..where((t) => t.id.isInQuery(
          selectOnly(taskTagMapTable)
            ..addColumns([taskTagMapTable.tagId])
            ..where(taskTagMapTable.taskId.equals(taskId)))))
        .get();
  }

  // Получить все задачи с определенным тегом
  Future<List<TaskTableData>> getTasksWithTag(int tagId) {
    return (select(taskTable)
      ..where((t) => t.id.isInQuery(
          selectOnly(taskTagMapTable)
            ..addColumns([taskTagMapTable.taskId])
            ..where(taskTagMapTable.tagId.equals(tagId)))))
        .get();
  }

  // Добавить тег к задаче
  Future<void> addTagToTask(int taskId, int tagId) {
    return into(taskTagMapTable).insert(
      TaskTagMapTableCompanion.insert(taskId: taskId, tagId: tagId),
    );
  }

  // Удалить тег у задачи
  Future<void> removeTagFromTask(int taskId, int tagId) {
    return (delete(taskTagMapTable)
      ..where((t) => t.taskId.equals(taskId) & t.tagId.equals(tagId)))
        .go();
  }

  // Удалить все теги у задачи
  Future<void> removeAllTagsFromTask(int taskId) {
    return (delete(taskTagMapTable)..where((t) => t.taskId.equals(taskId))).go();
  }
}