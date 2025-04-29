import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database.dart';
import '../interface/database_service.dart';
import '../service/drift_database_service.dart';

part 'database_provider.g.dart';

@riverpod
AppDatabase appDatabase(Ref ref) {
  ref.keepAlive();
  return AppDatabase();
}

@riverpod
IDatabaseService databaseService(Ref ref) {
  ref.keepAlive();
  final database = ref.watch(appDatabaseProvider);
  return DriftDatabaseService(database);  
}