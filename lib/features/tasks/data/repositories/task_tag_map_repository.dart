import 'package:dataroutine6/features/tasks/data/models/extensions/tag_models_extension.dart';
import 'package:dataroutine6/features/tasks/data/models/extensions/task_model_extension.dart';

import '../../domain/entities/tag.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_tag_map_repository.dart';
import '../datasources/local/sources/task_tag_map_local_data_source.dart';

class TaskTagMapRepositoryImpl implements TaskTagMappingRepository {
  final TaskTagMapLocalDataSource _dataSource;

  TaskTagMapRepositoryImpl(this._dataSource);

  @override
  Future<List<TagEntity>> getTagsForTask(int taskId) async {
    final tagModels = await _dataSource.getTagsForTask(taskId);
    return tagModels.toEntities(); //for tag

  }

  @override
  Future<List<TaskEntity>> getTasksWithTag(int tagId) async {
    final taskModels = await _dataSource.getTasksWithTag(tagId);
    return taskModels.toEntities(); // for task

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

  
}
