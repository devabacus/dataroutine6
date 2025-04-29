import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../datasources/local/interfaces/tag_local_datasource_service.dart';
import '../../datasources/local/sources/tag_local_data_source.dart';
import '../../repositories/tag_repository_impl.dart';
import '../../../../../core/database/local/provider/database_provider.dart';
import '../../../domain/repositories/tag_repository.dart';

part 'tag_data_providers.g.dart';

@riverpod
ITagLocalDataSource tagLocalDataSource(Ref ref) {
  final databaseService = ref.read(databaseServiceProvider);
  return TagLocalDataSource(databaseService);
}

@riverpod
ITagRepository tagRepository(Ref ref) {
  final localDataSource = ref.read(tagLocalDataSourceProvider);
  return TagRepositoryImpl(localDataSource);
}
