import 'package:drift/drift.dart';

class TagTable extends Table {

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  
}
   