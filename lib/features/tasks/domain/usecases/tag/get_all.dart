import '../../repositories/tag_repository.dart';
import '../../entities/tag/tag.dart';

class GetTagUseCase {
  final ITagRepository _repository;

  GetTagUseCase(this._repository);

  Future<List<TagEntity>> call() {
    return _repository.getTag();
  }
}
