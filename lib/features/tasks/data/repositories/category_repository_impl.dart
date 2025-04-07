
import 'package:dataroutine6/features/tasks/data/models/extensions/category_models_extension.dart';
import 'package:dataroutine6/features/tasks/domain/entities/extensions/category_entity_extension.dart';

import '../../domain/entities/category/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/local/interface/category_local_datasource.dart';
import '../models/category/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ICategoryLocalDataSource _localDataSource;

  CategoryRepositoryImpl(this._localDataSource);
// ---------auto generated------------------//
  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categoryModels = await _localDataSource.getCategories();
    return categoryModels.toEntities();
  }

  @override
  Future<CategoryEntity> getCategoryById(int id) async {
    final model = await _localDataSource.getCategoryById(id);
    return model.toEntity();
  }

  @override
  Future<int> createCategory(CategoryEntity category) {
    return _localDataSource.createCategory(category.toModel()
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
}
