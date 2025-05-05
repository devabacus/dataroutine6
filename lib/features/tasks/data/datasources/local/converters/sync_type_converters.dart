import 'dart:convert';
import 'dart:developer' as dev;
import 'package:drift/drift.dart';
import '../../../../domain/entities/sync/sync_metadata.dart';

/// Конвертер для SyncStatus enum
class SyncStatusConverter extends TypeConverter<SyncStatus, String> {
  const SyncStatusConverter();
  
  @override
  SyncStatus fromSql(String fromDb) {
    return SyncStatus.values.firstWhere(
      (status) => status.name == fromDb,
      orElse: () => SyncStatus.pending,
    );
  }
  
  @override
  String toSql(SyncStatus value) {
    return value.name;
  }
}

/// Конвертер для SyncAction enum
class SyncActionConverter extends TypeConverter<SyncAction, String> {
  const SyncActionConverter();
  
  @override
  SyncAction fromSql(String fromDb) {
    return SyncAction.values.firstWhere(
      (action) => action.name == fromDb,
      orElse: () => SyncAction.update,
    );
  }
  
  @override
  String toSql(SyncAction value) {
    return value.name;
  }
}

/// Конвертер для EntityType enum
class EntityTypeConverter extends TypeConverter<EntityType, String> {
  const EntityTypeConverter();
  
  @override
  EntityType fromSql(String fromDb) {
    return EntityType.values.firstWhere(
      (type) => type.name == fromDb,
      orElse: () => EntityType.category,
    );
  }
  
  @override
  String toSql(EntityType value) {
    return value.name;
  }
}

/// Конвертер для Map<String, dynamic> в JSON строку и обратно
class JsonMapConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonMapConverter();
  
  @override
  Map<String, dynamic> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return {};
    }
    
    try {
      return json.decode(fromDb) as Map<String, dynamic>;
    } catch (e) {
      // Логируем ошибку для отладки
      dev.log('Ошибка при декодировании JSON: $e. Содержимое: $fromDb', 
              name: 'JsonMapConverter');
      return {};
    }
  }
  
  @override
  String toSql(Map<String, dynamic> value) {
    return json.encode(value);
  }
}