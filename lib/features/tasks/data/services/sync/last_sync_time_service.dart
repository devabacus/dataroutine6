import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/sync/sync_metadata.dart'; // для EntityType

/// Сервис для управления временем последней успешной синхронизации
/// для каждого типа сущности с использованием SharedPreferences.
class LastSyncTimeService {
  static const _prefix = 'last_sync_time_';
  
  /// Получает время последней успешной синхронизации для указанного [entityType].
  /// Возвращает null, если время для этого типа еще не сохранено.
  Future<DateTime?> getLastSyncTime(EntityType entityType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('$_prefix${entityType.name}');
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      print('[ERROR] LastSyncTimeService: Failed to get last sync time for ${entityType.name}. Error: $e');
      return null; // Возвращаем null в случае ошибки чтения
    }
  }
  
  /// Устанавливает время последней успешной синхронизации [time] для указанного [entityType].
  Future<void> setLastSyncTime(EntityType entityType, DateTime time) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('$_prefix${entityType.name}', time.millisecondsSinceEpoch);
      print('[INFO] LastSyncTimeService: Updated last sync time for ${entityType.name} to $time');
    } catch (e) {
      print('[ERROR] LastSyncTimeService: Failed to set last sync time for ${entityType.name}. Error: $e');
    }
  }
  
  /// Получает карту времени последней синхронизации для всех типов сущностей.
  Future<Map<EntityType, DateTime?>> getAllLastSyncTimes() async {
    final prefs = await SharedPreferences.getInstance();
    Map<EntityType, DateTime?> result = {};
    for (var type in EntityType.values) {
      final timestamp = prefs.getInt('$_prefix${type.name}');
      result[type] = timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    }
    return result;
  }
  
  /// Очищает сохраненное время последней синхронизации для указанного [entityType].
  Future<void> clearLastSyncTime(EntityType entityType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_prefix${entityType.name}');
      print('[INFO] LastSyncTimeService: Cleared last sync time for ${entityType.name}');
    } catch (e) {
      print('[ERROR] LastSyncTimeService: Failed to clear last sync time for ${entityType.name}. Error: $e');
    }
  }
  
  /// Очищает сохраненное время последней синхронизации для ВСЕХ типов сущностей.
  Future<void> clearAllLastSyncTimes() async {
    final prefs = await SharedPreferences.getInstance();
    for (var type in EntityType.values) {
      try {
        await prefs.remove('$_prefix${type.name}');
      } catch (e) {
         print('[ERROR] LastSyncTimeService: Failed to clear key for ${type.name}. Error: $e');
      }
    }
     print('[INFO] LastSyncTimeService: Cleared all last sync times.');
  }
}