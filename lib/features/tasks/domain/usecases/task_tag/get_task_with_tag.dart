import '../../entities/task/task.dart';
import '../../repositories/task_tag_map_repository.dart';

class GetTaskWithTagUseCase {
  final ITaskTagMapRepository repository;

  const GetTaskWithTagUseCase(this.repository);

  Future<List<TaskEntity>> call(int tagId) {
    return repository.getTasksWithTag(tagId);
  }
}
