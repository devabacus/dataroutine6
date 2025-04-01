// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_tag_for_task_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredTagsForTaskHash() =>
    r'7f597ce05a0f6ba2e28cdabf62df0626e5a4dfb9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [filteredTagsForTask].
@ProviderFor(filteredTagsForTask)
const filteredTagsForTaskProvider = FilteredTagsForTaskFamily();

/// See also [filteredTagsForTask].
class FilteredTagsForTaskFamily extends Family<AsyncValue<List<TagEntity>>> {
  /// See also [filteredTagsForTask].
  const FilteredTagsForTaskFamily();

  /// See also [filteredTagsForTask].
  FilteredTagsForTaskProvider call(int? taskId) {
    return FilteredTagsForTaskProvider(taskId);
  }

  @override
  FilteredTagsForTaskProvider getProviderOverride(
    covariant FilteredTagsForTaskProvider provider,
  ) {
    return call(provider.taskId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredTagsForTaskProvider';
}

/// See also [filteredTagsForTask].
class FilteredTagsForTaskProvider
    extends AutoDisposeFutureProvider<List<TagEntity>> {
  /// See also [filteredTagsForTask].
  FilteredTagsForTaskProvider(int? taskId)
    : this._internal(
        (ref) => filteredTagsForTask(ref as FilteredTagsForTaskRef, taskId),
        from: filteredTagsForTaskProvider,
        name: r'filteredTagsForTaskProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$filteredTagsForTaskHash,
        dependencies: FilteredTagsForTaskFamily._dependencies,
        allTransitiveDependencies:
            FilteredTagsForTaskFamily._allTransitiveDependencies,
        taskId: taskId,
      );

  FilteredTagsForTaskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final int? taskId;

  @override
  Override overrideWith(
    FutureOr<List<TagEntity>> Function(FilteredTagsForTaskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredTagsForTaskProvider._internal(
        (ref) => create(ref as FilteredTagsForTaskRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TagEntity>> createElement() {
    return _FilteredTagsForTaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredTagsForTaskProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredTagsForTaskRef on AutoDisposeFutureProviderRef<List<TagEntity>> {
  /// The parameter `taskId` of this provider.
  int? get taskId;
}

class _FilteredTagsForTaskProviderElement
    extends AutoDisposeFutureProviderElement<List<TagEntity>>
    with FilteredTagsForTaskRef {
  _FilteredTagsForTaskProviderElement(super.provider);

  @override
  int? get taskId => (origin as FilteredTagsForTaskProvider).taskId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
