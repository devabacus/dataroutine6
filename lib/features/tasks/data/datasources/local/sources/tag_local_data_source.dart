
import 'package:dataroutine6/features/tasks/data/models/extensions/tag_models_extension.dart';
import 'package:dataroutine6/features/tasks/data/models/extensions/tag_table_extension.dart';

import '../../../../../../core/database/local/database.dart';
import '../../../models/tag/tag_model.dart';
import '../../local/dao/tag_dao.dart';

class TagLocalDataSource {
  final TagDao _tagDao;

  TagLocalDataSource(AppDatabase db) : _tagDao = TagDao(db);
      
  Future<List<TagModel>> getTag() async {
    final tag = await _tagDao.getTag();
    return tag.toModels();
  }

  Future<TagModel> getTagById(int id) async {
    final tag = await _tagDao.getTagById(id);
    return tag.toModel();
  }

  Future<int> createTag(TagModel tag) {
    return _tagDao.createTag(tag.toCompanion());
  }

  Future<void> updateTag(TagModel tag) {
    return _tagDao.updateTag(tag.toCompanionWithId());
  }

  Future<void> deleteTag(int id) async {
      _tagDao.deleteTag(id);
    }

}
