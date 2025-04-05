
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../datasources/local/sources/task_local_data_source.dart';
import '../../repositories/task_repository_impl.dart';
import '../../../../../core/database/local/provider/database_provider.dart';
import '../../../domain/repositories/task_repository.dart';

part 'task_data_providers.g.dart';

@riverpod
TaskLocalDataSource taskLocalDataSource(Ref ref) {
  final db = ref.read(appDatabaseProvider);
  return TaskLocalDataSource(db);
}

@riverpod
TaskRepository taskRepository(Ref ref) {
  final localDataSource = ref.read(taskLocalDataSourceProvider);
  return TaskRepositoryImpl(localDataSource);
}
