import 'package:drift/drift.dart';

import '../converters/sync_type_converters.dart';

class SyncMetadataTable extends Table {
  TextColumn get id => text()();
  TextColumn get entityId => text()();
  
  // Используем TypeConverter для enum типов
  TextColumn get entityType => text().map(const EntityTypeConverter())();
  TextColumn get action => text().map(const SyncActionConverter())();
  
  DateTimeColumn get lastLocalUpdate => dateTime()();
  DateTimeColumn get lastSyncTime => dateTime().nullable()();
  
  // Используем TypeConverter для enum типов
  TextColumn get status => text().map(const SyncStatusConverter())();
  
  TextColumn get errorMessage => text().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  
  // Используем TypeConverter для JSON Map
  TextColumn get additionalData => text().map(const JsonMapConverter())
      .withDefault(const Constant('{}'))();
  
  @override
  Set<Column> get primaryKey => {id};
}

