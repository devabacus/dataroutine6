import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../domain/entities/category.dart';
import '../../common_widgets/form_controller_mixin.dart';
import '../../common_widgets/upsert_page_base.dart';
import '../../providers/category/category_selected_provider.dart';
import '../../providers/category/category_state_providers.dart';
import '../../routing/tasks_routes_constants.dart';

class UpsertCategoryPage extends BaseUpsertPage<CategoryEntity> {
  const UpsertCategoryPage({super.isEditing = false, super.key});

  @override
  ConsumerState<BaseUpsertPage<CategoryEntity>> createState() =>
      _UpsertCategoryPageState();
}

class _UpsertCategoryPageState
    extends BaseUpsertPageState<CategoryEntity, UpsertCategoryPage>
    with FormControllersMixin<CategoryEntity> {
  int? _categoryId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initializeData() {
    if (widget.isEditing) {
      final selectedCategory = ref.read(categorySelectedProvider);
      if (selectedCategory != null) {
        setState(() {
          setControllerValue('title', selectedCategory.title);
          _categoryId = selectedCategory.id;
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

    final categoryController = ref.read(categoriesProvider.notifier);

    if (widget.isEditing) {
      final selectedCategory = ref.read(categorySelectedProvider);
      if (selectedCategory != null) {
        categoryController.updateCategory(
          selectedCategory.copyWith(title: getControllerValue('title')),
        );
      }
    } else {
      categoryController.addCategory(
        CategoryEntity(id: -1, title: getControllerValue('title')),
      );
    }

    navigateBack();
  }

  @override
  void navigateBack() {
    context.goNamed(
      TasksRoutes.viewCategory,
      pathParameters: {TasksRoutes.isFromTask: "0"},
    );
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        widget.isEditing ? 'Редактирование категории' : 'Новая категория',
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
            labelText: 'Название категории',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите название категории';
              }
              return null;
            },
          ),
          AppGap.l(),
          UpsertFormFactory.createSaveButton(
            saveEntity,
            isEditing: widget.isEditing,
          ),
        ],
      ),
    );
  }
}
