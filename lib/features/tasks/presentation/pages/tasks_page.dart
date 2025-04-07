
import 'package:dataroutine6/features/tasks/presentation/pages/task/view_task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/tasks_navigation_provider.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final tasksNavService = ref.read(tasksNavigationServiceProvider);
    return ViewTaskPage();
  }
}

