// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_form_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskFormState _$TaskFormStateFromJson(Map<String, dynamic> json) =>
    _TaskFormState(
      isInitialized: json['isInitialized'] as bool? ?? false,
      taskId: (json['taskId'] as num?)?.toInt(),
      categoryId: (json['categoryId'] as num?)?.toInt(),
      categoryTitle: json['categoryTitle'] as String? ?? '',
      currentTask:
          json['currentTask'] == null
              ? null
              : TaskEntity.fromJson(
                json['currentTask'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$TaskFormStateToJson(_TaskFormState instance) =>
    <String, dynamic>{
      'isInitialized': instance.isInitialized,
      'taskId': instance.taskId,
      'categoryId': instance.categoryId,
      'categoryTitle': instance.categoryTitle,
      'currentTask': instance.currentTask,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskFormStateNotifierHash() =>
    r'84314954e8452e2cc6811d26501ae339ea76e5ee';

/// See also [TaskFormStateNotifier].
@ProviderFor(TaskFormStateNotifier)
final taskFormStateNotifierProvider =
    AutoDisposeNotifierProvider<TaskFormStateNotifier, TaskFormState>.internal(
      TaskFormStateNotifier.new,
      name: r'taskFormStateNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$taskFormStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskFormStateNotifier = AutoDisposeNotifier<TaskFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
