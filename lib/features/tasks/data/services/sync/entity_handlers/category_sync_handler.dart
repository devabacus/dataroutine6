import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' show InsertMode;

import '../../../../../../core/database/local/database.dart';
import '../../../../../../core/database/local/service/drift_database_service.dart';
import '../../../../domain/entities/sync/sync_metadata.dart';
// Используем указанный вами импорт
import '../../../datasources/local/dao/category_dao.dart';
import 'base_entity_handler.dart';

// Константа для поля времени последнего обновления в Firestore
const String firestoreLastUpdatedField = 'lastUpdated';

class CategorySyncHandler
    extends BaseEntitySyncHandler<CategoryTableData, Map<String, dynamic>> {
  late final CategoryDao _categoryDao;

  CategorySyncHandler({
    required super.firestore,
    required super.localDatabase,
    required super.syncMetadataService,
  }) {
    // Используем обертку для IDatabaseService
    _categoryDao = CategoryDao(DriftDatabaseService(localDatabase));
  }

  @override
  EntityType get entityType => EntityType.category;

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference =>
      firestore.collection('categories');

  // --- Реализация абстрактных методов ---

  @override
  Future<CategoryTableData?> getLocalEntity(String id) async {
    try {
      final intId = int.parse(id);
      return await _categoryDao.getCategoryById(intId);
    } on FormatException catch (e, s) {
      print('[ERROR] CategorySyncHandler: Invalid ID format for local category: $id\nError: $e\nStackTrace: $s');
      return null;
    } catch (e, s) {
      print('[ERROR] CategorySyncHandler: Error fetching local category entity: $id\nError: $e\nStackTrace: $s');
      return null;
    }
  }

  @override
  Map<String, dynamic> mapLocalToRemote(CategoryTableData localData) {
    return {
      'title': localData.title,
      firestoreLastUpdatedField: FieldValue.serverTimestamp(),
    };
  }

  @override
  Future<CategoryTableData> mapRemoteToLocal(
    String docId,
    Map<String, dynamic> remoteData,
  ) async {
    final localId = int.tryParse(docId);
    if (localId == null) {
      final errorMsg = "Invalid document ID format from Firestore: $docId";
      print('[ERROR] CategorySyncHandler: $errorMsg');
      throw FormatException(errorMsg);
    }
    final title = remoteData['title'] as String? ?? 'Untitled Category';
    return CategoryTableData(id: localId, title: title);
  }

  @override
  Future<List<SyncMetadata>> fetchRemoteChanges(DateTime? lastSyncTime) async {
    try {
      print('[DEBUG] CategorySyncHandler: Fetching remote changes for Categories since: $lastSyncTime');
      Query<Map<String, dynamic>> query = collectionReference;

      if (lastSyncTime != null) {
        query = query.where(
          firestoreLastUpdatedField,
          isGreaterThan: Timestamp.fromDate(lastSyncTime),
        );
      } else {
        print('[DEBUG] CategorySyncHandler: No lastSyncTime provided, fetching all categories.');
      }

      final snapshot = await query.get();
      print('[INFO] CategorySyncHandler: Fetched ${snapshot.docs.length} remote category changes.');

      final changes = <SyncMetadata>[];
      for (final doc in snapshot.docs) {
        final remoteTimestamp = doc.data()[firestoreLastUpdatedField] as Timestamp?;
        if (remoteTimestamp == null) {
          print('[WARNING] CategorySyncHandler: Category document ${doc.id} missing "$firestoreLastUpdatedField" field. Skipping.');
          continue;
        }

        final remoteUpdateTime = remoteTimestamp.toDate();
        final entityId = doc.id;
        final action = SyncAction.update;

        final metadata = SyncMetadata(
          id: '${entityType.name}_${entityId}_remote',
          entityId: entityId,
          entityType: entityType,
          action: action,
          status: SyncStatus.pending,
          lastLocalUpdate: remoteUpdateTime,
          additionalData: {'source': 'remote', 'remoteData': doc.data()},
        );
        changes.add(metadata);
      }
      return changes;
    } catch (e, s) {
      print('[ERROR] CategorySyncHandler: Error fetching remote category changes\nError: $e\nStackTrace: $s');
      return [];
    }
  }

   @override
  Future<void> applyRemoteChange(
    SyncMetadata metadata,
    Map<String, dynamic> remoteData,
  ) async {
    final entityId = metadata.entityId;
    print('[DEBUG] CategorySyncHandler: Applying remote change for category $entityId, action: ${metadata.action}');

    final localId = int.tryParse(entityId);
    if (localId == null) {
       final errorMsg = 'Invalid entity ID format during applyRemoteChange: $entityId';
       print('[ERROR] CategorySyncHandler: $errorMsg');
       throw FormatException(errorMsg);
    }

    try {
      if (metadata.action == SyncAction.delete) {
        await _categoryDao.deleteCategory(localId);
        print('[INFO] CategorySyncHandler: Deleted local category $localId based on remote change.');
        await syncMetadataService.deleteMetadataByEntity(entityId, entityType);
      } else {
        final localEntity = await mapRemoteToLocal(entityId, remoteData);
        await localDatabase.into(localDatabase.categoryTable).insert(
              localEntity.toCompanion(false),
              mode: InsertMode.insertOrReplace,
            );
        print('[INFO] CategorySyncHandler: Upserted local category $entityId from remote change.');
        await syncMetadataService.deleteMetadataByEntity(entityId, entityType);
      }
    } catch (e, s) {
       print('[ERROR] CategorySyncHandler: Error applying remote change for category $entityId\nError: $e\nStackTrace: $s');
       // Повторно выбрасываем исключение, чтобы вызывающий код знал об ошибке
       throw Exception('Failed to apply remote change for category $entityId: $e');
    }
  }

  @override
  Future<List<SyncMetadata>> getPendingLocalChanges() async {
    print('[DEBUG] CategorySyncHandler: Getting pending local changes for Categories');
    final allPending = await syncMetadataService.getPendingChanges();
    return allPending.where((meta) => meta.entityType == entityType).toList();
  }

  @override
  Future<void> pushLocalChange(SyncMetadata metadata, CategoryTableData? localData) async {
    print('[DEBUG] CategorySyncHandler: Pushing local change for category ${metadata.entityId}, action: ${metadata.action}');
    final docRef = collectionReference.doc(metadata.entityId);
    final now = DateTime.now();

    try {
      if (metadata.action == SyncAction.delete) {
        await docRef.delete();
        print('[INFO] CategorySyncHandler: Deleted remote category ${metadata.entityId}');
        await syncMetadataService.deleteMetadata(metadata.id);
      } else {
        if (localData == null) {
           throw ArgumentError('Local data cannot be null for create/update actions.');
        }
        final remoteData = mapLocalToRemote(localData);
        await docRef.set(remoteData, SetOptions(merge: true));
        print('[INFO] CategorySyncHandler: Pushed local category ${metadata.entityId} to remote.');
        await markAsSynced(metadata, now);
      }
    } catch (e, s) {
      print('[ERROR] CategorySyncHandler: Error pushing category ${metadata.entityId} change\nError: $e\nStackTrace: $s');
      await markAsError(metadata, e.toString());
      // Повторно выбрасываем исключение, чтобы внешний код знал об ошибке отправки
      // throw Exception('Failed to push category ${metadata.entityId}: $e');
      // Или можно не выбрасывать, а просто пометить как ошибку и продолжить с другими
    }
  }

  @override
  Future<void> resolveConflict(
    SyncMetadata localMetadata,
    CategoryTableData? localData,
    Map<String, dynamic>? remoteData,
  ) async {
    print('[WARNING] CategorySyncHandler: Conflict detected for category ${localMetadata.entityId}. Applying "Last Write Wins" strategy.');

    final remoteTimestamp = remoteData?[firestoreLastUpdatedField] as Timestamp?;
    final remoteUpdateTime = remoteTimestamp?.toDate();

    // Случай 1: Нет времени у удаленной записи
    if (remoteData != null && remoteUpdateTime == null) {
       print('[WARNING] CategorySyncHandler: Remote data for category ${localMetadata.entityId} exists but has no timestamp. Assuming local wins.');
       if (localMetadata.action == SyncAction.delete) {
          await pushLocalChange(localMetadata.copyWith(status: SyncStatus.pending), null);
       } else if (localData != null) {
          await pushLocalChange(localMetadata.copyWith(status: SyncStatus.pending), localData);
       } else {
          print('[ERROR] CategorySyncHandler: Conflict resolution error: Local data is null but action is not delete for ${localMetadata.entityId}');
          await syncMetadataService.deleteMetadata(localMetadata.id);
       }
       return;
    }

    // Случай 2: Удаленные данные новее или равны локальным
    if (remoteUpdateTime != null && remoteUpdateTime.isAfterOrSame(localMetadata.lastLocalUpdate)) {
      print('[INFO] CategorySyncHandler: Conflict resolution: Remote wins for category ${localMetadata.entityId}.');
      if (remoteData != null) {
         print('[INFO] CategorySyncHandler: Applying remote change locally.');
        // Оборачиваем в try-catch на случай ошибки применения
        try {
          await applyRemoteChange(localMetadata.copyWith(action: SyncAction.update), remoteData);
          await markAsSynced(localMetadata, DateTime.now());
        } catch (e) {
           print('[ERROR] CategorySyncHandler: Failed to apply winning remote change for ${localMetadata.entityId}: $e');
           await markAsError(localMetadata, 'Failed to apply winning remote change: $e');
        }
      } else {
        print('[INFO] CategorySyncHandler: Applying remote delete locally.');
        try {
          await applyRemoteChange(localMetadata.copyWith(action: SyncAction.delete), {});
          // Метаданные удаляются внутри applyRemoteChange
        } catch (e) {
           print('[ERROR] CategorySyncHandler: Failed to apply winning remote delete for ${localMetadata.entityId}: $e');
           // Здесь не нужно помечать метаданные как ошибочные, т.к. они уже удалены
           // или будут удалены при следующей попытке applyRemoteChange
        }
      }
    }
    // Случай 3: Локальные данные новее
    else {
       print('[INFO] CategorySyncHandler: Conflict resolution: Local wins for category ${localMetadata.entityId}. Pushing local change.');
        if (localMetadata.action == SyncAction.delete) {
           print('[INFO] CategorySyncHandler: Pushing local delete.');
           await pushLocalChange(localMetadata.copyWith(status: SyncStatus.pending), null);
        }
       else if (localData != null) {
          print('[INFO] CategorySyncHandler: Pushing local update/create.');
          await pushLocalChange(localMetadata.copyWith(status: SyncStatus.pending), localData);
       } else {
         final errorMsg = 'Local data is newer but null, and action is not delete for ${localMetadata.entityId}';
         print('[ERROR] CategorySyncHandler: Conflict resolution error: $errorMsg');
         await markAsError(localMetadata, 'Local data missing for winning local change.');
       }
    }
  }
}

/// Расширение для удобного сравнения дат.
extension DateTimeComparison on DateTime {
  /// Проверяет, находится ли эта дата после или в тот же момент времени, что и [other].
  bool isAfterOrSame(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }
}