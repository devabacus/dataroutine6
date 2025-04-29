import '../../domain/entities/tag/tag.dart';
import '../../domain/entities/task/task.dart';
import '../../domain/repositories/task_tag_map_repository.dart';
import '../datasources/local/interfaces/task_tag_local_datasource_service.dart';
import '../models/extensions/tag_models_extension.dart';
import '../models/extensions/task_model_extension.dart';

class TaskTagMapRepositoryImpl implements ITaskTagMapRepository {
  final ITaskTagMapLocalDataSource _dataSource;

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
