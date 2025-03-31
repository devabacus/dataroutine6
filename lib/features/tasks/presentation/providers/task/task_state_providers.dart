
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/providers/task_usecase_providers.dart';

part 'task_state_providers.g.dart';

@riverpod
class Task extends _$Task {
  @override
  Future<List<TaskEntity>> build() {
    return ref.read(getTaskUseCaseProvider)();
  }

  Future<void> addTask(TaskEntity task) async {
    state = await AsyncValue.guard(() async {
      await ref.read(createTaskUseCaseProvider)(task);
      return ref.read(getTaskUseCaseProvider)();
    });
  }

  Future<void> updateTask(TaskEntity task) async {
    state = await AsyncValue.guard(() async {
      await ref.read(updateTaskUseCaseProvider)(task);
      return ref.read(getTaskUseCaseProvider)();
    });
  }

  Future<void> deleteTask(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(deleteTaskUseCaseProvider)(id);
      return ref.read(getTaskUseCaseProvider)();
    });
  }
}
