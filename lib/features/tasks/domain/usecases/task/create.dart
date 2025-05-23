import '../../repositories/task_repository.dart';
import '../../entities/task/task.dart';

class CreateTaskUseCase {
  final ITaskRepository _repository;

  CreateTaskUseCase(this._repository);

  Future<int> call(TaskEntity task) {
    return _repository.createTask(task);
  }
}
