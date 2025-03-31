

import '../../domain/entities/tag.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_tag_map_repository.dart';
import '../datasources/local/sources/task_tag_map_local_data_source.dart';

class TaskTagMappingRepositoryImpl implements TaskTagMappingRepository {
  final TaskTagMappingLocalDataSource _dataSource;

  TaskTagMappingRepositoryImpl(this._dataSource);

  @override
  Future<List<TagEntity>> getTagsForTask(int taskId) async {
    final tagModels = await _dataSource.getTagsForTask(taskId);
    return tagModels.map((model) => TagEntity(id: model.id, title: model.title)).toList();
  }

  @override
  Future<List<TaskEntity>> getTasksWithTag(int tagId) async {
    final taskModels = await _dataSource.getTasksWithTag(tagId);
    return taskModels.map((model) => TaskEntity(
          id: model.id,
          title: model.title,
          description: model.description,
          duration: model.duration,
          createdAt: model.createdAt,
          dueDateTime: model.dueDateTime,
          categoryId: model.categoryId,
        )).toList();
  }

  @override
  Future<void> addTagToTask(int taskId, int tagId) async {
    await _dataSource.addTagToTask(taskId, tagId);
  }

  @override
  Future<void> removeTagFromTask(int taskId, int tagId) async {
    await _dataSource.removeTagFromTask(taskId, tagId);
  }

  @override
  Future<void> removeAllTagsFromTask(int taskId) async {
    await _dataSource.removeAllTagsFromTask(taskId);
  }
  
  // @override
  // Future<bool> hasTaskTag(int taskId, int tagId) {
  //   // TODO: implement hasTaskTag
  //   throw UnimplementedError();
  // }
  
  // @override
  // Future<void> updateTaskTags(int taskId, List<int> tagIds) {
  //   // TODO: implement updateTaskTags
  //   throw UnimplementedError();
  // }
}