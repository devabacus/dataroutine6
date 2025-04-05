import 'package:dataroutine6/features/tasks/data/repositories/task_tag_map_repository.dart';
import 'package:dataroutine6/features/tasks/domain/entities/task/task.dart';

import '../../repositories/task_tag_map_repository.dart';

class GetTaskWithTagUseCase {
  final TaskTagMapRepository repository;

  const GetTaskWithTagUseCase(this.repository);

  Future<List<TaskEntity>> call(int tagId) {
    return repository.getTasksWithTag(tagId);
  }
}
