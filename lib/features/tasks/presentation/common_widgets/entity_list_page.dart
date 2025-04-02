// lib/features/tasks/presentation/common_widgets/entity_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../common_widgets/drawer.dart';

// Конфигурация для страницы списка
class EntityListConfig<T> {
  final String title;
  final List<Widget> actions;
  final String addButtonText;
  final String addRouteName;
  final String editRouteName;
  final AsyncValue<List<T>> dataProvider;
  final Function(T item) onItemTap;
  final Function(T item)? onItemDelete;
  final Function(BuildContext, T, int) itemBuilder;
  final bool enableLongPressDelete;

  EntityListConfig({
    required this.title,
    this.actions = const [],
    required this.addButtonText,
    required this.addRouteName,
    required this.editRouteName,
    required this.dataProvider,
    required this.onItemTap,
    this.onItemDelete,
    required this.itemBuilder,
    this.enableLongPressDelete = true,
  });
}

class EntityListPage<T> extends ConsumerStatefulWidget {
  final EntityListConfig<T> config;

  const EntityListPage({
    required this.config,
    super.key,
  });

  @override
  ConsumerState<EntityListPage<T>> createState() => _EntityListPageState<T>();
}

class _EntityListPageState<T> extends ConsumerState<EntityListPage<T>> {
  bool _isDeleteMode = false;

  void _toggleDeleteMode() {
    setState(() {
      _isDeleteMode = !_isDeleteMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return Scaffold(
      appBar: AppBar(
        title: Text(config.title),
        actions: config.actions,
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: config.dataProvider.when(
                data: (items) {
                  if (items.isEmpty) {
                    return Center(child: Text("Список пуст"));
                  }
                  
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onLongPress: config.enableLongPressDelete 
                            ? _toggleDeleteMode 
                            : null,
                        child: ListTile(
                          title: config.itemBuilder(context, item, index),
                          onTap: () => config.onItemTap(item),
                          trailing: _isDeleteMode && config.onItemDelete != null
                              ? IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => config.onItemDelete!(item),
                                )
                              : null,
                        ),
                      );
                    },
                  );
                },
                error: (_, __) => Text("Ошибка загрузки данных"),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
            AppGap.m(),
            ButtonFactory.basic(
              () => context.goNamed(config.addRouteName),
              config.addButtonText,
            ),
            AppGap.m(),
          ],
        ),
      ),
    );
  }
}