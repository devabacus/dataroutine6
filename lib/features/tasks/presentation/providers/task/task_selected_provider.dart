import 'package:dataroutine6/features/tasks/domain/entities/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // void copyWith({
  //   int? id,
  //   String? title,
  //   String? description,
  //   DateTime? createdAt,
  //   DateTime? dueDateTime,
  //   int? duration,
  //   int? categoryId,
  // }) {
  //   state = TaskEntity(
  //     id: id ?? state!.id,
  //     title: title ?? state!.title,
  //     description: description ?? state!.description,
  //     duration: duration ?? state!.duration,
  //     createdAt: createdAt ?? state!.createdAt,
  //     dueDateTime: dueDateTime ?? state!.dueDateTime,
  //     categoryId: categoryId ?? state!.categoryId,
  //   );
  // }
}
