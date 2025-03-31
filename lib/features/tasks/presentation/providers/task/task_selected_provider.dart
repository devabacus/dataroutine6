
import 'package:dataroutine6/features/tasks/domain/entities/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'task_selected_provider.g.dart';



@riverpod
class SelectedTask extends _$SelectedTask {
  @override
  TaskEntity? build() {
    return null;
  }


  void selectTask(TaskEntity taskEntity){
      state = taskEntity;
  }



}
