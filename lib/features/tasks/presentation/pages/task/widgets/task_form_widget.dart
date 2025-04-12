import 'package:dataroutine6/features/tasks/presentation/pages/task/widgets/tag_section_widget.dart';
import 'package:dataroutine6/features/tasks/presentation/pages/task/widgets/task_form_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

class TaskFormWidget extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TaskFormControllers ctrl;
  final VoidCallback onPickDateTime;
  final VoidCallback onPickCategory;
  final VoidCallback onSaveCurrent;
  final VoidCallback onSave;
  final bool isInitialized;
  final int? taskId;
  

  const TaskFormWidget({
    required this.onPickCategory,
    required this.onPickDateTime,
    required this.onSaveCurrent,
    required this.onSave,
    required this.ctrl,
    required this.formKey,
    required this.isInitialized,
    required this.taskId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFieldFactory.listTile(ctrl.title, hint: "Название"),
          TextFieldFactory.listTile(ctrl.description, hint: "Описание"),
          TextFieldFactory.listTile(ctrl.duration, hint: "Длительность"),

          TextFieldFactory.listTile(
            ctrl.dueDateTime,
            trailing: IconButton(
              onPressed: onPickDateTime,
              icon: Icon(Icons.date_range),
            ),
          ),

          TextFieldFactory.listTile(
            ctrl.categoryId,
            hint: "Выбрать категорию",
            trailing: IconButton(
              onPressed: onPickCategory,
              icon: Icon(Icons.phonelink_lock),
            ),
          ),
          // tag section
          if (taskId != null && isInitialized)
            TagSectionWidget(onSaveCurrent, taskId: taskId),
          ElevatedButton(
            style: AppButtonStyle.basicStyle,
            onPressed: onSave,
            child: Text("Сохранить"),
          ),
        ],
      ),
    );
  }
}
