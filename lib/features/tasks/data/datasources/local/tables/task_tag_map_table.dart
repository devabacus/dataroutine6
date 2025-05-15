import './tag_table.dart';
import './task_table.dart';
import 'package:drift/drift.dart';

class TaskTagMapTable extends Table {

  TextColumn get taskId => text().references(TaskTable, #id)();
  TextColumn get tagId => text().references(TagTable, #id)();
  
  @override
  Set<Column> get primaryKey => {taskId, tagId};
}

