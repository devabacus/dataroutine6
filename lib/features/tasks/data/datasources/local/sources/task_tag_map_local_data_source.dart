import 'package:dataroutine6/core/database/local/interface/database_service.dart';
import 'package:dataroutine6/features/tasks/data/datasources/local/interfaces/task_tag_local_datasource_service.dart';

import '../tables/extensions/tag_table_extension.dart';
import '../tables/extensions/task_table_extension.dart';
import '../../../models/tag/tag_model.dart';
import '../../../models/task/task_model.dart';
import '../dao/task_tag_map_dao.dart';

class TaskTagMapLocalDataSource implements ITaskTagMapLocalDataSource{
  final TaskTagMapDao _dao;

  TaskTagMapLocalDataSource(IDatabaseService databaseService) : _dao = TaskTagMapDao(databaseService);

  @override
  Future<List<TagModel>> getTagsForTask(int taskId) async {
    final tags = await _dao.getTagsForTask(taskId);
    return tags.toModels();
  }

  @override
  Future<List<TaskModel>> getTasksWithTag(int tagId) async {
    final tasks = await _dao.getTasksWithTag(tagId);
    return tasks.toModels();
  }

  @override
  Future<void> addTagToTask(int taskId, int tagId) async {
    await _dao.addTagToTask(taskId, tagId);
  }

  @override
  Future<void> removeTagFromTask(int taskId, int tagId) async {
    await _dao.removeTagFromTask(taskId, tagId);
  }

  @override
  Future<void> removeAllTagsFromTask(int taskId) async {
    await _dao.removeAllTagsFromTask(taskId);
  }
}
