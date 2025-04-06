import './tag_table.dart';
import './task_table.dart';
import 'package:drift/drift.dart';

class TaskTagMapTable extends Table {

  IntColumn get taskId => integer().references(TaskTable, #id)();
  IntColumn get tagId => integer().references(TagTable, #id)();
  
  @override
  Set<Column> get primaryKey => {taskId, tagId};
}

