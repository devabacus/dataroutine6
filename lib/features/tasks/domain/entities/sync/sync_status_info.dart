import 'package:freezed_annotation/freezed_annotation.dart';
import 'sync_metadata.dart'; // Импортируем для использования EntityType

part 'sync_status_info.freezed.dart';
part 'sync_status_info.g.dart';

/// Представляет собой моментальный снимок состояния процесса синхронизации.
@freezed
abstract class SyncStatusInfo with _$SyncStatusInfo {
  const factory SyncStatusInfo({
    /// Время последней *успешной* синхронизации всех данных.
    /// Может быть null, если синхронизация еще не проводилась успешно.
    DateTime? lastSuccessfulSync,

    /// Указывает, выполняется ли операция синхронизации в данный момент.
    @Default(false) bool isSyncing,

    /// Указывает, доступно ли сетевое подключение в данный момент.
    @Default(false) bool isOnline,

    /// Указывает, включена ли автоматическая фоновая синхронизация.
    @Default(true) bool autoSyncEnabled,

    /// Карта, показывающая количество ожидающих (несинхронизированных)
    /// изменений для каждого типа сущности ([EntityType]).
    @Default({}) Map<EntityType, int> pendingChangesCount,

    /// Общее количество элементов, синхронизация которых завершилась с ошибкой
    /// и требует внимания или повторной попытки.
    @Default(0) int errorCount,

    /// Текстовое сообщение последней возникшей ошибки синхронизации.
    /// Null, если ошибок не было или последняя операция была успешной.
    String? lastErrorMessage,

    /// Карта для хранения любой дополнительной, специфичной для приложения,
    /// информации о состоянии синхронизации.
    @Default({}) Map<String, dynamic> additionalInfo,
  }) = _SyncStatusInfo;

  /// Фабричный конструктор для создания экземпляра [SyncStatusInfo] из JSON.
  factory SyncStatusInfo.fromJson(Map<String, dynamic> json) =>
      _$SyncStatusInfoFromJson(json);
}