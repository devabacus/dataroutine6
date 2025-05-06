// В файле: lib/features/tasks/data/providers/sync/sync_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Базовые зависимости
import '../../../../../core/database/local/provider/database_provider.dart';
import '../../../domain/entities/sync/sync_status_info.dart';
import '../../../domain/services/sync_service.dart'; // Интерфейс ISyncService
import '../remote/remote_data_providers.dart'; // Для firestoreProvider

// DAO и Сервисы синхронизации
import '../../datasources/local/dao/sync_metadata_dao.dart';
import '../../services/sync/entity_handlers/category_sync_handler.dart';
// TODO: Импортировать другие обработчики, когда они будут созданы
import '../../services/sync/sync_metadata_service.dart';
import '../../services/sync/last_sync_time_service.dart'; // <-- Импорт нового сервиса
import '../../services/sync_service_impl.dart';


part 'sync_providers.g.dart'; // Убедитесь, что эта строка есть

// Провайдер для DAO метаданных синхронизации
@riverpod
SyncMetadataDao syncMetadataDao(Ref ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return SyncMetadataDao(databaseService);
}

// Провайдер для сервиса метаданных синхронизации
@Riverpod(keepAlive: true)
SyncMetadataService syncMetadataService(Ref ref) {
  final dao = ref.watch(syncMetadataDaoProvider);
  return SyncMetadataService(dao);
}

// Провайдер для сервиса управления временем последней синхронизации
@Riverpod(keepAlive: true)
LastSyncTimeService lastSyncTimeService(Ref ref) {
  return LastSyncTimeService();
}

// Провайдер для обработчика категорий (может быть нужен отдельно или использоваться только внутри SyncServiceImpl)
@riverpod
CategorySyncHandler categorySyncHandler(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  final database = ref.watch(appDatabaseProvider);
  final metadataService = ref.watch(syncMetadataServiceProvider);

  return CategorySyncHandler(
    firestore: firestore,
    localDatabase: database,
    syncMetadataService: metadataService,
  );
}

// TODO: Добавить провайдеры для TagSyncHandler и TaskSyncHandler по аналогии, если они нужны вне SyncServiceImpl

@Riverpod(keepAlive: true)
ISyncService syncService(Ref ref) { // Имя аргумента ref изменено для соответствия генерации
  final firestore = ref.watch(firestoreProvider);
  final database = ref.watch(appDatabaseProvider);
  final metadataService = ref.watch(syncMetadataServiceProvider);
  // Получаем новый сервис времени последней синхронизации
  final lastSyncTimeSvc = ref.watch(lastSyncTimeServiceProvider); // <-- Получаем новый сервис

  // Создаем экземпляр SyncServiceImpl, передавая все зависимости
  final service = SyncServiceImpl(
    firestore: firestore,
    localDatabase: database,
    syncMetadataService: metadataService,
    lastSyncTimeService: lastSyncTimeSvc, // <-- Передаем новый сервис
    // TODO: Передать остальные зависимости (NetworkStatusService и т.д.), когда они будут готовы
    // networkStatusService: ref.watch(networkStatusServiceProvider), // Пример
  );

  // Очищаем ресурсы сервиса (например, закрываем StreamController) при уничтожении провайдера
  ref.onDispose(() {
    service.dispose(); // Вызываем метод dispose у сервиса
    print("[INFO] SyncServiceProvider disposed, SyncServiceImpl resources released.");
  });

  print("[INFO] SyncServiceProvider: SyncServiceImpl instance created.");
  return service;
}
// Провайдер для Stream состояния синхронизации
@riverpod
Stream<SyncStatusInfo> syncStatusStream(Ref ref) { // Имя аргумента ref изменено
  final syncServiceInstance = ref.watch(syncServiceProvider);
  return syncServiceInstance.getSyncStatusStream();
}