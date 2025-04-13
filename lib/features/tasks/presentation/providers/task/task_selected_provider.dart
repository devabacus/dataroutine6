import 'package:dataroutine6/features/tasks/domain/entities/task/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_selected_provider.g.dart';

@riverpod
class SelectedTask extends _$SelectedTask {
  @override
  TaskEntity? build() {
    ref.keepAlive();
    return null;
  }

  void setTask(TaskEntity taskEntity) {
    state = taskEntity;
  }

  void reset() {
    state = null;
  }

}
