import '../../domain/entities/category/category.dart';
import '../../domain/entities/extensions/category_entity_extension.dart';
import '../../domain/entities/sync/sync_metadata.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/services/sync_service.dart'; // Для автоматической синхронизации
import '../datasources/local/interfaces/category_local_datasource_service.dart';
import '../models/extensions/category_models_extension.dart';
import '../services/sync/sync_metadata_service.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final ICategoryLocalDataSource _localDataSource;
  final SyncMetadataService _syncMetadataService;
  final ISyncService? _syncService; // Опциональный параметр для автосинхронизации

  CategoryRepositoryImpl(
    this._localDataSource, 
    this._syncMetadataService,
    [this._syncService]
  );

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categoryModels = await _localDataSource.getCategories();
    return categoryModels.toEntities();
  }

  @override
  Stream<List<CategoryEntity>> watchCategories() {
    // Слушаем поток от локального источника данных и преобразуем модели в сущности
    return _localDataSource.watchCategories().map((models) => models.toEntities());
  }

  @override
  Future<CategoryEntity> getCategoryById(String id) async {
    final model = await _localDataSource.getCategoryById(id);
    return model.toEntity();
  }

  @override
  Future<String> createCategory(CategoryEntity category) async {
    final localId = await _localDataSource.createCategory(category.toModel());
    
    // Создаем метаданные для синхронизации
    await _syncMetadataService.createOrUpdateMetadata(
      entityId: localId.toString(),
      entityType: EntityType.category,
      action: SyncAction.create,
    );
    
    // Если передан syncService, запускаем автоматическую синхронизацию
    _syncService?.syncEntityType(EntityType.category);
    
    return localId;
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    await _localDataSource.updateCategory(category.toModel());
    
    // Создаем метаданные для синхронизации
    await _syncMetadataService.createOrUpdateMetadata(
      entityId: category.id.toString(),
      entityType: EntityType.category,
      action: SyncAction.update,
    );
    
    // Если передан syncService, запускаем автоматическую синхронизацию
    _syncService?.syncEntityType(EntityType.category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _localDataSource.deleteCategory(id);
    
    // Создаем метаданные для синхронизации
    await _syncMetadataService.createOrUpdateMetadata(
      entityId: id.toString(),
      entityType: EntityType.category,
      action: SyncAction.delete,
    );
    
    // Если передан syncService, запускаем автоматическую синхронизацию
    _syncService?.syncEntityType(EntityType.category);
  }
}
