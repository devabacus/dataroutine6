import 'package:dataroutine6/features/tasks/domain/entities/task/task.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/form_controller_mixin.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/upsert_page_base.dart';
import 'package:dataroutine6/features/tasks/presentation/pages/task/actions/task_form_actions.dart';
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
  final bool isEditing1;

  const UpsertTaskPage({this.isEditing1 = false, super.key});

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
  late TaskFormActions _actions;

  @override
  void initState() {
    ctrl = TaskFormControllers();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _actions = TaskFormActions(
      ref: ref,
      context: context,
      controllers: ctrl,
      taskId: taskId,
      categoryId: catId,
    );
  }

  @override
  void initializeData() {
    final dateTimeController = ref.read(
      dateTimePickerNotifierProvider.notifier,
    );

    if (widget.isEditing1) {
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

     _actions = TaskFormActions(
      ref: ref,
      context: context,
      controllers: ctrl, 
      taskId: taskId,
      categoryId: catId,
    );
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
        widget.isEditing1 ? "Редактирование задачи" : "Добавить задачу",
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
      onPickCategory: _actions.navigateToCategories,
      onPickDateTime: _actions.pickDateTime,
      onSaveCurrent: _actions.navigateToTagSelection,
      onSave: saveEntity,
      ctrl: ctrl,
      formKey: _formKey,
      isInitialized: isInitialized,
      taskId: taskId,
    );
  }
  
  @override
  void saveEntity() {
    if (!_formKey.currentState!.validate()) return;
    _actions.saveTask();
  }

}
