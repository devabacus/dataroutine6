
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../usecases/task/create.dart';
import '../../usecases/task/delete.dart';
import '../../usecases/task/update.dart';
import '../../usecases/task/get_all.dart';
import '../../../data/providers/task/task_data_providers.dart';

part 'task_usecase_providers.g.dart';

@riverpod
GetTaskUseCase getTaskUseCase(Ref ref) {
  final repository = ref.read(taskRepositoryProvider);
  return GetTaskUseCase(repository);
}

@riverpod
CreateTaskUseCase createTaskUseCase(Ref ref) {
  final repository = ref.read(taskRepositoryProvider);
  return CreateTaskUseCase(repository);
}

@riverpod
DeleteTaskUseCase deleteTaskUseCase(Ref ref) {
  final repository = ref.read(taskRepositoryProvider);
  return DeleteTaskUseCase(repository);
}

@riverpod
UpdateTaskUseCase updateTaskUseCase(Ref ref) {
  final repository = ref.read(taskRepositoryProvider);
  return UpdateTaskUseCase(repository);
}
