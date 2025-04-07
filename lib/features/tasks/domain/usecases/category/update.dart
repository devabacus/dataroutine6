import '../../entities/category/category.dart';
import '../../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final ICategoryRepository _repository;

  UpdateCategoryUseCase(this._repository);

  Future<void> call(CategoryEntity category) async {
    return _repository.updateCategory(category);
  }
}
