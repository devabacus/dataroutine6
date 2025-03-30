import 'package:dataroutine6/core/database/local/database.dart';
import 'package:dataroutine6/features/tasks/data/models/category_model.dart';
import 'package:dataroutine6/features/tasks/domain/entities/category.dart';
import 'package:drift/drift.dart';

extension CategoryModelExtension on CategoryModel {
  CategoryEntity toEntity() => CategoryEntity(id: id, title: title);
  
  CategoryTableCompanion toCompanion() => CategoryTableCompanion.insert(
    title: title,
  );
  
  CategoryTableCompanion toCompanionWithId() => CategoryTableCompanion(
    id: Value(id),
    title: Value(title),
  );
}

extension CategoryModelListExtension on List<CategoryModel> {
  List<CategoryEntity> toEntities() => map((model) => model.toEntity()).toList();
}




