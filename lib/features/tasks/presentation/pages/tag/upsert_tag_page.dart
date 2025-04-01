import 'package:dataroutine6/features/tasks/domain/entities/tag.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/tag/tag_selected_provider.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/tag/tag_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class UpserTagPage extends ConsumerStatefulWidget {
  final bool isEditing;

  const UpserTagPage({this.isEditing = false, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateTagPageState();
}

class _UpdateTagPageState extends ConsumerState<UpserTagPage> {
  TextEditingController controller = TextEditingController();

  late int tagId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedTag = ref.read(tagSelectedProvider);
      tagId = selectedTag!.id;
      if (widget.isEditing) {
        setState(() {
        controller.text = selectedTag.title;
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tagContr = ref.read(tagProvider.notifier);
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            TextFieldFactory.createBasic(controller),
            AppGap.m(),
            ElevatedButton(
              style: AppButtonStyle.basicStyle,
              onPressed: () {
                final selectedTag = ref.read(tagSelectedProvider);
                if (widget.isEditing) {
                  tagContr.updateTag(
                    selectedTag!.copyWith(title: controller.text),
                  );
                } else {
                  tagContr.addTag(TagEntity(id: -1, title: controller.text));
                }
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
