import 'package:dataroutine6/features/tasks/domain/entities/task.dart';
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
  String isFromTask = '';

  ViewCategoryPage({required this.isFromTask, super.key});

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
                      return ListTile(
                        title: Text(categories[index].title, style: tStyle),
                        trailing: Text(categories[index].id.toString()),
                        onTap: () {
                          if (isFromTask.isNotEmpty) {
                            // selectedTask.setTask(
                              
                            //   categoryId: categories[index].id,
                            // );
                            context.goNamed(TasksRoutes.editTask);
                          } else {
                            final idStr = categories[index].id.toString();

                            context.goNamed(
                              TasksRoutes.editItem,
                              pathParameters: {
                                // 'categoryId': idStr,
                                TasksRoutes.categoryId: idStr,
                              },
                            );
                          }
                        },
                      );
                    },
                  );
                },
                error: (_, __) => Text("Error"),
                loading: () => CircularProgressIndicator(),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.goNamed(TasksRoutes.addItem),
              child: Text("Добавить категорию"),
            ),
            AppGap.l(),
          ],
        ),
      ),
    );
  }
}
