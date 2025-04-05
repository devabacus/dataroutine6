import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/domain/providers/category/category_usecase_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:mlogger/mlogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'category_by_id_provider.g.dart';

@riverpod
FutureOr<CategoryEntity> getCategoryById(Ref ref, int id) async {
  final categoriesAsyncValue = ref.read(categoriesProvider);

  if (categoriesAsyncValue is AsyncData<List<CategoryEntity>>) {
    try {
      return categoriesAsyncValue.value.firstWhere((cat) => cat.id == id);
    } catch (e) {
      log.debug("Не нашли в кэше делаем запрос к базе, error: $e");
    }
  }
  final category = await ref.read(getCategoryByIdUseCaseProvider)(id);
  if (category == null) {
    throw Exception('Категория с $id не найдена');
  }
  return category;
}
