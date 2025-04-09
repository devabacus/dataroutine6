import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/domain/repositories/category_repository.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/create.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_category_use_case_test.mocks.dart';

@GenerateMocks([ICategoryRepository])
void main() {
  late CreateCategoryUseCase createCategoryUseCase;
  late MockICategoryRepository mockICategoryRepository;

  setUp(() {
    mockICategoryRepository = MockICategoryRepository();
    createCategoryUseCase = CreateCategoryUseCase(mockICategoryRepository);
  });

  test('должна быть создана новая категория с id 1', () async {
    final expectedId = 1;
    final categoryEntity = CategoryEntity(id: -1, title: 'Test Category');

    when(
      mockICategoryRepository.createCategory(categoryEntity),
    ).thenAnswer((_) async => 1);

    final result = await createCategoryUseCase(categoryEntity);

    verify(mockICategoryRepository.createCategory(categoryEntity)).called(1);
    expect(result, expectedId);
  });
}
