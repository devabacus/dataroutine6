import 'package:dataroutine6/core/database/local/interface/database_service.dart';
import 'package:dataroutine6/features/tasks/data/models/extensions/category_models_extension.dart';
import 'package:dataroutine6/features/tasks/data/models/extensions/category_table_extensions.dart';

import '../../../models/category/category_model.dart';
import '../../local/dao/category_dao.dart';
import '../interface/category_local_datasource.dart';

class CategoryLocalDataSource implements ICategoryLocalDataSource {
  final CategoryDao _categoryDao;

  CategoryLocalDataSource(IDatabaseService databaseService)
    : _categoryDao = CategoryDao(databaseService);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categories = await _categoryDao.getCategories();
    return categories.toModels();
  }

  @override
  Future<CategoryModel> getCategoryById(int id) async {
    final category = await _categoryDao.getCategoryById(id);
    return category.toModel();
  }

  @override
  Future<int> createCategory(CategoryModel category) {
    return _categoryDao.createCategory(category.toCompanion());
  }

  @override
  Future<void> updateCategory(CategoryModel category) {
    return _categoryDao.updateCategory(category.toCompanionWithId());
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _categoryDao.deleteCategory(id);
  }
}
