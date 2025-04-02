// lib/features/tasks/presentation/pages/view_category_page.dart

import 'package:dataroutine6/features/tasks/presentation/common_widgets/entity_list_page.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final tStyle = TextStyle(fontSize: 15);

class ViewCategoryPage extends ConsumerWidget {
  final String isFromTask;

  const ViewCategoryPage({this.isFromTask = "", super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catContr = ref.read(categoriesProvider.notifier);
    final categories = ref.watch(categoriesProvider);
    final selectedTask = ref.read(selectedTaskProvider.notifier);

    return EntityListPage(
      config: EntityListConfig(
        title: "Категории",
        addButtonText: "Добавить категорию",
        addRouteName: TasksRoutes.addCategory,
        editRouteName: TasksRoutes.editCategory,
        dataProvider: categories,
        onItemTap: (category) {
          if (isFromTask == "1") {
            final task = ref.read(selectedTaskProvider);

            if (task != null) {
              selectedTask.setTask(task.copyWith(categoryId: category.id));
            }

            context.goNamed(TasksRoutes.editTask);
          } else {
            ref.read(categorySelectedProvider.notifier).setCategory(category);

            context.goNamed(TasksRoutes.editCategory);
          }
        },
        itemBuilder:
            (context, category, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(category.title, style: tStyle)],
            ),

        onItemDelete: (category) {
          catContr.deleteCategory(category.id);
        },
      ),
    );
  }
}
