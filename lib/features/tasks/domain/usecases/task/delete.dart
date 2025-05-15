import '../../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final ITaskRepository _repository;

  DeleteTaskUseCase(this._repository);

  Future<void> call(String id) async {
    return _repository.deleteTask(id);
  }
}
