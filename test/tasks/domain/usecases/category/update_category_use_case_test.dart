// test/tasks/domain/usecases/category/update_category_use_case_test.dart

import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/domain/repositories/category_repository.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/update.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_category_use_case_test.mocks.dart';

@GenerateMocks([ICategoryRepository])
void main() {
  late UpdateCategoryUseCase updateCategoryUseCase;
  late MockICategoryRepository mockICategoryRepository;

  setUp(() {
    mockICategoryRepository = MockICategoryRepository();
    updateCategoryUseCase = UpdateCategoryUseCase(mockICategoryRepository);
  });

  test('должен вызвать метод обновления в репозитории с правильной категорией', () async {
    // Arrange
    final category = CategoryEntity(id: 1, title: 'Updated Category');
    
    when(
      mockICategoryRepository.updateCategory(category),
    ).thenAnswer((_) async => {});

    // Act
    await updateCategoryUseCase(category);

    // Assert
    verify(mockICategoryRepository.updateCategory(category)).called(1);
  });
}