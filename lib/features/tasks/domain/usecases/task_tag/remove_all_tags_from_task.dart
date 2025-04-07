import '../../repositories/task_tag_map_repository.dart';

class RemoveAllTagsFromTaskUseCase {
  final ITaskTagMapRepository repository;

  RemoveAllTagsFromTaskUseCase(this.repository);

  Future<void> call(int taskId) {
    return repository.removeAllTagsFromTask(taskId);
  }
}
