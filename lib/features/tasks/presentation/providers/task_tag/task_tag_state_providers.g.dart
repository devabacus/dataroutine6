// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_tag_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskTagsHash() => r'bee84e71521f49e55409dec07c79e2c6d9938b79';

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

abstract class _$TaskTags
    extends BuildlessAutoDisposeAsyncNotifier<List<TagEntity>> {
  late final String taskId;

  FutureOr<List<TagEntity>> build({required String taskId});
}

/// See also [TaskTags].
@ProviderFor(TaskTags)
const taskTagsProvider = TaskTagsFamily();

/// See also [TaskTags].
class TaskTagsFamily extends Family<AsyncValue<List<TagEntity>>> {
  /// See also [TaskTags].
  const TaskTagsFamily();

  /// See also [TaskTags].
  TaskTagsProvider call({required String taskId}) {
    return TaskTagsProvider(taskId: taskId);
  }

  @override
  TaskTagsProvider getProviderOverride(covariant TaskTagsProvider provider) {
    return call(taskId: provider.taskId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskTagsProvider';
}

/// See also [TaskTags].
class TaskTagsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TaskTags, List<TagEntity>> {
  /// See also [TaskTags].
  TaskTagsProvider({required String taskId})
    : this._internal(
        () => TaskTags()..taskId = taskId,
        from: taskTagsProvider,
        name: r'taskTagsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$taskTagsHash,
        dependencies: TaskTagsFamily._dependencies,
        allTransitiveDependencies: TaskTagsFamily._allTransitiveDependencies,
        taskId: taskId,
      );

  TaskTagsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final String taskId;

  @override
  FutureOr<List<TagEntity>> runNotifierBuild(covariant TaskTags notifier) {
    return notifier.build(taskId: taskId);
  }

  @override
  Override overrideWith(TaskTags Function() create) {
    return ProviderOverride(
      origin: this,
      override: TaskTagsProvider._internal(
        () => create()..taskId = taskId,
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
  AutoDisposeAsyncNotifierProviderElement<TaskTags, List<TagEntity>>
  createElement() {
    return _TaskTagsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskTagsProvider && other.taskId == taskId;
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
mixin TaskTagsRef on AutoDisposeAsyncNotifierProviderRef<List<TagEntity>> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _TaskTagsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TaskTags, List<TagEntity>>
    with TaskTagsRef {
  _TaskTagsProviderElement(super.provider);

  @override
  String get taskId => (origin as TaskTagsProvider).taskId;
}

String _$tasksWithTagHash() => r'56b615e4f2969f10866c19d503b42b2b17bd35ac';

abstract class _$TasksWithTag
    extends BuildlessAutoDisposeAsyncNotifier<List<TaskEntity>> {
  late final String tagId;

  FutureOr<List<TaskEntity>> build({required String tagId});
}

/// See also [TasksWithTag].
@ProviderFor(TasksWithTag)
const tasksWithTagProvider = TasksWithTagFamily();

/// See also [TasksWithTag].
class TasksWithTagFamily extends Family<AsyncValue<List<TaskEntity>>> {
  /// See also [TasksWithTag].
  const TasksWithTagFamily();

  /// See also [TasksWithTag].
  TasksWithTagProvider call({required String tagId}) {
    return TasksWithTagProvider(tagId: tagId);
  }

  @override
  TasksWithTagProvider getProviderOverride(
    covariant TasksWithTagProvider provider,
  ) {
    return call(tagId: provider.tagId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tasksWithTagProvider';
}

/// See also [TasksWithTag].
class TasksWithTagProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<TasksWithTag, List<TaskEntity>> {
  /// See also [TasksWithTag].
  TasksWithTagProvider({required String tagId})
    : this._internal(
        () => TasksWithTag()..tagId = tagId,
        from: tasksWithTagProvider,
        name: r'tasksWithTagProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$tasksWithTagHash,
        dependencies: TasksWithTagFamily._dependencies,
        allTransitiveDependencies:
            TasksWithTagFamily._allTransitiveDependencies,
        tagId: tagId,
      );

  TasksWithTagProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tagId,
  }) : super.internal();

  final String tagId;

  @override
  FutureOr<List<TaskEntity>> runNotifierBuild(covariant TasksWithTag notifier) {
    return notifier.build(tagId: tagId);
  }

  @override
  Override overrideWith(TasksWithTag Function() create) {
    return ProviderOverride(
      origin: this,
      override: TasksWithTagProvider._internal(
        () => create()..tagId = tagId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tagId: tagId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TasksWithTag, List<TaskEntity>>
  createElement() {
    return _TasksWithTagProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksWithTagProvider && other.tagId == tagId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tagId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TasksWithTagRef on AutoDisposeAsyncNotifierProviderRef<List<TaskEntity>> {
  /// The parameter `tagId` of this provider.
  String get tagId;
}

class _TasksWithTagProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<TasksWithTag, List<TaskEntity>>
    with TasksWithTagRef {
  _TasksWithTagProviderElement(super.provider);

  @override
  String get tagId => (origin as TasksWithTagProvider).tagId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
