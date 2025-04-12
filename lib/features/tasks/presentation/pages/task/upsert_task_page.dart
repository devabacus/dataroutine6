import 'package:dataroutine6/features/tasks/domain/entities/task/task.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/form_controller_mixin.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/upsert_page_base.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/date_time/date_time_picker_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../../../core/utils/date_time_picker_utils.dart';
import '../../providers/category/category_by_id_provider.dart';
import '../../providers/task/task_selected_provider.dart';
import '../../providers/task/task_state_providers.dart';
import '../../routing/tasks_routes_constants.dart';
import 'widgets/tag_section_widget.dart';
import 'widgets/task_form_controllers.dart';

class UpsertTaskPage extends BaseUpsertPage<TaskEntity> {
  final bool isEditing;

  const UpsertTaskPage({this.isEditing = false, super.key});

  @override
  ConsumerState<BaseUpsertPage<TaskEntity>> createState() =>
      _UpsertTaskPageState();
}

class _UpsertTaskPageState
    extends BaseUpsertPageState<TaskEntity, UpsertTaskPage>
    with FormControllersMixin<TaskEntity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // DateTime _selectedDateTime = DateTime.now();

  late final TaskFormControllers ctrl;
  TaskEntity? currentEntity;
  bool isInitialized = false;
  Task? taskContr;

  int? taskId;
  int? catId;

  @override
  void initState() {
    ctrl = TaskFormControllers();
    super.initState();
  }

  @override
  void initializeData() {
    final dateTimeController = ref.read(
      dateTimePickerNotifierProvider.notifier,
    );

    if (widget.isEditing) {
      final selectedTask = ref.read(selectedTaskProvider)!;
      ctrl.title.text = selectedTask.title;
      ctrl.description.text = selectedTask.description;

      catId = selectedTask.categoryId;
      ctrl.categoryId.text = catId.toString();

      dateTimeController.setDateTime(selectedTask.dueDateTime);
      ctrl.dueDateTime.text = DateTimePickerUtils.formatDateTime(
        selectedTask.dueDateTime,
      );

      ctrl.duration.text = selectedTask.duration.toString();
      taskId = selectedTask.id;
      getCurrentCategory();
      setState(() {
        isInitialized = true;
      });
    } else {
      ctrl.dueDateTime.text = DateTimePickerUtils.formatDateTime(
        ref.read(dateTimePickerNotifierProvider),
      );
    }
  }

  Future<void> getCurrentCategory() async {
    if (catId != null) {
      final category = await ref.watch(getCategoryByIdProvider(catId!).future);
      ctrl.categoryId.text = category.title;
    }
  }

  @override
  void navigateBack() {
    context.goNamed(TasksRoutes.viewTask);
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        widget.isEditing ? "Редактирование задачи" : "Добавить задачу",
      ),
      leading: IconButton(
        onPressed: () {
          context.goNamed(TasksRoutes.viewTask);
        },
        icon: Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  Widget buildForm() {
    taskContr = ref.read(taskProvider.notifier);
    final selectedTaskContr = ref.read(selectedTaskProvider.notifier);

    final dateTimeController = ref.read(
      dateTimePickerNotifierProvider.notifier,
    );
    // final dueDate = ref.watch(dateTimePickerNotifierProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFieldFactory.listTile(ctrl.title, hint: "Название"),
          TextFieldFactory.listTile(ctrl.description, hint: "Описание"),
          TextFieldFactory.listTile(ctrl.duration, hint: "Длительность"),

          TextFieldFactory.listTile(
            ctrl.dueDateTime,
            onChanged: (textVal) {
              final parsedValue = DateTimePickerUtils.parseDateTime(textVal);
              if (parsedValue != null) {
                dateTimeController.setDateTime(parsedValue);
              }
            },
            trailing: IconButton(
              onPressed: () async {
                await dateTimeController.updateDate(context);
                if (!mounted) return;
                await dateTimeController.updateTime(context);

                final updatedDateTime = ref.read(
                  dateTimePickerNotifierProvider,
                );
                ctrl.dueDateTime.text = DateTimePickerUtils.formatDateTime(
                  updatedDateTime,
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
              _saveTask(taskContr!);
            },
            child: Text("Сохранить"),
          ),
        ],
      ),
    );
  }

  @override
  void saveEntity() {
    if (!_formKey.currentState!.validate()) return;
    _saveTask(taskContr!);
  }

  Widget _pickCategory(SelectedTask selectedTaskContr) {
    return IconButton(
      icon: Icon(Icons.phonelink_lock),
      onPressed: () {
        // _saveCurrentTaskState(selectedTaskContr);
        selectedTaskContr.setTask(_createTaskEntityFromForm());
        context.goNamed(
          TasksRoutes.viewCategory,
          pathParameters: {TasksRoutes.isFromTask: "1"},
        );
      },
    );
  }

  TaskEntity _createTaskEntityFromForm() {
    String durationText = ctrl.duration.text;
    int duration = durationText.isEmpty ? 0 : int.parse(durationText);
    final createdAt = DateTime.now();

    // сохраняем состояние задачи перед переходом на страницу категорий
    return TaskEntity(
      id: taskId ?? 0,
      title: ctrl.title.text,
      description: ctrl.description.text,
      duration: duration,
      createdAt: createdAt,
      dueDateTime: ref.watch(dateTimePickerNotifierProvider),
      categoryId: catId ?? 0,
    );
  }

  void _saveCurrentTaskState(SelectedTask selectedTaskContr) {
    selectedTaskContr.setTask(_createTaskEntityFromForm());
  }

  void _saveTask(Task taskContr) {
    final taskEntity = _createTaskEntityFromForm();

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
