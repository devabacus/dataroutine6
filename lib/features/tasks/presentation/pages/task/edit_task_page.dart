import 'package:dataroutine6/features/tasks/presentation/providers/task/task_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../domain/entities/task.dart';

class EditTaskPage extends ConsumerStatefulWidget {
  const EditTaskPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UpdateTaskPageState();
}

class UpdateTaskPageState extends ConsumerState<EditTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  TextEditingController categIdController = TextEditingController();
  TextEditingController createdAtController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Здесь можно безопасно использовать провайдеры
      final selectedTask = ref.read(selectedTaskProvider)!;
      titleController.text = selectedTask.title;
      descripController.text = selectedTask.description;
      categIdController.text = selectedTask.categoryId.toString();
      createdAtController.text = selectedTask.createdAt.toString();
      durationController.text = selectedTask.duration.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskContr = ref.read(taskProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Редактирование задачи")),
      body: Column(
        children: [
          TextFieldFactory.createBasic(titleController, hint: "Название"),
          AppGap.m(),
          TextFieldFactory.createBasic(descripController, hint: "Описание"),
          AppGap.m(),
          TextFieldFactory.createBasic(
            durationController,
            hint: "Длительность",
          ),
          AppGap.m(),
          TextFieldFactory.createBasic(categIdController, hint: "Категория id"),
          AppGap.m(),

          ElevatedButton(
            style: AppButtonStyle.basicStyle,
            onPressed: () {
              final duration = int.parse(durationController.text);
              final categoryId = int.parse(categIdController.text);
              final createdAt = DateTime.now();
              final dueDateTime = DateTime.now();

              taskContr.updateTask(
                TaskEntity(
                  id: -1,
                  title: titleController.text,
                  description: descripController.text,
                  duration: duration,
                  createdAt: createdAt,
                  dueDateTime: dueDateTime,
                  categoryId: categoryId,
                ),
              );

              context.goNamed(TasksRoutes.viewTask);
            },
            child: Text("Сохранить"),
          ),
        ],
      ),
    );
  }
}
