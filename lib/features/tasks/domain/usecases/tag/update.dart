import '../../entities/tag/tag.dart';
import '../../repositories/tag_repository.dart';

class UpdateTagUseCase {
  final ITagRepository _repository;

  UpdateTagUseCase(this._repository);

  Future<void> call(TagEntity tag) async {
    return _repository.updateTag(tag);
  }
}
