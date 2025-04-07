
import 'package:dataroutine6/core/database/local/interface/database_service.dart';
import 'package:drift/drift.dart';
import '../../../../../../../core/database/local/database.dart';
import '../tables/tag_table.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [TagTable])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  
  TagDao(IDatabaseService databaseService) : super(databaseService.database);

  Future<List<TagTableData>> getTag() => select(tagTable).get();
  
  Future<TagTableData> getTagById(int id) => 
      (select(tagTable)..where((t) => t.id.equals(id)))
      .getSingle();
  
  Future<int> createTag(TagTableCompanion tag) =>
      into(tagTable).insert(tag);
  
  Future<void> updateTag(TagTableCompanion tag) =>
      update(tagTable).replace(tag);
  
  Future<void> deleteTag(int id) =>
      (delete(tagTable)..where((t) => t.id.equals(id))).go();
}

