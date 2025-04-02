import 'package:dataroutine6/features/tasks/presentation/pages/task/task_form_controllers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task_tag/task_tag_state_providers.dart';
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
  late final TaskFormControllers ctrl;
  TaskEntity? currentEntity;
  bool isInitialized = false;

  int? taskId;
  int? catId;

  @override
  void initState() {
    super.initState();
    ctrl = TaskFormControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEditing) {
        final selectedTask = ref.read(selectedTaskProvider)!;
        ctrl.title.text = selectedTask.title;
        ctrl.description.text = selectedTask.description;

        catId = selectedTask.categoryId;
        ctrl.categoryId.text = catId.toString();

        ctrl.duration.text = selectedTask.duration.toString();
        taskId = selectedTask.id;
        getCurrentCategory();
        setState(() {
          isInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  Future<void> getCurrentCategory() async {
    final categories = await ref.watch(categoriesProvider.future);
    final currentCategory = categories.firstWhere((cat) => cat.id == catId);
    ctrl.categoryId.text = currentCategory.title;
  }

  @override
  Widget build(BuildContext context) {
    final taskContr = ref.read(taskProvider.notifier);
    final selectedTaskContr = ref.read(selectedTaskProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text("Редактирование задачи"),
        leading: IconButton(
          onPressed: () {
            context.goNamed(TasksRoutes.viewTask);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          TextFieldFactory.listTile(ctrl.title, hint: "Название"),
          TextFieldFactory.listTile(ctrl.description, hint: "Описание"),
          TextFieldFactory.listTile(ctrl.duration, hint: "Длительность"),
          TextFieldFactory.listTile(
            ctrl.categoryId,
            hint: "Выбрать категорию",
            trailing: _pickCategory(selectedTaskContr),
          ),
          // tag section
          if (taskId != null && isInitialized) _buildTagsSection(),
          ElevatedButton(
            style: AppButtonStyle.basicStyle,
            onPressed: () {
              _saveTask(taskContr);
            },
            child: Text("Сохранить"),
          ),
        ],
      ),
    );
  }

  Widget _pickCategory(SelectedTask selectedTaskContr) {
    return IconButton(
      icon: Icon(Icons.phonelink_lock),
      onPressed: () {
        _saveCurrentTaskState(selectedTaskContr);
        context.goNamed(
          TasksRoutes.viewCategory,
          pathParameters: {TasksRoutes.isFromTask: "1"},
        );
      },
    );
  }

  Widget _buildTagsSection() {
    // Отображаем текущие теги задачи
    final taskTag = ref.watch(taskTagsProvider(taskId: taskId!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        taskTag.when(
          data: (tags) {
            return Column(
              children: [
                if (tags.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children:
                        tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag.title),
                                onDeleted: () {
                                  ref
                                      .read(
                                        taskTagsProvider(
                                          taskId: taskId!,
                                        ).notifier,
                                      )
                                      .removeTagFromTask(taskId!, tag.id);
                                },
                              ),
                            )
                            .toList(),
                  ),
                  AppGap.s(),
                ButtonFactory.basic(() {
                  _saveCurrentTaskState(
                    ref.read(selectedTaskProvider.notifier),
                  );

                  context.goNamed(
                    TasksRoutes.viewTag,
                    extra: {'isForTaskSelection': true, 'taskId': taskId},
                  );
                }, "Добавить тэги"),
              ],
            );
          },
          error: (_, __) => Text("Error"),
          loading: () => CircularProgressIndicator(),
        ),
        AppGap.l(),
      ],
    );
  }

  void _saveCurrentTaskState(SelectedTask selectedTaskContr) {
    int duration = int.parse(ctrl.duration.text);

    final createdAt = DateTime.now();
    final dueDateTime = DateTime.now();

    // сохраняем состояние задачи перед переходом на страницу категорий
    selectedTaskContr.setTask(
      TaskEntity(
        id: taskId ?? 0,
        title: ctrl.title.text,
        description: ctrl.description.text,
        duration: duration,
        createdAt: createdAt,
        dueDateTime: dueDateTime,
        categoryId: catId ?? 0,
      ),
    );
  }

  void _saveTask(Task taskContr) {
    final duration = int.parse(ctrl.duration.text);
    final createdAt = DateTime.now();
    final dueDateTime = DateTime.now();

    final taskEntity = TaskEntity(
      id: taskId ?? 0,
      title: ctrl.title.text,
      description: ctrl.description.text,
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
  }
}
