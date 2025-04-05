import 'package:dataroutine6/features/tasks/domain/entities/tag/tag.dart';
import 'package:dataroutine6/features/tasks/domain/repositories/task_tag_map_repository.dart';

class GetTagsForTaskUseCase {
  final TaskTagMapRepository repository;

  GetTagsForTaskUseCase(this.repository);

  Future<List<TagEntity>> call(int taskId) {
    return repository.getTagsForTask(taskId);
  }
}
