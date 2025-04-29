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

  test('should return correct item by id', () async {
    const categoryId = 1;
    final category = CategoryEntity(id: categoryId, title: 'title 1');
    
    when(
      mockICategoryRepository.getCategoryById(categoryId),
    ).thenAnswer((_) async => category);

    final result = await getCategoryByIdUseCase(categoryId);

    verify(mockICategoryRepository.getCategoryById(categoryId)).called(1);
    expect(result, category);
    expect(result?.id, categoryId);
    expect(result?.title, 'title 1');
  });

  test('shoul throw exception', () async {
    const categoryId = 999;
    
    when(
      mockICategoryRepository.getCategoryById(categoryId),
    ).thenThrow(StateError('Category not found'));

    expect(
      () => getCategoryByIdUseCase(categoryId),
      throwsA(isA<StateError>()),
    );
    verify(mockICategoryRepository.getCategoryById(categoryId)).called(1);
  });
}