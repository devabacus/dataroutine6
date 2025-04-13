// lib/features/tasks/presentation/pages/task/actions/task_form_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/utils/date_time_picker_utils.dart';
import '../../../../domain/entities/task/task.dart';
import '../../../providers/task/task_selected_provider.dart';
import '../../../providers/task/task_state_providers.dart';
import '../../../providers/date_time/date_time_picker_notifier.dart';
import '../../../routing/tasks_routes_constants.dart';
import '../widgets/task_form_controllers.dart';

class TaskFormActions {
  final WidgetRef ref;
  final BuildContext context;
  final TaskFormControllers controllers;
  final int? taskId;
  final int? categoryId;

  TaskFormActions({
    required this.ref,
    required this.context,
    required this.controllers,
    this.taskId,
    this.categoryId,
  });

  void navigateToTagSelection() {
    _saveCurrentTaskState();
    context.goNamed(
      TasksRoutes.viewTag,
      extra: {'isForTaskSelection': true, 'taskId': taskId},
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
    final dateTimeController = ref.read(dateTimePickerNotifierProvider.notifier);
    await dateTimeController.updateDate(context);
    await dateTimeController.updateTime(context);
  }

  void saveTask() {
    final taskContr = ref.read(taskProvider.notifier);
    final taskEntity = _createTaskEntityFromForm();
    final selectedTask = ref.read(selectedTaskProvider);

    if (selectedTask == null || selectedTask.id == 0) {
      taskContr.addTask(taskEntity);
    } else {
      taskContr.updateTask(taskEntity);
    }

    context.goNamed(TasksRoutes.viewTask);
  }

  void _saveCurrentTaskState() {
    final selectedTaskContr = ref.read(selectedTaskProvider.notifier);
    selectedTaskContr.setTask(_createTaskEntityFromForm());
  }

  TaskEntity _createTaskEntityFromForm() {
    String durationText = controllers.duration.text;
    int duration = durationText.isEmpty ? 0 : int.parse(durationText);
    final createdAt = DateTime.now();

    final dueDate = DateTimePickerUtils.parseDateTime(controllers.dueDateTime.text);
    if (dueDate != null) {
      ref.read(dateTimePickerNotifierProvider.notifier).setDateTime(dueDate);
    }

    return TaskEntity(
      id: taskId ?? 0,
      title: controllers.title.text,
      description: controllers.description.text,
      duration: duration,
      createdAt: createdAt,
      dueDateTime: dueDate ?? DateTime.now(),
      categoryId: categoryId ?? 0,
    );
  }
}