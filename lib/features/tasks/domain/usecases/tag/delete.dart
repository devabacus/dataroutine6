import '../../repositories/tag_repository.dart';

class DeleteTagUseCase {
  final ITagRepository _repository;

  DeleteTagUseCase(this._repository);

  Future<void> call(int id) async {
    return _repository.deleteTag(id);
  }
}
