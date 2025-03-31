
import '../../repositories/tag_repository.dart';

class DeleteTagUseCase {
  final TagRepository _repository;

  DeleteTagUseCase(this._repository);

  Future<void> call(int id) async {
    return _repository.deleteTag(id);
  }
}
