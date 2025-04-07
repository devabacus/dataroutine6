import 'package:dataroutine6/features/tasks/data/models/extensions/tag_models_extension.dart';
import 'package:dataroutine6/features/tasks/domain/entities/extensions/tag_entity_extension.dart';

import '../../domain/entities/tag/tag.dart';
import '../../domain/repositories/tag_repository.dart';
import '../datasources/local/interface/tag_local_datasource_service.dart';

class TagRepositoryImpl implements ITagRepository {
  final ITagLocalDataSource _localDataSource;

  TagRepositoryImpl(this._localDataSource);
  // ---------auto generated------------------//
  @override
  Future<List<TagEntity>> getTag() async {
    final tagModels = await _localDataSource.getTag();
    return tagModels.toEntities();
  }

  @override
  Future<TagEntity> getTagById(int id) async {
    final model = await _localDataSource.getTagById(id);
    return model.toEntity();
  }

  @override
  Future<int> createTag(TagEntity tag) {
    return _localDataSource.createTag(tag.toModel());
  }

  @override
  Future<void> deleteTag(int id) async {
    _localDataSource.deleteTag(id);
  }

  @override
  Future<void> updateTag(TagEntity tag) async {
    _localDataSource.updateTag(tag.toModel());
  }

  // ---------auto generated------------------//
  //custom methods
}
