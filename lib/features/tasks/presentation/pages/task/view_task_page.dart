import 'package:dataroutine6/features/tasks/domain/entities/task.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class ViewTaskPage extends ConsumerWidget {
  const ViewTaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final selectedTask = ref.read(selectedTaskProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Задачи")),
      body: Column(
        children: [
          Expanded(
            child: tasks.when(
              data: (tasks) {
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(tasks[index].title),
                      subtitle: Text(tasks[index].description),
                      trailing: Text(tasks[index].duration.toString()),
                      onTap: () {
                        final id = tasks[index].id;
                        final title = tasks[index].title;
                        final description = tasks[index].description;
                        final duration = tasks[index].duration;
                        final createdAt = tasks[index].createdAt;
                        final dueDateTime = tasks[index].dueDateTime;
                        final categoryId = tasks[index].categoryId;

                        selectedTask.selectTask(
                          TaskEntity(
                            id: id,
                            title: title,
                            description: description,
                            duration: duration,
                            createdAt: createdAt,
                            dueDateTime: dueDateTime,
                            categoryId: categoryId,
                          ),
                        );
                        // print("go to edit page");

                        context.goNamed(TasksRoutes.editTask);
                      },
                    );
                  },
                );
              },
              error: (_, __) => Text("Error"),
              loading: () => CircularProgressIndicator(),
            ),
          ),
          AppGap.m(),
          ButtonFactory.basic(
            () => context.goNamed(TasksRoutes.addTask),
            "Добавить задачу",
          ),
          AppGap.m(),
        ],
      ),
    );
  }
}
