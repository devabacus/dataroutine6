import 'package:dataroutine6/features/tasks/domain/entities/category.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/category/category_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../../utils/extesnsion.dart';

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
          child: SizedBox(
            width: SizeUtils.width(context, 0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldFactory.createBasic(
                  hint: "Название категории",
                  titleController,
                ),
                AppGap.l(),
                ElevatedButton(
                  style: AppButtonStyle.basicStyle,
                  onPressed: () {
                    categContr.addCategory(
                      CategoryEntity(id: -1, title: titleController.text),
                    );
                  },
                  child: Text("Сохранить"),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  style: AppButtonStyle.basicStyle,
                  onPressed: () => context.goNamed(TasksRoutes.viewTable),
                  child: Text("Показать все категории"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
