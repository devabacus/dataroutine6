
import '../../data/datasources/local/sources/tag_local_data_source.dart';

import '../../domain/repositories/tag_repository.dart';
import '../../domain/entities/tag.dart';
import '../models/tag_model.dart';

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource _localDataSource;

  TagRepositoryImpl(this._localDataSource);
// ---------auto generated------------------//
  @override
  Future<List<TagEntity>> getTag() async {
    final tagModels = await _localDataSource.getTag();
    return tagModels
        .map((model) => TagEntity(id: model.id, title: model.title))
        .toList();
  }

  @override
  Future<TagEntity> getTagById(int id) async {
    final model = await _localDataSource.getTagById(id);
    return TagEntity(id: model.id, title: model.title);
  }

  @override
  Future<int> createTag(TagEntity tag) {
    return _localDataSource.createTag(
      TagModel(id: tag.id, title: tag.title),
    );
  }

  @override
  Future<void> deleteTag(int id) async {
    _localDataSource.deleteTag(id);
  }

  @override
  Future<void> updateTag(TagEntity tag) async {
    _localDataSource.updateTag(
      TagModel(id: tag.id, title: tag.title),
    );
  }
    // ---------auto generated------------------//
    //custom methods
}
