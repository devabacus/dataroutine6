import '../../../features/tasks/data/datasources/local/tables/task_tag_map_table.dart';
import '../../../features/tasks/data/datasources/local/tables/task_table.dart';
import '../../../features/tasks/data/datasources/local/tables/tag_table.dart';
import '../../../features/tasks/data/datasources/local/tables/category_table.dart';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

@DriftDatabase(tables: [CategoryTable, TagTable, TaskTable, TaskTagMapTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? excutor]) : super(excutor ?? _openConnection());

  @override
  int get schemaVersion => 4;

@override
MigrationStrategy get migration => MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
            
        if (from < 2) {
          //await m.addColumn(taskItems, taskItems.createAt);
        await m.createTable(tagTable);
        }        
        if (from < 3) {
          await m.createTable(taskTable);
          
        }

         if (from < 4) {
          await m.createTable(taskTagMapTable);
          
        }
      },
    );


  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'dataroutine6',
    );
  }
}

