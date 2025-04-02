// lib/features/tasks/presentation/pages/view_tag_page.dart

import 'package:chopper/chopper.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/entity_list_page.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/tag/tag_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/tag/tag_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task_tag/filter_tag_for_task_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task_tag/task_tag_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ViewTagPage extends ConsumerWidget {
  final bool isForTaskSelection;
  final int? taskId;

  const ViewTagPage({this.isForTaskSelection = false, this.taskId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTags = ref.watch(filteredTagsForTaskProvider(taskId));
    final tagContr = ref.read(tagProvider.notifier);

    return EntityListPage(
      config: EntityListConfig(
        title: isForTaskSelection ? "Выберите тэг" : "Тэги",
        addButtonText: "Добавить тэг",
        addRouteName: TasksRoutes.addTag,
        editRouteName: TasksRoutes.updateTag,
        dataProvider: filteredTags,
        onItemTap: (tag) {
          if (isForTaskSelection && taskId != null) {
            ref
                .read(taskTagsProvider(taskId: taskId!).notifier)
                .addTagToTask(taskId!, tag.id);
            context.goNamed(TasksRoutes.editTask);
          } else {
            ref.read(tagSelectedProvider.notifier).setTag(tag);
            context.goNamed(TasksRoutes.updateTag);
          }
        },
        itemBuilder:
            (context, tag, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(tag.title)],
            ),
        onItemDelete: (tag) => tagContr.deleteTag(tag.id),
      ),
    );
  }
}
