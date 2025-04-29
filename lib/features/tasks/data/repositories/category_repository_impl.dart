import '../../domain/entities/category/category.dart';
import '../../domain/entities/extensions/category_entity_extension.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/local/interfaces/category_local_datasource_service.dart';
import '../models/extensions/category_models_extension.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final ICategoryLocalDataSource _localDataSource;
  

  CategoryRepositoryImpl(this._localDataSource);

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
    return _localDataSource.createCategory(category.toModel());
  }

  @override
  Future<void> deleteCategory(int id) async {
    _localDataSource.deleteCategory(id);
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    _localDataSource.updateCategory(category.toModel());
  }
}
