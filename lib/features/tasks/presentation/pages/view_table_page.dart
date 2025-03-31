import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mlogger/mlogger.dart';
import 'package:ui_kit/ui_kit.dart';
// import '../providers/tasks_navigation_provider.dart';

final tStyle = TextStyle(fontSize: 15);

class ViewTablePage extends ConsumerWidget {
  const ViewTablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final tasksNavService = ref.read(tasksNavigationServiceProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text("data", style: TextStyle(fontSize: 20))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: categories.when(
                data: (categories) {
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(categories[index].title, style: tStyle),
                        trailing: Text(categories[index].id.toString()),
                        onTap: () {
                          context.goNamed(
                            TasksRoutes.editItem,
                            pathParameters: {
                              'categoryId': categories[index].id.toString(),
                            },
                          );
                        },
                      );
                    },
                  );
                },
                error: (_, __) => Text("Error"),
                loading: () => CircularProgressIndicator(),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.goNamed(TasksRoutes.addItem),
              child: Text("Добавить категорию"),
            ),
            AppGap.l(),
          ],
        ),
      ),
    );
  }
}
