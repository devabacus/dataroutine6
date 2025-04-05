import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../domain/entities/tag/tag.dart';
import '../../common_widgets/form_controller_mixin.dart';
import '../../common_widgets/upsert_page_base.dart';
import '../../providers/tag/tag_selected_provider.dart';
import '../../providers/tag/tag_state_providers.dart';
import '../../routing/tasks_routes_constants.dart';

class UpsertTagPage extends BaseUpsertPage<TagEntity> {
  const UpsertTagPage({super.isEditing = false, super.key});

  @override
  ConsumerState<BaseUpsertPage<TagEntity>> createState() => _UpsertTagPageState();
}

class _UpsertTagPageState extends BaseUpsertPageState<TagEntity, UpsertTagPage>
    with FormControllersMixin<TagEntity> {
  int? _tagId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initializeData() {
    if (widget.isEditing) {
      final selectedTag = ref.read(tagSelectedProvider);
      if (selectedTag != null) {
        setState(() {
          setControllerValue('title', selectedTag.title);
          _tagId = selectedTag.id;
        });
      }
    }
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  void saveEntity() {
    if (!_formKey.currentState!.validate()) return;

    final tagController = ref.read(tagProvider.notifier);

    if (widget.isEditing) {
      final selectedTag = ref.read(tagSelectedProvider);
      if (selectedTag != null) {
        tagController.updateTag(
          selectedTag.copyWith(title: getControllerValue('title')),
        );
      }
    } else {
      tagController.addTag(
        TagEntity(id: -1, title: getControllerValue('title')),
      );
    }

    navigateBack();
  }

  @override
  void navigateBack() {
    context.goNamed(TasksRoutes.viewTag);
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        widget.isEditing ? 'Редактирование тега' : 'Новый тег',
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: navigateBack,
      ),
    );
  }

  @override
  Widget buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UpsertFormFactory.createBasicFormField(
            getController('title'),
            labelText: 'Название тега',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите название тега';
              }
              return null;
            },
          ),
          AppGap.m(),
          UpsertFormFactory.createSaveButton(
            saveEntity,
            isEditing: widget.isEditing,
          ),
        ],
      ),
    );
  }
}