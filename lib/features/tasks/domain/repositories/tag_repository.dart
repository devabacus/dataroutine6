import '../entities/tag/tag.dart';

abstract class ITagRepository {
  Future<List<TagEntity>> getTag();
  Future<TagEntity> getTagById(int id);
  Future<int> createTag(TagEntity tag);
  Future<void> updateTag(TagEntity tag);
  Future<void> deleteTag(int id);
}
