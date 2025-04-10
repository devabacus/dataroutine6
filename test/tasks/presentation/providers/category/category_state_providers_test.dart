// test/tasks/presentation/providers/category/category_state_providers_test.dart
import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/domain/providers/category/category_usecase_providers.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/create.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/delete.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/get_all.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/update.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'category_state_providers_test.mocks.dart';

@GenerateMocks([
  GetCategoriesUseCase,
  CreateCategoryUseCase,
  UpdateCategoryUseCase,
  DeleteCategoryUseCase,
])
void main() {
  late ProviderContainer container;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockCreateCategoryUseCase mockCreateCategoryUseCase;
  late MockUpdateCategoryUseCase mockUpdateCategoryUseCase;
  late MockDeleteCategoryUseCase mockDeleteCategoryUseCase;

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockCreateCategoryUseCase = MockCreateCategoryUseCase();
    mockUpdateCategoryUseCase = MockUpdateCategoryUseCase();
    mockDeleteCategoryUseCase = MockDeleteCategoryUseCase();

    container = ProviderContainer(
      overrides: [
        getCategoriesUseCaseProvider.overrideWithValue(mockGetCategoriesUseCase),
        createCategoryUseCaseProvider.overrideWithValue(mockCreateCategoryUseCase),
        updateCategoryUseCaseProvider.overrideWithValue(mockUpdateCategoryUseCase),
        deleteCategoryUseCaseProvider.overrideWithValue(mockDeleteCategoryUseCase),
      ],    
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('categoriesProvider', () {
    final categories = [
      CategoryEntity(id: 1, title: 'Категория 1'),
      CategoryEntity(id: 2, title: 'Категория 2'),
    ];

    test('изначально должен возвращать AsyncLoading и затем загрузить категории', () async {
      // Настраиваем мок перед первым чтением состояния
      when(mockGetCategoriesUseCase()).thenAnswer((_) async => categories);

      // Первоначальное состояние должно быть AsyncLoading
      expect(container.read(categoriesProvider), isA<AsyncLoading<List<CategoryEntity>>>());

      // Ждем завершения асинхронной операции
      await container.read(categoriesProvider.future);

      // Проверяем что данные загрузились
      final loadedState = container.read(categoriesProvider);
      expect(loadedState.value, categories);
      verify(mockGetCategoriesUseCase()).called(1);
    });

    test('addCategory должен добавить новую категорию', () async {
      // Настройка мока для загрузки
      when(mockGetCategoriesUseCase()).thenAnswer((_) async => categories);
      
      // Дожидаемся загрузки начальных данных
      await container.read(categoriesProvider.future);
      
      // Настройка мока для создания категории
      final newCategory = CategoryEntity(id: -1, title: 'Новая категория');
      when(mockCreateCategoryUseCase(newCategory)).thenAnswer((_) async => 3);
      
      // Настройка мока для повторной загрузки данных после создания
      final updatedCategories = [...categories, CategoryEntity(id: 3, title: 'Новая категория')];
      when(mockGetCategoriesUseCase()).thenAnswer((_) async => updatedCategories);
      
      // Действие - добавление категории
      await container.read(categoriesProvider.notifier).addCategory(newCategory);
      
      // Проверка
      verify(mockCreateCategoryUseCase(newCategory)).called(1);
      verify(mockGetCategoriesUseCase()).called(2); // Вызван дважды
      
      // Проверяем обновленное состояние
      expect(container.read(categoriesProvider).value, updatedCategories);
    });

    test('updateCategory должен обновить категорию', () async {
      // Настройка мока для загрузки
      when(mockGetCategoriesUseCase()).thenAnswer((_) async => categories);
      
      // Дожидаемся загрузки начальных данных
      await container.read(categoriesProvider.future);
      
      // Настройка мока для обновления категории
      final updatedCategory = CategoryEntity(id: 1, title: 'Обновленная категория');
      when(mockUpdateCategoryUseCase(updatedCategory)).thenAnswer((_) async {});
      
      // Настройка мока для повторной загрузки данных после обновления
      final updatedCategories = [
        updatedCategory,
        categories[1],
      ];
      when(mockGetCategoriesUseCase()).thenAnswer((_) async => updatedCategories);
      
      // Действие - обновление категории
      await container.read(categoriesProvider.notifier).updateCategory(updatedCategory);
      
      // Проверка
      verify(mockUpdateCategoryUseCase(updatedCategory)).called(1);
      verify(mockGetCategoriesUseCase()).called(2);
      
      // Проверяем обновленное состояние
      expect(container.read(categoriesProvider).value, updatedCategories);
    });

    test('deleteCategory должен удалить категорию', () async {
      // Настройка мока для загрузки
      when(mockGetCategoriesUseCase()).thenAnswer((_) async => categories);
      
      // Дожидаемся загрузки начальных данных
      await container.read(categoriesProvider.future);
      
      // Настройка мока для удаления категории
      const categoryIdToDelete = 1;
      when(mockDeleteCategoryUseCase(categoryIdToDelete)).thenAnswer((_) async {});
      
      // Настройка мока для повторной загрузки данных после удаления
      final updatedCategories = [categories[1]];
      when(mockGetCategoriesUseCase()).thenAnswer((_) async => updatedCategories);
      
      // Действие - удаление категории
      await container.read(categoriesProvider.notifier).deleteCategory(categoryIdToDelete);
      
      // Проверка
      verify(mockDeleteCategoryUseCase(categoryIdToDelete)).called(1);
      verify(mockGetCategoriesUseCase()).called(2);
      
      // Проверяем обновленное состояние
      expect(container.read(categoriesProvider).value, updatedCategories);
    });
  });
}