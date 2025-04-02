import 'package:dataroutine6/features/tasks/domain/entities/task.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/drawer.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/delete_select_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task_tag/task_tag_state_providers.dart';
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
    final deleteState = ref.watch(deleteSelectProvider);
    final deleteContr = ref.read(deleteSelectProvider.notifier);

    final taskCtrl = ref.read(taskProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text("Задачи"),
        actions: [
          IconButton(
            onPressed: () => context.goNamed(TasksRoutes.dbViewer),
            icon: Icon(Icons.data_object_sharp),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          children: [
            tasks.when(
              data: (tasks) {
                return tasks.isEmpty
                    ? Text("Список пуст")
                    : Expanded(
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return GestureDetector(
                            onLongPress: () => deleteContr.setDeleteSelect(),
                            child: ListTile(
                              title: Text(task.title),
                              subtitle: Text(task.description),
                              onTap: () {
                                if (!deleteState) {
                                  selectedTask.setTask(task);
                                  context.goNamed(TasksRoutes.editTask);
                                }
                              },
                              trailing:
                                  deleteState
                                      ? IconButton(
                                        onPressed: () {
                                          // delete selected task
                                          taskCtrl.deleteTask(task.id);
                                          selectedTask.setTask(task);
                                          ref
                                              .read(
                                                taskTagsProvider(
                                                  taskId: task.id,
                                                ).notifier,
                                              )
                                              .removeAllTagsFromTask(task.id);
                                        },
                                        icon: Icon(Icons.delete),
                                      )
                                      : null,
                            ),
                          );
                        },
                      ),
                    );
                // return _createListViewBuilder(context, tasks, selectedTask);
              },
              error: (_, __) => Text("Error"),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
            AppGap.m(),
            ButtonFactory.basic(
              () => context.goNamed(TasksRoutes.addTask),
              "Добавить задачу",
            ),
          ],
        ),
      ),
    );
  }
}

ListView _createListViewBuilder(
  BuildContext context,
  List<TaskEntity> tasks,
  SelectedTask selectedTask,
) {
  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onLongPress: () => print("longpress"),
        child: ListTile(
          title: Text(tasks[index].title),
          subtitle: Text(tasks[index].description),
          onTap: () {
            final id = tasks[index].id;
            final title = tasks[index].title;
            final description = tasks[index].description;
            final duration = tasks[index].duration;
            final createdAt = tasks[index].createdAt;
            final dueDateTime = tasks[index].dueDateTime;
            final categoryId = tasks[index].categoryId;

            selectedTask.setTask(
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
        ),
      );
    },
  );
}
