
import '../../../models/tag/tag_model.dart';

abstract class ITagLocalDataSource {
  Future<List<TagModel>> getTag();
  Future<TagModel> getTagById(int id);
  Future<int> createTag(TagModel tag);
  Future<void> updateTag(TagModel tag);
  Future<void> deleteTag(int id);
}

