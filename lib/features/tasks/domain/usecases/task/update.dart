import '../../entities/task/task.dart';
import '../../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final ITaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<void> call(TaskEntity task) async {
    return _repository.updateTask(task);
  }
}
