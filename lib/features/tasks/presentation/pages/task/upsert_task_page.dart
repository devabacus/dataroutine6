import 'package:dataroutine6/features/tasks/domain/entities/task/task.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/form_controller_mixin.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/upsert_page_base.dart';
import 'package:dataroutine6/features/tasks/presentation/pages/task/widgets/task_form_widget.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/date_time/date_time_picker_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/date_time_picker_utils.dart';
import '../../providers/category/category_by_id_provider.dart';
import '../../providers/task/task_selected_provider.dart';
import '../../providers/task/task_state_providers.dart';
import '../../routing/tasks_routes_constants.dart';
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

    ref.listen<DateTime>(dateTimePickerNotifierProvider, (
      previousState,
      newState,
    ) {
      if (previousState != newState) {
        if (mounted) {
          ctrl.dueDateTime.text = DateTimePickerUtils.formatDateTime(newState);
        }
      }
    });

    return TaskFormWidget(
      onPickCategory: () => _pickCategory(selectedTaskContr),
      onPickDateTime: onPickDateTime,
      onSaveCurrent: onSaveCurrent,
      onSave: ()=>_saveTask(taskContr!),
      ctrl: ctrl,
      formKey: _formKey,
      isInitialized: isInitialized,
      taskId: taskId,
    );   
  }

  void onSaveCurrent() {
    _saveCurrentTaskState(ref.read(selectedTaskProvider.notifier));
    context.goNamed(
      TasksRoutes.viewTag,
      extra: {'isForTaskSelection': true, 'taskId': taskId},
    );
  }

  Future<void> onPickDateTime() async {
    final dateTimeController = ref.read(
      dateTimePickerNotifierProvider.notifier,
    );
    await dateTimeController.updateDate(context);
    if (!mounted) return;
    await dateTimeController.updateTime(context);
  }

  @override
  void saveEntity() {
    if (!_formKey.currentState!.validate()) return;
    _saveTask(taskContr!);
  }

  void _pickCategory(SelectedTask selectedTaskContr) {
    // _saveCurrentTaskState(selectedTaskContr);
    selectedTaskContr.setTask(_createTaskEntityFromForm());
    context.goNamed(
      TasksRoutes.viewCategory,
      pathParameters: {TasksRoutes.isFromTask: "1"},
    );
  }

  TaskEntity _createTaskEntityFromForm() {
    String durationText = ctrl.duration.text;
    int duration = durationText.isEmpty ? 0 : int.parse(durationText);
    final createdAt = DateTime.now();

    final dueDate = DateTimePickerUtils.parseDateTime(ctrl.dueDateTime.text);
    if (dueDate != null) {
      ref.read(dateTimePickerNotifierProvider.notifier).setDateTime(dueDate);
    }

    // сохраняем состояние задачи перед переходом на страницу категорий
    return TaskEntity(
      id: taskId ?? 0,
      title: ctrl.title.text,
      description: ctrl.description.text,
      duration: duration,
      createdAt: createdAt,
      dueDateTime: dueDate ?? DateTime.now(),
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