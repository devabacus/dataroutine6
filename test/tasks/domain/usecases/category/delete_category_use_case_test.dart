// test/tasks/domain/usecases/category/delete_category_use_case_test.dart

import 'package:dataroutine6/features/tasks/domain/repositories/category_repository.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/delete.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_category_use_case_test.mocks.dart';

@GenerateMocks([ICategoryRepository])
void main() {
  late DeleteCategoryUseCase deleteCategoryUseCase;
  late MockICategoryRepository mockICategoryRepository;

  setUp(() {
    mockICategoryRepository = MockICategoryRepository();
    deleteCategoryUseCase = DeleteCategoryUseCase(mockICategoryRepository);
  });

  test('должен вызвать метод удаления в репозитории с правильным id', () async {
    // Arrange
    const categoryId = 1;
    
    when(
      mockICategoryRepository.deleteCategory(categoryId),
    ).thenAnswer((_) async => {});

    // Act
    await deleteCategoryUseCase(categoryId);

    // Assert
    verify(mockICategoryRepository.deleteCategory(categoryId)).called(1);
  });
}