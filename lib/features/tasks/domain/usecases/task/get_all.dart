import '../../repositories/task_repository.dart';
import '../../entities/task/task.dart';

class GetTaskUseCase {
  final ITaskRepository _repository;

  GetTaskUseCase(this._repository);

  Future<List<TaskEntity>> call() {
    return _repository.getTask();
  }
}
