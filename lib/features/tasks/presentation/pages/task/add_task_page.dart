import 'package:dataroutine6/features/tasks/domain/entities/task.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task/task_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  TextEditingController categIdController = TextEditingController();
  TextEditingController createdAtController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  // TextEditingController dueDateTimeController = TextEditingController();

  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final taskContr = ref.read(taskProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Add task")),
      body: Form(
        child: Center(
          child: SizedBox(
            width: context.width(0.7),
            child: Column(
              
              children: [
                TextFieldFactory.createBasic(titleController, hint: "Название"),
                AppGap.m(),
                TextFieldFactory.createBasic(descripController, hint: "Описание"),
                AppGap.m(),
                TextFieldFactory.createBasic(durationController, hint: "Длительность"),
                AppGap.m(),
                TextFieldFactory.createBasic(categIdController, hint: "Категория id"),
                AppGap.m(),
                // TextFieldFactory.createBasic(descripController, hint: "Дедлайн"),
                // AppGap.m(),
                ElevatedButton(
                  style: AppButtonStyle.basicStyle,
                  onPressed: () {

                        final duration = int.parse(durationController.text);
                        final categoryId = int.parse(categIdController.text);
                        final createdAt = DateTime.now();
                        final dueDateTime = DateTime.now();

                      taskContr.addTask(TaskEntity(id: -1, title: titleController.text, description: descripController.text, duration: duration, createdAt: createdAt, dueDateTime: dueDateTime, categoryId: categoryId));

                      context.goNamed(TasksRoutes.viewTask);
                      
                  }, child: Text("Сохранить"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
