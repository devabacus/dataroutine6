import 'package:dataroutine6/core/database/local/provider/database_provider.dart';
import 'package:dataroutine6/features/tasks/data/datasources/local/sources/task_tag_map_local_data_source.dart';
import 'package:dataroutine6/features/tasks/data/repositories/task_tag_map_repository.dart';
import 'package:dataroutine6/features/tasks/domain/repositories/task_tag_map_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasources/local/interface/task_tag_local_datasource_service.dart';

part 'task_tag_map_data_providers.g.dart';

@riverpod
ITaskTagMapLocalDataSource taskTagLocalDataSource(Ref ref) {
  final databaseService = ref.read(databaseServiceProvider);
  return TaskTagMapLocalDataSource(databaseService);
}

@riverpod
ITaskTagMapRepository taskTagMapRepository(Ref ref) {
  final localDataSource = ref.read(taskTagLocalDataSourceProvider);
  return TaskTagMapRepositoryImpl(localDataSource);
}
