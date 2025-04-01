


import 'package:dataroutine6/features/tasks/data/providers/task_tag_map_data_providers.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/task_tag/add_tag_to_task.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/task_tag/get_tags_for_task.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/task_tag/get_task_with_tag.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/task_tag/remove_all_tags_from_task.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/task_tag/remove_tag_from_task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'task_tag_usecase_providers.g.dart';



@riverpod
AddTagToTaskUseCase addTagToTaskUseCase (Ref ref) {
  final repository = ref.read(taskTagMapRepositoryImplProvider);
  return AddTagToTaskUseCase(repository);
}

@riverpod
GetTagsForTaskUseCase getTagsForTaskUseCase(Ref ref) {
  final repository = ref.read(taskTagMapRepositoryImplProvider);
  return GetTagsForTaskUseCase(repository);
}

@riverpod
GetTaskWithTagUseCase getTaskWithTagUseCase(Ref ref) {
  final repository = ref.read(taskTagMapRepositoryImplProvider);
  return GetTaskWithTagUseCase(repository);
}

@riverpod
RemoveTagFromTaskUseCase removeTagFromTaskUseCase(Ref ref) {
  final repository = ref.read(taskTagMapRepositoryImplProvider);
  return RemoveTagFromTaskUseCase(repository);
}

@riverpod
RemoveAllTagsFromTaskUseCase removeAllTagsFromTaskUseCase(Ref ref) {
  final repository = ref.read(taskTagMapRepositoryImplProvider);
  return RemoveAllTagsFromTaskUseCase(repository);
}








