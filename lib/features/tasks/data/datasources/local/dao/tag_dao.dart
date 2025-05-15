
import 'package:dataroutine6/core/database/local/interface/database_service.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../../core/database/local/database.dart';
import '../tables/tag_table.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [TagTable])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  
  final Uuid _uuid = Uuid();


  TagDao(IDatabaseService databaseService) : super(databaseService.database);

  Future<List<TagTableData>> getTag() => select(tagTable).get();
  
  Future<TagTableData> getTagById(String id) => 
      (select(tagTable)..where((t) => t.id.equals(id)))
      .getSingle();
  
Future<String> createTag(TagTableCompanion companion) async {
  String idToInsert;
  TagTableCompanion companionForInsert;

  if (companion.id.present && companion.id.value.isNotEmpty) {
    idToInsert = companion.id.value;
    companionForInsert = companion;
  } else {
    idToInsert = _uuid.v7(); 
    companionForInsert = companion.copyWith(id: Value(idToInsert));
  }
  
  await into(tagTable).insert(companionForInsert);
  return idToInsert;
}

  
  Future<void> updateTag(TagTableCompanion tag) =>
      update(tagTable).replace(tag);
  
  Future<void> deleteTag(String id) =>
      (delete(tagTable)..where((t) => t.id.equals(id))).go();
}

