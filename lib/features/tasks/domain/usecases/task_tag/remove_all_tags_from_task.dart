import 'package:dataroutine6/features/tasks/domain/repositories/task_tag_map_repository.dart';

class RemoveAllTagsFromTaskUseCase {
  final TaskTagMapRepository repository;

  RemoveAllTagsFromTaskUseCase(this.repository);

  Future<void> call(int taskId) {
    return repository.removeAllTagsFromTask(taskId);
  }
}
