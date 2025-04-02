import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseUpsertPage<T> extends ConsumerStatefulWidget {
  final bool isEditing;

  const BaseUpsertPage({this.isEditing = false, super.key});
}

abstract class BaseUpsertPageState<T, W extends BaseUpsertPage<T>> extends ConsumerState<W> {
  // Общие методы для всех страниц Upsert
  void initializeData();
  void saveEntity();
  void navigateBack();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeData();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildForm(),
      ),
    );
  }
  
  AppBar buildAppBar() {
    return AppBar(
      title: Text(widget.isEditing ? 'Редактирование' : 'Создание'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: navigateBack,
      ),
    );
  }
  
  Widget buildForm();
}