
import 'package:dataroutine6/features/tasks/presentation/providers/tag/tag_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task_tag/task_tag_state_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/tag/tag.dart';

part 'filter_tag_for_task_provider.g.dart';


@riverpod
Future<List<TagEntity>> filteredTagsForTask(ref, int? taskId) async {
  final allTags = await ref.watch(tagProvider.future);
  
  if (taskId == null) {
    return allTags;
  }
  
  final assignedTags = await ref.watch(taskTagsProvider(taskId: taskId).future);
  

  // все tasks которые не назначены на taskId
  return allTags.where((tag) {
    return !assignedTags.any((assignedTag) => assignedTag.id == tag.id);
  }).toList();
}






