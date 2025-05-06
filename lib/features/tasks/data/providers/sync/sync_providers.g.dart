// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncMetadataDaoHash() => r'5803a6b4a8a5d2322e5f6c7793c0018cfaf9cd0c';

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
    r'68d1649b60a1b40ffbee3515366531b4c8591ecf';

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
String _$lastSyncTimeServiceHash() =>
    r'da00ebcb27d6fb48a3fe1edaed264ca32e4c3f12';

/// See also [lastSyncTimeService].
@ProviderFor(lastSyncTimeService)
final lastSyncTimeServiceProvider = Provider<LastSyncTimeService>.internal(
  lastSyncTimeService,
  name: r'lastSyncTimeServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$lastSyncTimeServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LastSyncTimeServiceRef = ProviderRef<LastSyncTimeService>;
String _$categorySyncHandlerHash() =>
    r'6acb092d4820130eb5fe54f07ef5d5713901bdad';

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
String _$syncServiceHash() => r'43fc10f94acefd5e5b6ceed6e837a8bc6b216ec6';

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
String _$syncStatusStreamHash() => r'e1103e74ac5bcdd250fcb06b6b2b9c7801cc2603';

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
