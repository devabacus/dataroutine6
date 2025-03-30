import 'package:dataroutine6/features/tasks/domain/entities/category.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddItemPage extends ConsumerStatefulWidget {
  const AddItemPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddItemPageState();
}

class _AddItemPageState extends ConsumerState<AddItemPage> {
  TextEditingController titleController = TextEditingController();
  final formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final categContr = ref.read(categoriesProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Add item")),
      body: Center(
        child: Form(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Название категории",
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  categContr.addCategory(
                    CategoryEntity(id: -1, title: titleController.text),
                  );
                },
                child: Text("Сохранить"),
              ),
              ElevatedButton(
                onPressed: () => context.goNamed(TasksRoutes.viewTable),
                child: Text("Показать все категории"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
