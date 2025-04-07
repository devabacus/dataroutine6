import '../../repositories/task_repository.dart';
import '../../entities/task/task.dart';

class GetTaskByIdUseCase {
  final ITaskRepository _repository;

  GetTaskByIdUseCase(this._repository);

  Future<TaskEntity?> call(int id) {
    return _repository.getTaskById(id);
  }
}
