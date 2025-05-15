import 'package:uuid/uuid.dart';

import '../../../../../../core/database/local/interface/database_service.dart';
import 'package:drift/drift.dart';
import '../../../../../../../core/database/local/database.dart';
import '../tables/category_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [CategoryTable])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  
  final Uuid _uuid = Uuid();

  CategoryDao(IDatabaseService databaseService): super(databaseService.database);

  Future<List<CategoryTableData>> getCategories() => select(categoryTable).get();
  
  Stream<List<CategoryTableData>> watchCategories() => select(categoryTable).watch();

  Future<CategoryTableData> getCategoryById(String id) => 
      (select(categoryTable)..where((t) => t.id.equals(id)))
      .getSingle();
  
Future<String> createCategory(CategoryTableCompanion companion) async {
  String idToInsert;
  CategoryTableCompanion companionForInsert;

  if (companion.id.present && companion.id.value.isNotEmpty) {
    idToInsert = companion.id.value;
    companionForInsert = companion;
  } else {
    idToInsert = _uuid.v7(); 
    companionForInsert = companion.copyWith(id: Value(idToInsert));
  }
  
  await into(categoryTable).insert(companionForInsert);
  return idToInsert;
}


  Future<void> updateCategory(CategoryTableCompanion category) =>
      update(categoryTable).replace(category);
  
  Future<void> deleteCategory(String id) =>
      (delete(categoryTable)..where((t) => t.id.equals(id))).go();
}

