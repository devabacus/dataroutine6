import '../../entities/tag/tag.dart';
import '../../repositories/task_tag_map_repository.dart';

class GetTagsForTaskUseCase {
  final TaskTagMapRepository repository;

  GetTagsForTaskUseCase(this.repository);

  Future<List<TagEntity>> call(int taskId) {
    return repository.getTagsForTask(taskId);
  }
}
