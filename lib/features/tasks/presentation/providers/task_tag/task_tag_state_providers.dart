import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/tag.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/providers/task_tag_usecase_providers.dart';

part 'task_tag_state_providers.g.dart';

@riverpod
class TaskTags extends _$TaskTags {
  @override
  Future<List<TagEntity>> build({required int taskId}) {
    return ref.read(getTagsForTaskUseCaseProvider)(taskId);
  }

  Future<void> addTagToTask(int taskId, int tagId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(addTagToTaskUseCaseProvider)(taskId, tagId);
      return ref.read(getTagsForTaskUseCaseProvider)(taskId);
    });
  }

  Future<void> removeTagFromTask(int taskId, int tagId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(removeTagFromTaskUseCaseProvider)(taskId, tagId);
      return ref.read(getTagsForTaskUseCaseProvider)(taskId);
    });
  }

  Future<void> removeAllTagsFromTask(int taskId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(removeAllTagsFromTaskUseCaseProvider)(taskId);
      return ref.read(getTagsForTaskUseCaseProvider)(taskId);
    });
  }
}

@riverpod
class TasksWithTag extends _$TasksWithTag {
  @override
  Future<List<TaskEntity>> build({required int tagId}) {
    return ref.read(getTaskWithTagUseCaseProvider)(tagId);
  }
}