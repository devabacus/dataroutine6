
import 'package:dataroutine6/features/tasks/domain/entities/task/task.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_form_state.freezed.dart';
part 'task_form_state.g.dart';

@freezed
abstract class TaskFormState with _$TaskFormState {
  const factory TaskFormState({
    @Default(false) bool isInitialized,
    String? taskId,
    String? categoryId,
    @Default('') String categoryTitle,
    TaskEntity? currentTask,
  }) = _TaskFormState;

  factory TaskFormState.fromJson(Map<String, dynamic> json) => _$TaskFormStateFromJson(json);
}



@riverpod
class TaskFormStateNotifier extends _$TaskFormStateNotifier {
  @override
  TaskFormState build() {
    return const TaskFormState();
  }

  void initialize(TaskEntity task) {
    state = state.copyWith(
      isInitialized: true,
      taskId: task.id,
      categoryId: task.categoryId,
      currentTask: task,
    );
  }

  void setCategoryId(String categoryId, String categoryTitle) {
    state = state.copyWith(
      categoryId: categoryId,
      categoryTitle: categoryTitle,
    );
  }

  void updateCurrentTask(TaskEntity task) {
    state = state.copyWith(currentTask: task);
  }

  void reset() {
    state = const TaskFormState();
  }
}
