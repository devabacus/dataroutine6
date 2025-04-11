// test/tasks/presentation/providers/category/category_get_by_id_provider_test.dart
import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/domain/providers/category/category_usecase_providers.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/get_by_id.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_by_id_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'category_get_by_id_provider_test.mocks.dart';

// Создаем тестовый класс, который наследуется от _$Categories (базовый класс для Categories)
class TestCategories extends Categories {
  @override
  Future<List<CategoryEntity>> build() async {
    // Возвращаем пустой список категорий для тестов
    return [];
  }
}

@GenerateMocks([GetCategoryByIdUseCase])
void main() {
  // Инициализируем Flutter тесты
  WidgetsFlutterBinding.ensureInitialized();
  
  late ProviderContainer container;
  late MockGetCategoryByIdUseCase mockGetCategoryByIdUseCase;

  setUp(() {
    mockGetCategoryByIdUseCase = MockGetCategoryByIdUseCase();
    container = ProviderContainer(
      overrides: [
        // Переопределяем провайдер usecase
        getCategoryByIdUseCaseProvider.overrideWithValue(mockGetCategoryByIdUseCase),
        // Переопределяем провайдер категорий, используя тестовую реализацию
        categoriesProvider.overrideWith(() => TestCategories()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('getCategoryByIdProvider', () {
    final testCategory = CategoryEntity(id: 1, title: 'Test Category');

    test('должен вернуть категорию от usecase', () async {
      // Настраиваем usecase для получения категории
      when(mockGetCategoryByIdUseCase(1)).thenAnswer((_) async => testCategory);

      // Получаем результат из провайдера
      final result = await container.read(getCategoryByIdProvider(1).future);
      
      // Проверяем результат
      expect(result.id, 1);
      expect(result.title, 'Test Category');
      
      // Проверяем, что usecase был вызван
      verify(mockGetCategoryByIdUseCase(1)).called(1);
    });

    test('должен выбросить исключение, если категория не найдена', () async {
      // Настраиваем usecase для получения null
      when(mockGetCategoryByIdUseCase(999)).thenAnswer((_) async => null);

      // Ожидаем исключение при поиске несуществующей категории
      expect(
        () => container.read(getCategoryByIdProvider(999).future),
        throwsA(isA<Exception>()),
      );
    });
  });
}