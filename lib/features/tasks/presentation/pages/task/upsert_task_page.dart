import 'package:dataroutine6/features/tasks/domain/entities/task/task.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/form_controller_mixin.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/upsert_page_base.dart';
import 'package:dataroutine6/features/tasks/presentation/pages/task/actions/task_form_actions.dart';
import 'package:dataroutine6/features/tasks/presentation/pages/task/widgets/task_form_widget.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_form_state/task_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/task/task_state_providers.dart';
import '../../routing/tasks_routes_constants.dart';
import 'widgets/task_form_controllers.dart';

class UpsertTaskPage extends BaseUpsertPage<TaskEntity> {
  const UpsertTaskPage({super.isEditing = false, super.key});

  @override
  ConsumerState<BaseUpsertPage<TaskEntity>> createState() =>
      _UpsertTaskPageState();
}

class _UpsertTaskPageState
    extends BaseUpsertPageState<TaskEntity, UpsertTaskPage>
    with FormControllersMixin<TaskEntity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TaskFormControllers ctrl;
  Task? taskContr;
  late TaskFormActions _actions;

  @override
  void initState() {
    ctrl = TaskFormControllers();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _actions = TaskFormActions(ref: ref, context: context, controllers: ctrl);
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  void initializeData() {
    _actions.initializeForm();

  }

  @override
  void navigateBack() {
    context.goNamed(TasksRoutes.viewTask);
  }

  @override
  Widget buildForm() {
    final formState = ref.watch(taskFormStateNotifierProvider);
    taskContr = ref.read(taskProvider.notifier);

    return TaskFormWidget(
      onPickCategory: _actions.navigateToCategories,
      onPickDateTime: _actions.pickDateTime,
      onSaveCurrent: _actions.navigateToTagSelection,
      onSave: saveEntity,
      controllers: ctrl,
      formKey: _formKey,
      isInitialized: formState.isInitialized,
      taskId: formState.taskId,
    );
  }

  @override
  void saveEntity() {
    if (!_formKey.currentState!.validate()) return;
    _actions.saveTask();
  }
}
