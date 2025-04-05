
import '../../repositories/tag_repository.dart';
import '../../entities/tag/tag.dart';

class GetTagByIdUseCase {
  final TagRepository _repository;

  GetTagByIdUseCase(this._repository);

  Future<TagEntity?> call(int id) {
    return _repository.getTagById(id);
  }
}
