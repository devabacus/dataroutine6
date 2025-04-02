import 'package:dataroutine6/features/tasks/domain/repositories/task_tag_map_repository.dart';

class RemoveTagFromTaskUseCase {
  final TaskTagMapRepository repository;

  RemoveTagFromTaskUseCase(this.repository);

  Future<void> call(int taskId, int tagId) {
    return repository.removeTagFromTask(taskId, tagId);
  }
}
