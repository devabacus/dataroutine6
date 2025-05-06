import 'dart:async'; // <-- Добавить импорт
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/category/category.dart';
import '../../../domain/providers/category/category_usecase_providers.dart';

part 'category_state_providers.g.dart';

@riverpod
class Categories extends _$Categories {
  // --- ИЗМЕНЕННЫЙ МЕТОД build ---
  @override
  Stream<List<CategoryEntity>> build() {
    // Теперь мы СЛУШАЕМ (watch) поток категорий из репозитория (через use case)
    // Riverpod автоматически обработает Stream и преобразует его в AsyncValue
    return ref.watch(watchCategoriesUseCaseProvider)();
    // Старый код: return ref.read(getCategoriesUseCaseProvider)();
  }
  // --- КОНЕЦ ИЗМЕНЕННОГО МЕТОДА ---

  // --- УПРОЩЕННЫЕ МЕТОДЫ add/update/delete ---
  // Теперь не нужно вручную обновлять state, поток сделает это сам!
  Future<void> addCategory(CategoryEntity category) async {
    // Оборачиваем в AsyncValue.guard для обработки возможных ошибок при записи
    state = const AsyncValue.loading(); // Показываем загрузку на время операции
    state = await AsyncValue.guard(() async {
       await ref.read(createCategoryUseCaseProvider)(category);
       // НЕ НУЖНО: return ref.read(getCategoriesUseCaseProvider)();
       // Просто возвращаем текущее значение (если оно есть) или пустой список
       return future; // future - это Future из текущего state Stream'а
    });
  }

  Future<void> updateCategory(CategoryEntity category) async {
     state = const AsyncValue.loading();
     state = await AsyncValue.guard(() async {
        await ref.read(updateCategoryUseCaseProvider)(category);
        // НЕ НУЖНО: return ref.read(getCategoriesUseCaseProvider)();
        return future;
     });
  }

  Future<void> deleteCategory(int id) async {
     state = const AsyncValue.loading();
     state = await AsyncValue.guard(() async {
        await ref.read(deleteCategoryUseCaseProvider)(id);
        // НЕ НУЖНО: return ref.read(getCategoriesUseCaseProvider)();
        return future;
     });
  }
  // --- КОНЕЦ УПРОЩЕННЫХ МЕТОДОВ ---
}
