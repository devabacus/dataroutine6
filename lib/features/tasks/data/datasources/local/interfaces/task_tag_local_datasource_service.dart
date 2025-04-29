import '../../../models/tag/tag_model.dart';
import '../../../models/task/task_model.dart';

abstract class ITaskTagMapLocalDataSource {
  Future<List<TagModel>> getTagsForTask(int taskId);
  Future<List<TaskModel>> getTasksWithTag(int tagId);
  Future<void> addTagToTask(int taskId, int tagId);
  Future<void> removeTagFromTask(int taskId, int tagId);
  Future<void> removeAllTagsFromTask(int taskId);
}
