import 'package:dataroutine6/features/tasks/domain/entities/tag.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/drawer.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/tag/tag_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task_tag/filter_tag_for_task_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/task_tag/task_tag_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../providers/delete_select_provider.dart';

class ViewTagPage extends ConsumerWidget {
  final bool isForTaskSelection;
  final int? taskId;

  const ViewTagPage({this.isForTaskSelection = false, this.taskId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTags = ref.watch(filteredTagsForTaskProvider(taskId));
    final deleteState = ref.watch(deleteSelectProvider);
    final deleteContr = ref.read(deleteSelectProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(isForTaskSelection ? "Выберите тэг" : "Тэги")),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: filteredTags.when(
                data: (tags) {
                  return ListView.builder(
                    itemCount: tags.length,
                    itemBuilder: (context, index) {
                      final tagTitle = tags[index].title;
                      final tagId = tags[index].id;
                      return ListTile(
                        title: Text(tagTitle),
                        trailing: Text(tagId.toString()),
                        onTap: () {
                          if (isForTaskSelection && taskId != null) {
                            ref
                                .read(
                                  taskTagsProvider(taskId: taskId!).notifier,
                                )
                                .addTagToTask(taskId!, tagId);
                            context.goNamed(TasksRoutes.editTask);
                          } else {
                            final selectedTag = ref.read(
                              tagSelectedProvider.notifier,
                            );
                            selectedTag.setTag(
                              TagEntity(id: tagId, title: tagTitle),
                            );
                            context.goNamed(TasksRoutes.updateTag);
                          }
                        },
                      );
                    },
                  );
                },
                error: (error, __) => Text("Error: $error"),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
            AppGap.m(),
            ElevatedButton(
              style: AppButtonStyle.basicStyle,
              onPressed: () => context.goNamed(TasksRoutes.addTag),
              child: Text("Добавить тэг"),
            ),
            AppGap.m(),
          ],
        ),
      ),
    );
  }
}
