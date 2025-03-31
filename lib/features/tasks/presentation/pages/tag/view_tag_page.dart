import 'package:chopper/chopper.dart';
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
                      final tagStr = tags[index].title;
                      return ListTile(
                        title: Text(tagStr),
                        onTap: () {
                          final tagId = tags[index].id.toString();
                          context.goNamed(
                            TasksRoutes.updateTag,
                            pathParameters: {TasksRoutes.tagId: tagId},
                          );
                        },
                      );
                    },
                  );
                },
                error: (error, __) => Text("Error: $error"),
                loading: () => CircularProgressIndicator(),
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
