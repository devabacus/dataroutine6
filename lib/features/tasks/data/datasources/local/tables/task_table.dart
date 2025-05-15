import 'package:uuid/uuid.dart';

import '../../../datasources/local/tables/category_table.dart';
import 'package:drift/drift.dart';

class TaskTable extends Table {

  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get duration => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get dueDateTime => dateTime()();
  TextColumn get categoryId => text().references(CategoryTable, #id)();

  @override
  Set<Column> get primaryKey => {id};
}


