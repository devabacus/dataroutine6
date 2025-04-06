// Конфигурация для страницы списка
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
