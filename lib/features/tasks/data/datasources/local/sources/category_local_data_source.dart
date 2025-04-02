
import 'package:dataroutine6/features/tasks/data/models/extensions/category_models_extension.dart';
import 'package:dataroutine6/features/tasks/data/models/extensions/category_table_extensions.dart';

import '../../../../../../core/database/local/database.dart';
import '../../../../data/models/category_model.dart';
import '../../local/dao/category_dao.dart';

class CategoryLocalDataSource {
  final CategoryDao _categoryDao;

  CategoryLocalDataSource(AppDatabase db) : _categoryDao = CategoryDao(db);


    Future<List<CategoryModel>> getCategories() async {
    final categories = await _categoryDao.getCategories();
    return categories.toModels();
  }

  Future<CategoryModel> getCategoryById(int id) async {
    final category = await _categoryDao.getCategoryById(id);
    return category.toModel();
  }

  Future<int> createCategory(CategoryModel category) {
    return _categoryDao.createCategory(category.toCompanion());
  }

  Future<void> updateCategory(CategoryModel category) {
    return _categoryDao.updateCategory(category.toCompanionWithId());
  }

  Future<void> deleteCategory(int id) async {
      await _categoryDao.deleteCategory(id);
    }

}
