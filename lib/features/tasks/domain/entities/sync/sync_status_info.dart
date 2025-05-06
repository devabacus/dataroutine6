// lib/features/tasks/domain/entities/sync/sync_status_info.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'sync_metadata.dart';

part 'sync_status_info.freezed.dart';
part 'sync_status_info.g.dart';

/// Информация о состоянии синхронизации
@freezed
abstract class SyncStatusInfo with _$SyncStatusInfo {
  const factory SyncStatusInfo({
    /// Последнее время успешной синхронизации
    DateTime? lastSuccessfulSync,
    
    /// Выполняется ли синхронизация в данный момент
    @Default(false) bool isSyncing,
    
    /// Подключение к сети в данный момент
    @Default(false) bool isOnline,
    
    /// Включена ли автоматическая синхронизация
    @Default(true) bool autoSyncEnabled,
    
    /// Количество несинхронизированных элементов (по типам)
    @Default({}) Map<EntityType, int> pendingChangesCount,
    
    /// Количество элементов с ошибками синхронизации
    @Default(0) int errorCount,
    
    /// Последняя ошибка синхронизации
    String? lastErrorMessage,
    
    /// Дополнительная информация о синхронизации
    @Default({}) Map<String, dynamic> additionalInfo,
  }) = _SyncStatusInfo;

  factory SyncStatusInfo.fromJson(Map<String, dynamic> json) =>
      _$SyncStatusInfoFromJson(json);
}