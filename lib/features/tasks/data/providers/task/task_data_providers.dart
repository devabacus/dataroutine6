import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../datasources/local/interfaces/task_local_datasource_service.dart';
import '../../datasources/local/sources/task_local_data_source.dart';
import '../../repositories/task_repository_impl.dart';
import '../../../../../core/database/local/provider/database_provider.dart';
import '../../../domain/repositories/task_repository.dart';

part 'task_data_providers.g.dart';

@riverpod
ITaskLocalDataSource taskLocalDataSource(Ref ref) {
  final databaseService = ref.read(databaseServiceProvider);
  return TaskLocalDataSource(databaseService);
}

@riverpod
ITaskRepository taskRepository(Ref ref) {
  final localDataSource = ref.read(taskLocalDataSourceProvider);
  return TaskRepositoryImpl(localDataSource);
}
