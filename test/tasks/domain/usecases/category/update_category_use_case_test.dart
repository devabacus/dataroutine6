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

  test('should call correct update method', () async {
    final category = CategoryEntity(id: 1, title: 'title 1');
    
    when(
      mockICategoryRepository.updateCategory(category),
    ).thenAnswer((_) async => {});

    await updateCategoryUseCase(category);

    verify(mockICategoryRepository.updateCategory(category)).called(1);
  });
}