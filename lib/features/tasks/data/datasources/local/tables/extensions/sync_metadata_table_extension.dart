import 'package:drift/drift.dart';
import '../../../../../../../core/database/local/database.dart';
import '../../../../models/sync/sync_metadata_model.dart';

extension SyncMetadataTableDataExtension on SyncMetadataTableData {
  SyncMetadataModel toModel() => SyncMetadataModel(
    id: id,
    entityId: entityId,
    entityType: entityType,
    action: action,
    lastLocalUpdate: lastLocalUpdate,
    lastSyncTime: lastSyncTime,
    status: status,
    errorMessage: errorMessage,
    retryCount: retryCount,
    additionalData: additionalData,
  );
}

extension SyncMetadataTableDataListExtension on List<SyncMetadataTableData> {
  List<SyncMetadataModel> toModels() => map((data) => data.toModel()).toList();
}

extension SyncMetadataModelCompanionExtension on SyncMetadataModel {
  SyncMetadataTableCompanion toCompanion() => SyncMetadataTableCompanion(
    id: Value(id),
    entityId: Value(entityId),
    entityType: Value(entityType),
    action: Value(action),
    lastLocalUpdate: Value(lastLocalUpdate),
    lastSyncTime: Value(lastSyncTime),
    status: Value(status),
    errorMessage: Value(errorMessage),
    retryCount: Value(retryCount),
    additionalData: Value(additionalData),
  );
}