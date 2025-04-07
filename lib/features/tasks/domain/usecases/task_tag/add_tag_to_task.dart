import '../../repositories/task_tag_map_repository.dart';

class AddTagToTaskUseCase {
  final ITaskTagMapRepository repository;

  const AddTagToTaskUseCase(this.repository);

  Future<void> call(int taskId, int tagId) {
    return repository.addTagToTask(taskId, tagId);
  }
}
