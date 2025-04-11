import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/task/task.dart';

class TaskItemBuilder extends ConsumerWidget {
  final TaskEntity task;

  const TaskItemBuilder({required this.task, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(task.title), Text(task.description)],
    );
  }
}
