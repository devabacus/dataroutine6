import 'package:dataroutine6/features/tasks/data/repositories/task_tag_map_repository.dart';
import 'package:dataroutine6/features/tasks/domain/entities/task.dart';

class GetTaskWithTagUseCase {
  final TaskTagMapRepositoryImpl repository;

  const GetTaskWithTagUseCase(this.repository);

  Future<List<TaskEntity>> call(int tagId) {
    return repository.getTasksWithTag(tagId);
  }
}
