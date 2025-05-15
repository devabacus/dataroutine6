
import '../../../models/tag/tag_model.dart';

abstract class ITagLocalDataSource {
  Future<List<TagModel>> getTag();
  Future<TagModel> getTagById(String id);
  Future<String> createTag(TagModel tag);
  Future<void> updateTag(TagModel tag);
  Future<void> deleteTag(String id);
}

