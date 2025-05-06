// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../../../../../core/database/local/provider/database_provider.dart';
// import '../../../domain/repositories/category_repository.dart';
// import '../../datasources/local/dao/category_dao.dart';
// import '../../datasources/local/interfaces/category_local_datasource_service.dart';
// import '../../datasources/local/sources/category_local_data_source.dart';
// import '../../repositories/category_repository_impl.dart';

// part 'category_data_providers.g.dart';

// @riverpod
// CategoryDao categoryDao(Ref ref) {
//   final databaseService = ref.read(databaseServiceProvider);
//   return CategoryDao(databaseService);
// }

// @riverpod
// ICategoryLocalDataSource categoryLocalDataSource(Ref ref) {
//   final categoryDao = ref.read(categoryDaoProvider);
//   return CategoryLocalDataSource(categoryDao);
// }

// @riverpod
// ICategoryRepository categoryRepository(Ref ref) {
//   final localDataSource = ref.read(categoryLocalDataSourceProvider);
//   return CategoryRepositoryImpl(localDataSource);
// }
     

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/database/local/provider/database_provider.dart';
import '../../../domain/repositories/category_repository.dart';
import '../../datasources/local/dao/category_dao.dart';
import '../../datasources/local/interfaces/category_local_datasource_service.dart';
import '../../datasources/local/sources/category_local_data_source.dart';
import '../../repositories/category_repository_impl.dart';
import '../remote/remote_data_providers.dart';
import '../sync/sync_providers.dart'; // Добавляем импорт sync_providers

part 'category_data_providers.g.dart';

@riverpod
CategoryDao categoryDao(Ref ref) {
  final databaseService = ref.read(databaseServiceProvider);
  return CategoryDao(databaseService);
}

@riverpod
ICategoryLocalDataSource categoryLocalDataSource(Ref ref) {
  final categoryDao = ref.read(categoryDaoProvider);
  return CategoryLocalDataSource(categoryDao);
}

@riverpod
ICategoryRepository categoryRepository(Ref ref) {
  final localDataSource = ref.read(categoryLocalDataSourceProvider);
  final syncMetadataService = ref.read(syncMetadataServiceProvider); // Получаем сервис метаданных
  final syncService = ref.read(syncServiceProvider); // Опционально: для автоматической синхронизации
  
  return CategoryRepositoryImpl(
    localDataSource,
    syncMetadataService,
    syncService, // Опционально: если хотите автоматическую синхронизацию
  );
}