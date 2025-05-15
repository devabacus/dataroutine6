// lib/features/tasks/presentation/pages/task/actions/task_form_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/utils/date_time_picker_utils.dart';
import '../../../../domain/entities/task/task.dart';
import '../../../providers/category/category_by_id_provider.dart';
import '../../../providers/task/task_form_state/task_form_state.dart';
import '../../../providers/task/task_selected_provider.dart';
import '../../../providers/task/task_state_providers.dart';
import '../../../providers/date_time/date_time_picker_notifier.dart';
import '../../../routing/tasks_routes_constants.dart';
import '../widgets/task_form_controllers.dart';

class TaskFormActions {
  final WidgetRef ref;
  final BuildContext context;
  final TaskFormControllers controllers;

  TaskFormActions({
    required this.ref,
    required this.context,
    required this.controllers,
  });

  void initializeForm() {
    final dateTimeController = ref.read(
      dateTimePickerNotifierProvider.notifier,
    );

    final selectedTask = ref.read(selectedTaskProvider);
    if (selectedTask != null) {
      // Режим редактирования
      controllers.title.text = selectedTask.title;
      controllers.description.text = selectedTask.description;
      controllers.duration.text = selectedTask.duration.toString();

      dateTimeController.setDateTime(selectedTask.dueDateTime);
      controllers.dueDateTime.text = DateTimePickerUtils.formatDateTime(
        selectedTask.dueDateTime,
      );

      // Обновляем состояние формы
      ref.read(taskFormStateNotifierProvider.notifier).initialize(selectedTask);

      // Загружаем информацию о категории
      loadCategoryInfo(selectedTask.categoryId);
    } else {
      // Режим создания
      controllers.dueDateTime.text = DateTimePickerUtils.formatDateTime(
        ref.read(dateTimePickerNotifierProvider),
      );
    }
  }

  Future<void> loadCategoryInfo(String categoryId) async {
    try {
      final category = await ref.read(
        getCategoryByIdProvider(categoryId).future,
      );
      controllers.categoryId.text = category.title;
      ref
          .read(taskFormStateNotifierProvider.notifier)
          .setCategoryId(categoryId, category.title);
    } catch (e) {
      controllers.categoryId.text = "Категория не найдена";
    }
  }

  void navigateToTagSelection() {
    final formState = ref.read(taskFormStateNotifierProvider);
    _saveCurrentTaskState();
    context.goNamed(
      TasksRoutes.viewTag,
      extra: {'isForTaskSelection': true, 'taskId': formState.taskId},
    );
  }

  void navigateToCategories() {
    final selectedTaskContr = ref.read(selectedTaskProvider.notifier);
    selectedTaskContr.setTask(_createTaskEntityFromForm());
    context.goNamed(
      TasksRoutes.viewCategory,
      pathParameters: {TasksRoutes.isFromTask: "1"},
    );
  }

  Future<void> pickDateTime() async {
    final initialDateTime = ref.read(dateTimePickerNotifierProvider);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
      );
      if (pickedTime != null) {
        final finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        ref
            .read(dateTimePickerNotifierProvider.notifier)
            .setDateTime(finalDateTime);
        controllers.dueDateTime.text = DateTimePickerUtils.formatDateTime(
          finalDateTime,
        );
      }
    }
  }

  void saveTask() {
    final taskContr = ref.read(taskProvider.notifier);
    final taskEntity = _createTaskEntityFromForm();
    final selectedTask = ref.read(selectedTaskProvider);
    final selectTaskContr = ref.read(selectedTaskProvider.notifier);

    if (selectedTask == null || selectedTask.id == 0) {
      taskContr.addTask(taskEntity);
    } else {
      taskContr.updateTask(taskEntity);
      selectTaskContr.reset();
    }
    ref.read(taskFormStateNotifierProvider.notifier).reset();
    controllers.clearAll();

    context.goNamed(TasksRoutes.viewTask);
  }

  void _saveCurrentTaskState() {
    final selectedTaskContr = ref.read(selectedTaskProvider.notifier);
    selectedTaskContr.setTask(_createTaskEntityFromForm());
  }

  TaskEntity _createTaskEntityFromForm() {
    final formState = ref.read(taskFormStateNotifierProvider);

    int duration = int.tryParse(controllers.duration.text) ?? 0;

    final createdAt = DateTime.now();

    final dueDate = DateTimePickerUtils.parseDateTime(
      controllers.dueDateTime.text,
    );

    return TaskEntity(
      id: formState.taskId ?? '',
      title: controllers.title.text,
      description: controllers.description.text,
      duration: duration,
      createdAt: createdAt,
      dueDateTime: dueDate ?? DateTime.now(),
      categoryId: formState.categoryId ?? '',
    );
  }
}
