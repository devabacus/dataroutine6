import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Базовые зависимости
import '../../../../../core/database/local/provider/database_provider.dart';
import '../../../domain/entities/sync/sync_status_info.dart';
import '../../../domain/services/sync_service.dart'; // Интерфейс ISyncService
// DAO и Сервисы синхронизации
import '../../datasources/local/dao/sync_metadata_dao.dart';
import '../../services/sync/entity_handlers/category_sync_handler.dart';
import '../../services/sync/sync_metadata_service.dart';
import '../../services/sync_service_impl.dart';
import '../remote/remote_data_providers.dart'; // Для firestoreProvider

// TODO: Импортировать другие обработчики (Tag, Task), когда они будут созданы

part 'sync_providers.g.dart';

// Провайдер для DAO метаданных синхронизации
@riverpod
SyncMetadataDao syncMetadataDao(Ref ref) {
  // Используем существующий databaseServiceProvider из core
  final databaseService = ref.watch(databaseServiceProvider);
  return SyncMetadataDao(databaseService);
}

// Провайдер для сервиса метаданных синхронизации
// keepAlive: true, так как сервис может использоваться фоновыми задачами
@Riverpod(keepAlive: true)
SyncMetadataService syncMetadataService(Ref ref) {
  final dao = ref.watch(syncMetadataDaoProvider);
  return SyncMetadataService(dao);
}

// Провайдер для обработчика категорий
// Можно сделать keepAlive: true, если он будет использоваться долгоживущими процессами,
// но пока оставим autoDispose, т.к. он в основном используется внутри SyncServiceImpl.
@riverpod
CategorySyncHandler categorySyncHandler(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  // SyncServiceImpl ожидает AppDatabase, получаем его
  final database = ref.watch(appDatabaseProvider);
  final metadataService = ref.watch(syncMetadataServiceProvider);

  return CategorySyncHandler(
    firestore: firestore,
    localDatabase: database,
    syncMetadataService: metadataService,
    // Передаем print в качестве заглушки для логгера
    // log: print,
  );
}

// TODO: Добавить провайдеры для TagSyncHandler и TaskSyncHandler по аналогии

// Основной провайдер сервиса синхронизации
// keepAlive: true, так как сервис управляет фоновыми процессами и состоянием
@Riverpod(keepAlive: true)
ISyncService syncService(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  final database = ref.watch(appDatabaseProvider);
  final metadataService = ref.watch(syncMetadataServiceProvider);
  // Получаем конкретные обработчики через их провайдеры
  // final categoryHandler = ref.watch(categorySyncHandlerProvider);
  // TODO: Получить другие обработчики, когда они будут готовы

  // Создаем экземпляр SyncServiceImpl
  // Он сам внутри зарегистрирует нужные обработчики (пока только Category)
  return SyncServiceImpl(
    firestore: firestore,
    localDatabase: database,
    syncMetadataService: metadataService,
    // TODO: Передать остальные зависимости (NetworkStatusService и т.д.), когда они будут готовы
  );
  // Примечание: SyncServiceImpl сам создает CategorySyncHandler внутри себя.
  // Если бы мы хотели передать уже созданные хендлеры, нужно было бы изменить конструктор SyncServiceImpl
  // и передавать их так:
  // final categoryHandler = ref.watch(categorySyncHandlerProvider);
  // return SyncServiceImpl(..., handlers: {EntityType.category: categoryHandler, ...});
}

// Провайдер для Stream состояния синхронизации (удобно для UI)
@riverpod
Stream<SyncStatusInfo> syncStatusStream(Ref ref) {
  // Получаем основной сервис синхронизации
  final syncService = ref.watch(syncServiceProvider);
  // Возвращаем его поток состояния
  return syncService.getSyncStatusStream();
}