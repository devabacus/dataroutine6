import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/domain/providers/category/category_usecase_providers.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/get_by_id.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_by_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'category_get_by_id_provider_test.mocks.dart';

@GenerateMocks([GetCategoryByIdUseCase])
void main() {
  late ProviderContainer container;
  late MockGetCategoryByIdUseCase mockGetCategoryByIdUseCase;

  setUp(() {
    mockGetCategoryByIdUseCase = MockGetCategoryByIdUseCase();
    container = ProviderContainer(
      overrides: [
        getCategoryByIdUseCaseProvider.overrideWithValue(
          mockGetCategoryByIdUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('categoryByIdProvider', () {
    test('если категории уже загружены, тогда получаем из них', () async {
      final testCategory = CategoryEntity(id: 1, title: 'Test Cateogory');

      when(
        mockGetCategoryByIdUseCase(1),
      ).thenAnswer((_) async => testCategory);
    });


  });
}
