


import 'package:dataroutine6/features/tasks/domain/repositories/task_tag_map_repository.dart';

class AddTagToTaskUseCase {
  final TaskTagMappingRepository repository;

  const AddTagToTaskUseCase(this.repository);

  Future<void> call (int taskId, int tagId){
      return repository.addTagToTask(taskId, tagId);
  }

  
}