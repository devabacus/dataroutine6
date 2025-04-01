import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../domain/entities/task.dart';

class UpsertTaskPage extends ConsumerStatefulWidget {
  final bool isEditing;

  const UpsertTaskPage({this.isEditing = false, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UpdateTaskPageState();
}

class UpdateTaskPageState extends ConsumerState<UpsertTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  TextEditingController categIdController = TextEditingController();
  TextEditingController createdAtController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  TaskEntity? currentEntity;

  int? taskId;
  int? catId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEditing) {
        final selectedTask = ref.read(selectedTaskProvider)!;
        titleController.text = selectedTask.title;
        descripController.text = selectedTask.description;

        catId = selectedTask.categoryId;
        categIdController.text = catId.toString();

        durationController.text = selectedTask.duration.toString();
        taskId = selectedTask.id;
        getCurrentCategory();
      }
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
    final selectedTaskContr = ref.read(selectedTaskProvider.notifier);

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

          TextFieldFactory.createBasic(tagController, hint: "Тэг"),

          AppGap.m(),

          ListTile(
            title: TextFieldFactory.createBasic(
              categIdController,
              hint: "Категория id",
            ),
            trailing: IconButton(
              icon: Icon(Icons.phonelink_lock),
              onPressed: () {
                int duration = 0;
                duration = int.parse(durationController.text);

                final createdAt = DateTime.now();
                final dueDateTime = DateTime.now();

                // сохраняем состояние задачи перед переходом на страницу категорий
                selectedTaskContr.setTask(
                  TaskEntity(
                    id: taskId ?? 0,
                    title: titleController.text,
                    description: descripController.text,
                    duration: duration,
                    createdAt: createdAt,
                    dueDateTime: dueDateTime,
                    categoryId: catId ?? 0,
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

              final taskEntity = TaskEntity(
                id: taskId ?? 0,
                title: titleController.text,
                description: descripController.text,
                duration: duration,
                createdAt: createdAt,
                dueDateTime: dueDateTime,
                categoryId: catId!,
              );

              final selectedTask = ref.read(selectedTaskProvider);
              if (selectedTask == null) {
                // новая задача
                taskContr.addTask(
                  taskEntity,
                ); // перешли изначально на для добавления selectedTask не сохраняли
              } else if (selectedTask.id ==
                  0) // перешли после выбора категории поэтому selectedTask уже есть, но id не присвоен (присваивается автоматически при добавлении категории)
              {
                taskContr.addTask(taskEntity);
              } else //Зашли для редактирования task id не ноль
              {
                taskContr.updateTask(taskEntity);
              }

              context.goNamed(TasksRoutes.viewTask);
            },
            child: Text("Сохранить"),
          ),
        ],
      ),
    );
  }
}
