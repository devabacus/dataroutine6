

import 'package:dataroutine6/core/database/local/database.dart';
import 'package:dataroutine6/features/tasks/data/models/category_model.dart';

extension CategoryTableDataExtensions on CategoryTableData {
  CategoryModel toModel() => CategoryModel(id: id, title: title);

}

extension CategoryTableDataListExtensions on List<CategoryTableData> {
  List<CategoryModel> toModels() => map((data)=> data.toModel()).toList();
}

