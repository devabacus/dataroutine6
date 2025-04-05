
import '../../repositories/tag_repository.dart';
import '../../entities/tag/tag.dart';

class CreateTagUseCase {
  final TagRepository _repository;
  
  CreateTagUseCase(this._repository);
  
  Future<int> call(TagEntity tag) {
    return _repository.createTag(tag);
  }
}
