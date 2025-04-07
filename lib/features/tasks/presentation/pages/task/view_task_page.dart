// lib/features/tasks/presentation/pages/view_task_page.dart
import 'package:dataroutine6/features/tasks/presentation/common_widgets/entity_list_page.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task_tag/task_tag_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common_widgets/entity_list_page_config.dart';

class ViewTaskPage extends ConsumerWidget {
  const ViewTaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final taskCtrl = ref.read(taskProvider.notifier);
    final selectedTask = ref.read(selectedTaskProvider.notifier);

    return EntityListPage(
      config: EntityListConfig(
        title: "Задачи",
        actions: [
          IconButton(
            onPressed: () => context.goNamed(TasksRoutes.dbViewer),
            icon: Icon(Icons.data_object_sharp),
          ),
        ],
        addButtonText: "Добавить задачу",
        addRouteName: TasksRoutes.addTask,
        editRouteName: TasksRoutes.editTask,
        dataProvider: tasks,
        onItemTap: (task) {
          selectedTask.setTask(task);
          context.goNamed(TasksRoutes.editTask);
        },  
        itemBuilder: (context, task, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title),
            Text(task.description),
          ],
        ),
        onItemDelete: (task) {
          taskCtrl.deleteTask(task.id);
          ref
              .read(taskTagsProvider(taskId: task.id).notifier)
              .removeAllTagsFromTask(task.id);
        },
      ),
    );
  }
}