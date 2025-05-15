
import 'package:dataroutine6/core/database/local/interface/database_service.dart';
import 'package:dataroutine6/features/tasks/data/datasources/local/interfaces/tag_local_datasource_service.dart';
import 'package:dataroutine6/features/tasks/data/models/extensions/tag_models_extension.dart';
import 'package:dataroutine6/features/tasks/data/datasources/local/tables/extensions/tag_table_extension.dart';

import '../../../models/tag/tag_model.dart';
import '../../local/dao/tag_dao.dart';

class TagLocalDataSource implements ITagLocalDataSource{
  final TagDao _tagDao;

  TagLocalDataSource(IDatabaseService databaseService) : _tagDao = TagDao(databaseService);
      
  @override
  Future<List<TagModel>> getTag() async {
    final tag = await _tagDao.getTag();
    return tag.toModels();
  }

  @override
  Future<TagModel> getTagById(String id) async {
    final tag = await _tagDao.getTagById(id);
    return tag.toModel();
  }

  @override
  Future<String> createTag(TagModel tag) {
    return _tagDao.createTag(tag.toCompanion());
  }

  @override
  Future<void> updateTag(TagModel tag) {
    return _tagDao.updateTag(tag.toCompanionWithId());
  }

  @override
  Future<void> deleteTag(String id) async {
      _tagDao.deleteTag(id);
    }

}
