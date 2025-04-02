import 'package:dataroutine6/features/tasks/data/models/extensions/tag_table_extension.dart';
import 'package:dataroutine6/features/tasks/data/models/extensions/task_table_extension.dart';

import '../../../../../../core/database/local/database.dart';
import '../../../models/tag_model.dart';
import '../../../models/task_model.dart';
import '../dao/task_tag_map_dao.dart';

class TaskTagMapLocalDataSource {
  final TaskTagMappingDao _dao;

  TaskTagMapLocalDataSource(AppDatabase db) : _dao = TaskTagMappingDao(db);

  Future<List<TagModel>> getTagsForTask(int taskId) async {
    final tags = await _dao.getTagsForTask(taskId);
    return tags.toModels();
  }

  Future<List<TaskModel>> getTasksWithTag(int tagId) async {
    final tasks = await _dao.getTasksWithTag(tagId);
    return tasks.toModels();

  }

  Future<void> addTagToTask(int taskId, int tagId) async {
    await _dao.addTagToTask(taskId, tagId);
  }

  Future<void> removeTagFromTask(int taskId, int tagId) async {
    await _dao.removeTagFromTask(taskId, tagId);
  }

  Future<void> removeAllTagsFromTask(int taskId) async {
    await _dao.removeAllTagsFromTask(taskId);
  }
}
