
import 'package:dataroutine6/features/tasks/data/datasources/local/interface/category_local_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/database/local/provider/database_provider.dart';
import '../../../domain/repositories/category_repository.dart';
import '../../datasources/local/sources/category_local_data_source.dart';
import '../../repositories/category_repository_impl.dart';

part 'category_data_providers.g.dart';

@riverpod
ICategoryLocalDataSource categoryLocalDataSource(Ref ref) {
  final databaseService = ref.read(databaseServiceProvider);
  return CategoryLocalDataSource(databaseService);
}

@riverpod
CategoryRepository categoryRepository(Ref ref) {
  final localDataSource = ref.read(categoryLocalDataSourceProvider);
  return CategoryRepositoryImpl(localDataSource);
}
