import '../entities/category/category.dart';

abstract class ICategoryRepository {
  Future<List<CategoryEntity>> getCategories();
  Stream<List<CategoryEntity>> watchCategories();
  Future<CategoryEntity> getCategoryById(int id);
  Future<int> createCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(int id);
}
