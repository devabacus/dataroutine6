import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_selected_provider.g.dart';

@riverpod
class CategorySelected extends _$CategorySelected {
  @override
  CategoryEntity? build() {
    ref.keepAlive();

    return null;
  }

  void setCategory(CategoryEntity category) {
    state = category;
  }
}
