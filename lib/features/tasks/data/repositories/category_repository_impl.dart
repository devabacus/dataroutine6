
import '../../data/datasources/local/sources/category_local_data_source.dart';

import '../../domain/repositories/category_repository.dart';
import '../../domain/entities/category.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource _localDataSource;

  CategoryRepositoryImpl(this._localDataSource);
// ---------auto generated------------------//
  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categoryModels = await _localDataSource.getCategories();
    return categoryModels
        .map((model) => CategoryEntity(id: model.id, title: model.title))
        .toList();
  }

  @override
  Future<CategoryEntity> getCategoryById(int id) async {
    final model = await _localDataSource.getCategoryById(id);
    return CategoryEntity(id: model.id, title: model.title);
  }

  @override
  Future<int> createCategory(CategoryEntity category) {
    return _localDataSource.createCategory(
      CategoryModel(id: category.id, title: category.title),
    );
  }

  @override
  Future<void> deleteCategory(int id) async {
    _localDataSource.deleteCategory(id);
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    _localDataSource.updateCategory(
      CategoryModel(id: category.id, title: category.title),
    );
  }
    // ---------auto generated------------------//
    //custom methods
}
