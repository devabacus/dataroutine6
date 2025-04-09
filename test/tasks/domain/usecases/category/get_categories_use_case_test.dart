// test/tasks/domain/usecases/category/get_categories_use_case_test.dart

import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/domain/repositories/category_repository.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/get_all.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_categories_use_case_test.mocks.dart';

@GenerateMocks([ICategoryRepository])
void main() {
  late GetCategoriesUseCase getCategoriesUseCase;
  late MockICategoryRepository mockICategoryRepository;

  setUp(() {
    mockICategoryRepository = MockICategoryRepository();
    getCategoriesUseCase = GetCategoriesUseCase(mockICategoryRepository);
  });

  test('должен вернуть список категорий из репозитория', () async {
    // Arrange
    final categories = [
      CategoryEntity(id: 1, title: 'Category 1'),
      CategoryEntity(id: 2, title: 'Category 2'),
    ];
    
    when(
      mockICategoryRepository.getCategories(),
    ).thenAnswer((_) async => categories);

    // Act
    final result = await getCategoriesUseCase();

    // Assert
    verify(mockICategoryRepository.getCategories()).called(1);
    expect(result, categories);
    expect(result.length, 2);
  });
}