import 'package:dataroutine6/features/tasks/domain/entities/category.dart';
import 'package:dataroutine6/features/tasks/domain/entities/task.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mlogger/mlogger.dart';
import 'package:ui_kit/ui_kit.dart';
// import '../providers/tasks_navigation_provider.dart';

final tStyle = TextStyle(fontSize: 15);

class ViewCategoryPage extends ConsumerWidget {
  final String isFromTask;

  const ViewCategoryPage({this.isFromTask = "", super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final tasksNavService = ref.read(tasksNavigationServiceProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedTask = ref.read(selectedTaskProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Категории", style: TextStyle(fontSize: 20))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: categories.when(
                data: (categories) {
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final id = categories[index].id;
                      final title = categories[index].title;

                      return ListTile(
                        title: Text(title, style: tStyle),
                        trailing: Text(id.toString()),
                        onTap: () {
                          // справочник
                          if (isFromTask == "1") {
                            final task = ref.read(selectedTaskProvider);
                            if (task != null) {
                              selectedTask.setTask(
                                task.copyWith(categoryId: categories[index].id),
                              );
                            }
                            context.goNamed(TasksRoutes.editTask);
                          } else {
                            // просмотр,редактирования
                            ref
                                .read(categorySelectedProvider.notifier)
                                .setCategory(
                                  CategoryEntity(id: id, title: title),
                                );

                            context.goNamed(TasksRoutes.editCategory);
                          }
                        },
                      );
                    },
                  );
                },
                error: (_, __) => Text("Error"),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.goNamed(TasksRoutes.addCategory),
              child: Text("Добавить категорию"),
            ),
            AppGap.l(),
          ],
        ),
      ),
    );
  }
}
