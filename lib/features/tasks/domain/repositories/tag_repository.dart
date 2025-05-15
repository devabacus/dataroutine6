import '../entities/tag/tag.dart';

abstract class ITagRepository {
  Future<List<TagEntity>> getTag();
  Future<TagEntity> getTagById(String id);
  Future<String> createTag(TagEntity tag);
  Future<void> updateTag(TagEntity tag);
  Future<void> deleteTag(String id);
}
