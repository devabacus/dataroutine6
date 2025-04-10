// test/tasks/presentation/providers/category/category_selected_provider_test.dart
import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_selected_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('categorySelectedProvider', () {
    test('изначально должен возвращать null', () {
      final selectedCategory = container.read(categorySelectedProvider);
      expect(selectedCategory, isNull);
    });

    test('должен обновлять значение при вызове setCategory', () {
      // Исходное значение
      expect(container.read(categorySelectedProvider), isNull);

      // Создаем тестовую категорию
      final category = CategoryEntity(id: 1, title: 'Тестовая категория');
      
      // Устанавливаем категорию
      container.read(categorySelectedProvider.notifier).setCategory(category);
      
      // Проверяем что значение обновилось
      final selectedCategory = container.read(categorySelectedProvider);
      expect(selectedCategory, category);
      expect(selectedCategory?.id, 1);
      expect(selectedCategory?.title, 'Тестовая категория');
    });

    test('должен заменять предыдущее значение при повторном вызове setCategory', () {
      // Устанавливаем первую категорию
      final category1 = CategoryEntity(id: 1, title: 'Категория 1');
      container.read(categorySelectedProvider.notifier).setCategory(category1);
      expect(container.read(categorySelectedProvider), category1);
      
      // Устанавливаем вторую категорию
      final category2 = CategoryEntity(id: 2, title: 'Категория 2');
      container.read(categorySelectedProvider.notifier).setCategory(category2);
      
      // Проверяем что значение обновилось на вторую категорию
      final selectedCategory = container.read(categorySelectedProvider);
      expect(selectedCategory, category2);
      expect(selectedCategory?.id, 2);
      expect(selectedCategory?.title, 'Категория 2');
    });
  });
}