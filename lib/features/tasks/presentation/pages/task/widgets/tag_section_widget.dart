import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../providers/task_tag/task_tag_state_providers.dart';

class TagSectionWidget extends ConsumerWidget {

  final int? taskId;
  
  final VoidCallback onAddTagPressed;

  const TagSectionWidget(this.onAddTagPressed, {this.taskId,  super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskTag = ref.watch(taskTagsProvider(taskId: taskId!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        taskTag.when(
          data: (tags) {
            return Column(
              children: [
                if (tags.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children:
                        tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag.title),
                                onDeleted: () {
                                  ref
                                      .read(
                                        taskTagsProvider(
                                          taskId: taskId!,
                                        ).notifier,
                                      )
                                      .removeTagFromTask(taskId!, tag.id);
                                },
                              ),
                            )
                            .toList(),
                  ),
                AppGap.s(),
                ButtonFactory.basic(onAddTagPressed, "Добавить тэги"),
              ],
            );
          },
          error: (_, __) => Text("Error"),
          loading: () => CircularProgressIndicator(),
        ),
        AppGap.l(),
      ],
    );
  }
}
