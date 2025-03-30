
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/tasks_navigation_service.dart';

part 'tasks_navigation_provider.g.dart';

@riverpod
TasksNavigationService tasksNavigationService(Ref ref) {
  return TasksNavigationService();
}

