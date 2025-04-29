import '../../../models/category/category_model.dart';

abstract class ICategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel?> getCategoryById(int id);
  Future<String> createCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(int id);
  
  // Методы синхронизации
  Future<void> syncToRemote(List<CategoryModel> categories);
  Future<List<CategoryModel>> getUpdatedSince(DateTime lastSyncTime);
  
  // Метод для прослушивания изменений
  Stream<List<CategoryModel>> watchCategories();
}