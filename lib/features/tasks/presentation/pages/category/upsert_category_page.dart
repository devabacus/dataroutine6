import 'package:dataroutine6/features/tasks/domain/entities/category.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class UpsertCategoryPage extends ConsumerStatefulWidget {
  final bool isEditing;

  const UpsertCategoryPage({this.isEditing = false, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditItemPageState();
}

class _EditItemPageState extends ConsumerState<UpsertCategoryPage> {
  TextEditingController controller = TextEditingController();
  late int categoryId; //если в режиме редактирования
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedCateg = ref.read(categorySelectedProvider)!;
      setState(() {
        controller.text = selectedCateg.title;
        categoryId = selectedCateg.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final categContr = ref.read(categoriesProvider.notifier);

    return Scaffold(
      body: Form(
        key: key,
        child: Column(
          children: [
            TextFieldFactory.createBasic(controller),
            AppGap.l(),
            ElevatedButton(
              style: AppButtonStyle.basicStyle,
              onPressed: () {
                final selectedCateg = ref.read(categorySelectedProvider);

                if (widget.isEditing) {
                  categContr.updateCategory(
                    selectedCateg!.copyWith(title: controller.text),
                  );
                } else {
                  categContr.addCategory(
                    CategoryEntity(id: -1, title: controller.text),
                  );
                }

                return context.goNamed(
                  TasksRoutes.viewCategory,
                  pathParameters: {TasksRoutes.isFromTask: "0"},
                );
              },
              child: Text(widget.isEditing ? "Обновить" : "Сохранить"),
            ),
          ],
        ),
      ),
    );
  }
}
