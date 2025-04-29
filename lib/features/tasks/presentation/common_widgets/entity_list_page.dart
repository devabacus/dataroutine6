import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../common_widgets/drawer.dart';
import 'entity_list_page_config.dart';

class EntityListPage<T> extends ConsumerStatefulWidget {
  final EntityListConfig<T> config;

  const EntityListPage({required this.config, super.key});

  @override
  ConsumerState<EntityListPage<T>> createState() => _EntityListPageState<T>();
}

class _EntityListPageState<T> extends ConsumerState<EntityListPage<T>> {
  bool _isDeleteMode = false;
  int itemForDelete = -1;


  void _toggleDeleteMode(int index) {
    setState(() {
      itemForDelete = index;

      _isDeleteMode = !_isDeleteMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return Scaffold(
      appBar: AppBar(title: Text(config.title), actions: config.actions),
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
                        onLongPress:
                            config.enableLongPressDelete
                                ? () => _toggleDeleteMode(index)
                                : null,
                        child: ListTile(
                          title: config.itemBuilder(context, item, index),
                          onTap: () => config.onItemTap(item),
                          trailing:
                              itemForDelete == index &&
                                      config.onItemDelete != null
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
