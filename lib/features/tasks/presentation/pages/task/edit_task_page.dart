import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
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

  TaskEntity? currentEntity;

  late int taskId;
  late int catId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Здесь можно безопасно использовать провайдеры
      final selectedTask = ref.read(selectedTaskProvider)!;
      titleController.text = selectedTask.title;
      descripController.text = selectedTask.description;
      categIdController.text = selectedTask.categoryId.toString();
      catId = selectedTask.categoryId;

      durationController.text = selectedTask.duration.toString();
      taskId = selectedTask.id;

      getCurrentCategory();
    });
  }

  Future<void> getCurrentCategory() async {
    final categories = await ref.watch(categoriesProvider.future);
    final currentCategory = categories.firstWhere((cat) => cat.id == catId);
    categIdController.text = currentCategory.title;
  }

  @override
  Widget build(BuildContext context) {
    final taskContr = ref.read(taskProvider.notifier);
    final selectedTask = ref.read(selectedTaskProvider.notifier);

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

          ListTile(
            title: TextFieldFactory.createBasic(
              categIdController,
              hint: "Категория id",
            ),
            trailing: IconButton(
              icon: Icon(Icons.phonelink_lock),
              onPressed: () {
                final duration = int.parse(durationController.text);
                final createdAt = DateTime.now();
                final dueDateTime = DateTime.now();

                selectedTask.setTask(
                  TaskEntity(
                    id: taskId,
                    title: titleController.text,
                    description: descripController.text,
                    duration: duration,
                    createdAt: createdAt,
                    dueDateTime: dueDateTime,
                    categoryId: catId,
                  ),
                );
                context.goNamed(
                  TasksRoutes.viewCategory,
                  pathParameters: {TasksRoutes.isFromTask: "1"},
                );
              },
            ),
          ),

          AppGap.m(),

          ElevatedButton(
            style: AppButtonStyle.basicStyle,
            onPressed: () {
              final duration = int.parse(durationController.text);
              final createdAt = DateTime.now();
              final dueDateTime = DateTime.now();

              taskContr.updateTask(
                TaskEntity(
                  id: taskId,
                  title: titleController.text,
                  description: descripController.text,
                  duration: duration,
                  createdAt: createdAt,
                  dueDateTime: dueDateTime,
                  categoryId: catId,
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
