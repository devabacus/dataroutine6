
import '../../repositories/tag_repository.dart';
import '../../entities/tag.dart';

class GetTagUseCase {
  final TagRepository _repository;

  GetTagUseCase(this._repository);

  Future<List<TagEntity>> call() {
    return _repository.getTag();
  }
}
