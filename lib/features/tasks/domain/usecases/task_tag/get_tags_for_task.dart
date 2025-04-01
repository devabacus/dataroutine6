

import 'package:dataroutine6/features/tasks/domain/entities/tag.dart';
import 'package:dataroutine6/features/tasks/domain/repositories/task_tag_map_repository.dart';

class GetTagsForTaskUseCase {
  final TaskTagMappingRepository repository;

  GetTagsForTaskUseCase(this.repository);

  Future<List<TagEntity>> call(int taskId){
    return repository.getTagsForTask(taskId);
  }
}

