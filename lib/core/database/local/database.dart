import '../../../features/tasks/data/datasources/local/tables/sync_metadata_table.dart';
import '../../../features/tasks/data/datasources/local/tables/task_tag_map_table.dart';
import '../../../features/tasks/data/datasources/local/tables/task_table.dart';
import '../../../features/tasks/data/datasources/local/tables/tag_table.dart';
import '../../../features/tasks/data/datasources/local/tables/category_table.dart';
import '../../../features/tasks/domain/entities/sync/sync_metadata.dart'; 

import '../../../features/tasks/data/datasources/local/converters/sync_type_converters.dart';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

@DriftDatabase(tables: [CategoryTable, TagTable, TaskTable, TaskTagMapTable, SyncMetadataTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 6;

@override
MigrationStrategy get migration => MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {

        await m.drop(taskTagMapTable);
        await m.drop(taskTable);
        await m.drop(tagTable);
        await m.drop(categoryTable);

        await m.createAll();
      },
    );


  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'dataroutine6',
    );
  }
}

