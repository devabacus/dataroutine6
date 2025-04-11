import 'package:dataroutine6/core/utils/date_time_picker_utils.dart';
import 'package:dataroutine6/features/tasks/presentation/pages/task/widgets/tag_section_widget.dart';
import 'package:dataroutine6/features/tasks/presentation/pages/task/widgets/task_form_controllers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_by_id_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../domain/entities/task/task.dart';

class UpsertTaskPage extends ConsumerStatefulWidget {
  final bool isEditing;

  const UpsertTaskPage({this.isEditing = false, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UpdateTaskPageState();
}

class UpdateTaskPageState extends ConsumerState<UpsertTaskPage> {
  DateTime _selectedDateTime = DateTime.now();

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

        _selectedDateTime = selectedTask.dueDateTime;
        ctrl.dueDateTime.text = DateTimePickerUtils.formatDateTime(
          _selectedDateTime,
        );

        ctrl.duration.text = selectedTask.duration.toString();
        taskId = selectedTask.id;
        getCurrentCategory();
        setState(() {
          isInitialized = true;
        });
      } else {
        ctrl.dueDateTime.text = DateTimePickerUtils.formatDateTime(
          _selectedDateTime,
        );
      }
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  Future<void> getCurrentCategory() async {
    if (catId != null) {
      final category = await ref.watch(getCategoryByIdProvider(catId!).future);
      ctrl.categoryId.text = category.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskContr = ref.read(taskProvider.notifier);
    final selectedTaskContr = ref.read(selectedTaskProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? "Редактирование задачи" : "Добавить задачу",
        ),
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
            ctrl.dueDateTime,
            onChanged: (textVal) {
              final parsedValue = DateTimePickerUtils.parseDateTime(textVal);
              if (parsedValue != null) {
                setState(() {
                  _selectedDateTime = parsedValue;
                });
              }
            },
            trailing: IconButton(
              onPressed: () async {
                _selectedDateTime =
                    await DateTimePickerUtils.selectDate(
                      context,
                      _selectedDateTime,
                    ) ??
                    DateTime.now();
                if (!mounted) return;
                _selectedDateTime =
                    await DateTimePickerUtils.selectTime(
                      context,
                      _selectedDateTime,
                    ) ??
                    DateTime.now();

                ctrl.dueDateTime.text = DateTimePickerUtils.formatDateTime(
                  _selectedDateTime,
                );
              },
              icon: Icon(Icons.date_range),
            ),
          ),

          TextFieldFactory.listTile(
            ctrl.categoryId,
            hint: "Выбрать категорию",
            trailing: _pickCategory(selectedTaskContr),
          ),
          // tag section
          if (taskId != null && isInitialized)
            TagSectionWidget(_saveCurrentTaskState, taskId: taskId),
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

  void _saveCurrentTaskState(SelectedTask selectedTaskContr) {
    String durationText = ctrl.duration.text;

    int duration = durationText.isEmpty ? 0 : int.parse(durationText);

    final createdAt = DateTime.now();
    // _selectedDateTime = ctrl.dueDateTime.text;

    // сохраняем состояние задачи перед переходом на страницу категорий
    selectedTaskContr.setTask(
      TaskEntity(
        id: taskId ?? 0,
        title: ctrl.title.text,
        description: ctrl.description.text,
        duration: duration,
        createdAt: createdAt,
        dueDateTime: _selectedDateTime,
        categoryId: catId ?? 0,
      ),
    );
  }

  void _saveTask(Task taskContr) {
    final duration = int.parse(ctrl.duration.text);
    final createdAt = DateTime.now();
    // final dueDateTime = DateTime.now();

    final taskEntity = TaskEntity(
      id: taskId ?? 0,
      title: ctrl.title.text,
      description: ctrl.description.text,
      duration: duration,
      createdAt: createdAt,
      dueDateTime: _selectedDateTime,
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
