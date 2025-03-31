
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<void> call(TaskEntity task) async {
    return _repository.updateTask(task);
  }
}
