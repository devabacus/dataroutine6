
import '../../../../../../core/database/local/database.dart';
import '../../local/dao/tag_dao.dart';
import '../../../../data/models/tag_model.dart';
import 'package:drift/drift.dart';

class TagLocalDataSource {
  final TagDao _tagDao;

  TagLocalDataSource(AppDatabase db) : _tagDao = TagDao(db);

  Future<List<TagModel>> getTag() async {
    final tag = await _tagDao.getTag();
    return tag
        .map(
          (tag) => TagModel(id: tag.id, title: tag.title),
        )
        .toList();
  }

  Future<TagModel> getTagById(int id) async {
    final tag = await _tagDao.getTagById(id);
    return TagModel(id: tag.id, title: tag.title);
  }

  Future<int> createTag(TagModel tag) {
    return _tagDao.createTag(
      TagTableCompanion.insert(title: tag.title),
    );
  }

  Future<void> updateTag(TagModel tag) {
    return _tagDao.updateTag(
      TagTableCompanion(id: Value(tag.id), title: Value(tag.title)),
    );
  }

  Future<void> deleteTag(int id) async {
      _tagDao.deleteTag(id);
    }

}
