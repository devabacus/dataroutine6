import 'package:chopper/chopper.dart';
import 'package:dataroutine6/features/tasks/domain/entities/tag.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/tag/tag_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/tag/tag_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class ViewTagPage extends ConsumerWidget {
  const ViewTagPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Тэги")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: tags.when(
                data: (tags) {
                  return ListView.builder(
                    itemCount: tags.length,
                    itemBuilder: (context, index) {
                      final tagTitle = tags[index].title;
                      return ListTile(
                        title: Text(tagTitle),
                        onTap: () {
                          final selectedTag = ref.read(tagSelectedProvider.notifier);
                          selectedTag.setTag(TagEntity(id: tags[index].id, title: tagTitle));
                          context.goNamed(TasksRoutes.updateTag);
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
