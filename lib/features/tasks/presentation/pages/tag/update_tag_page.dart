import 'package:dataroutine6/features/tasks/domain/entities/tag.dart';
import 'package:dataroutine6/features/tasks/presentation/providers/tag/tag_state_providers.dart';
import 'package:dataroutine6/features/tasks/presentation/routing/tasks_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class UpdateTagPage extends ConsumerStatefulWidget {
  final String tagId;

  const UpdateTagPage({required this.tagId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateTagPageState();
}

class _UpdateTagPageState extends ConsumerState<UpdateTagPage> {
  TextEditingController controller = TextEditingController();

  late int tagId;

  @override
  void initState() {
    super.initState();
    tagId = int.parse(widget.tagId);
       WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTags();
    });
      }

  void _loadTags() async {
    final tags = await ref.watch(tagProvider.future);
    final currentTag = tags.firstWhere((tag) => tag.id == tagId).title.toString();

    setState(() {
      controller.text = currentTag;

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
                tagContr.updateTag(TagEntity(id: tagId, title: controller.text));
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
