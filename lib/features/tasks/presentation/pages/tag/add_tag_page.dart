import 'package:dataroutine6/features/tasks/domain/entities/tag.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/tag/tag_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class AddTagPage extends ConsumerStatefulWidget {
  const AddTagPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTagPageState();
}

class _AddTagPageState extends ConsumerState<AddTagPage> {
  GlobalKey key = GlobalKey();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tagContr = ref.read(tagProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Добавить тэг"),),
      body: Form(
        key: key,
        child: Column(
          children: [
            TextFieldFactory.createBasic(controller, hint: "Название тэга"),
            AppGap.m(),
            ElevatedButton(
              style: AppButtonStyle.basicStyle,
              onPressed: () {
                tagContr.addTag(TagEntity(id: -1, title: controller.text));
                context.goNamed(TasksRoutes.viewTag);
              },
              child: Text("Сохранить"),
            ),
          ],
        ),
      ),
    );
  }
}
