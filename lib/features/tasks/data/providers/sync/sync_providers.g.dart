// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncMetadataDaoHash() => r'af6049de8928515eb7c8c7857dca8b7ae711ffd9';

/// See also [syncMetadataDao].
@ProviderFor(syncMetadataDao)
final syncMetadataDaoProvider = AutoDisposeProvider<SyncMetadataDao>.internal(
  syncMetadataDao,
  name: r'syncMetadataDaoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncMetadataDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncMetadataDaoRef = AutoDisposeProviderRef<SyncMetadataDao>;
String _$syncMetadataServiceHash() =>
    r'40df055de4bec652d9dc693bf9fa43a03a2f8239';

/// See also [syncMetadataService].
@ProviderFor(syncMetadataService)
final syncMetadataServiceProvider = Provider<SyncMetadataService>.internal(
  syncMetadataService,
  name: r'syncMetadataServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncMetadataServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncMetadataServiceRef = ProviderRef<SyncMetadataService>;
String _$categorySyncHandlerHash() =>
    r'739ad73c45de3a698f6c47c1999e044711cdac0f';

/// See also [categorySyncHandler].
@ProviderFor(categorySyncHandler)
final categorySyncHandlerProvider =
    AutoDisposeProvider<CategorySyncHandler>.internal(
      categorySyncHandler,
      name: r'categorySyncHandlerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$categorySyncHandlerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategorySyncHandlerRef = AutoDisposeProviderRef<CategorySyncHandler>;
String _$syncServiceHash() => r'3a48ce9386ba6fc4cc679c686d8b3f8ff8c8ed4d';

/// See also [syncService].
@ProviderFor(syncService)
final syncServiceProvider = Provider<ISyncService>.internal(
  syncService,
  name: r'syncServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncServiceRef = ProviderRef<ISyncService>;
String _$syncStatusStreamHash() => r'29be9b84a7e08beee092e2e9d5787220211d4ad8';

/// See also [syncStatusStream].
@ProviderFor(syncStatusStream)
final syncStatusStreamProvider =
    AutoDisposeStreamProvider<SyncStatusInfo>.internal(
      syncStatusStream,
      name: r'syncStatusStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$syncStatusStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncStatusStreamRef = AutoDisposeStreamProviderRef<SyncStatusInfo>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
