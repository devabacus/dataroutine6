
import '../../repositories/task_repository.dart';
import '../../entities/task.dart';

class GetTaskUseCase {
  final TaskRepository _repository;

  GetTaskUseCase(this._repository);

  Future<List<TaskEntity>> call() {
    return _repository.getTask();
  }
}
