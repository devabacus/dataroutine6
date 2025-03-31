import '../../presentation/pages/tag/update_tag_page.dart';
import '../../presentation/pages/tag/add_tag_page.dart';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/tag/view_tag_page.dart';
import '../../presentation/pages/tasks_page.dart';
import '../pages/category/add_category_page.dart';
import '../pages/category/edit_category_page.dart';
import '../pages/category/view_categories_page.dart';
import 'tasks_routes_constants.dart';

List<RouteBase> getTasksRoutes() {
  return [

    GoRoute(
      name: TasksRoutes.updateTag,
      path: TasksRoutes.updateTagPath,
      builder: (BuildContext context, state) {
      final tagId = state.pathParameters['tagId'];
      return UpdateTagPage(tagId: tagId!);
    
      }
  ),
  

    GoRoute(
      name: TasksRoutes.addTag,
      path: TasksRoutes.addTagPath,
      builder: (BuildContext context, state) {
      return AddTagPage();
      }
  ),
  

    GoRoute(
      name: TasksRoutes.viewTag,
      path: TasksRoutes.viewTagPath,
      builder: (BuildContext context, state) {
        
      
      return ViewTagPage();
    
      }
  ),
  
    GoRoute(
      name: TasksRoutes.editItem,
      path: TasksRoutes.editItemPath,
      builder: (BuildContext context, state) {
        final categoryId = state.pathParameters['categoryId'];
        return EditItemPage(categoryId: categoryId!);
      },
    ),

    GoRoute(
      name: TasksRoutes.addItem,
      path: TasksRoutes.addItemPath,
      builder: (BuildContext context, state) {
        return AddItemPage();
      },
    ),

    GoRoute(
      name: TasksRoutes.viewTable,
      path: TasksRoutes.viewTablePath,
      builder: (BuildContext context, state) {
        return ViewTablePage();
      },
    ),

    GoRoute(
      name: TasksRoutes.tasks,
      path: TasksRoutes.tasksPath,
      builder: (BuildContext context, state) => TasksPage(),
    ),
  ];
}
