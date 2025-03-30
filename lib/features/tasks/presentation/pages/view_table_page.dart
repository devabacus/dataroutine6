import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import '../providers/tasks_navigation_provider.dart';

final tStyle = TextStyle(fontSize: 20);

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
                data: (categ) {
                  return ListView.builder(
                    itemCount: categ.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(categ[index].title, style: tStyle),
                        trailing: Text(categ[index].id.toString()),
                        onTap: () {
                          print("tap on the item");
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
          ],
        ),
      ),
    );
  }
}
