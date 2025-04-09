// test/tasks/domain/usecases/category/get_category_by_id_use_case_test.dart

import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/domain/repositories/category_repository.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/get_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_category_by_id_use_case_test.mocks.dart';

@GenerateMocks([ICategoryRepository])
void main() {
  late GetCategoryByIdUseCase getCategoryByIdUseCase;
  late MockICategoryRepository mockICategoryRepository;

  setUp(() {
    mockICategoryRepository = MockICategoryRepository();
    getCategoryByIdUseCase = GetCategoryByIdUseCase(mockICategoryRepository);
  });

  test('должен вернуть категорию по id из репозитория', () async {
    // Arrange
    const categoryId = 1;
    final category = CategoryEntity(id: categoryId, title: 'Test Category');
    
    when(
      mockICategoryRepository.getCategoryById(categoryId),
    ).thenAnswer((_) async => category);

    // Act
    final result = await getCategoryByIdUseCase(categoryId);

    // Assert
    verify(mockICategoryRepository.getCategoryById(categoryId)).called(1);
    expect(result, category);
    expect(result?.id, categoryId);
    expect(result?.title, 'Test Category');
  });

  test('должен выбросить исключение если категория не найдена', () async {
    // Arrange
    const categoryId = 999;
    
    when(
      mockICategoryRepository.getCategoryById(categoryId),
    ).thenThrow(StateError('Category not found'));

    // Act & Assert
    expect(
      () => getCategoryByIdUseCase(categoryId),
      throwsA(isA<StateError>()),
    );
    verify(mockICategoryRepository.getCategoryById(categoryId)).called(1);
  });
}