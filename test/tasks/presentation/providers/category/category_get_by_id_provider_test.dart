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
  });

  tearDown(() {
    container.dispose();
  });

  group('getCategoryByIdProvider', () {
    final testCategory = CategoryEntity(id: 1, title: 'Test Category');
    
    test('должен получить категорию через usecase, если нет в кэше', () async {
      // Настраиваем mock для usecase
      when(mockGetCategoryByIdUseCase(1)).thenAnswer((_) async => testCategory);
      
      // Создаем контейнер с переопределенным провайдером
      container = ProviderContainer(
        overrides: [
          getCategoryByIdUseCaseProvider.overrideWithValue(mockGetCategoryByIdUseCase),
        ],
      );

      // Вызываем провайдер
      final result = await container.read(getCategoryByIdProvider(1).future);
      
      // Проверяем результат
      expect(result.id, 1);
      expect(result.title, 'Test Category');
      
      // Проверяем, что usecase был вызван
      verify(mockGetCategoryByIdUseCase(1)).called(1);
    });

    test('должен выбросить исключение, если категория не найдена', () async {
      // Настраиваем usecase, чтобы он возвращал null (категория не найдена)
      when(mockGetCategoryByIdUseCase(999)).thenAnswer((_) async => null);

      // Создаем контейнер с переопределенным провайдером
      container = ProviderContainer(
        overrides: [
          getCategoryByIdUseCaseProvider.overrideWithValue(mockGetCategoryByIdUseCase),
        ],
      );

      // Проверяем, что провайдер выбрасывает исключение
      expect(
        () => container.read(getCategoryByIdProvider(999).future),
        throwsA(isA<Exception>()),
      );
      
      // Проверяем, что usecase был вызван
      verify(mockGetCategoryByIdUseCase(999)).called(1);
    });
  });
}