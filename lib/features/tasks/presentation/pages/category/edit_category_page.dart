import 'package:dataroutine6/features/tasks/domain/entities/category.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class EditCategoryPage extends ConsumerStatefulWidget {
  final String categoryId;
  const EditCategoryPage({required this.categoryId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditItemPageState();
}

class _EditItemPageState extends ConsumerState<EditCategoryPage> {
  TextEditingController controller = TextEditingController();
  late int categoryId;
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    categoryId = int.parse(widget.categoryId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategory();
    });
  }

  void _loadCategory() async {
    final categories = await ref.read(categoriesProvider.future);
    final category = categories.firstWhere((cat) => cat.id == categoryId);

    setState(() {
      controller.text = category.title;
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
                categContr.updateCategory(
                  CategoryEntity(id: categoryId, title: controller.text),
                );
                return context.goNamed(TasksRoutes.viewCategory);
              },
              child: Text("Сохранить"),
            ),
          ],
        ),
      ),
    );
  }
}
