import '../../presentation/pages/edit_item_page.dart';
import '../../presentation/pages/edit_item_page.dart';
import '../../presentation/pages/add_item_page.dart';
import '../../presentation/pages/view_table_page.dart';

import '../../presentation/pages/tasks_page.dart';
import 'tasks_routes_constants.dart';

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


List<RouteBase> getTasksRoutes() {
  return [

    GoRoute(
      name: TasksRoutes.editItem,
      path: TasksRoutes.editItemPath,
      builder: (BuildContext context, state) {
        
      final categoryId = state.pathParameters['categoryId'];
      return EditItemPage(categoryId: categoryId!);
    
      }
  ),
  

    GoRoute(
      name: TasksRoutes.addItem,
      path: TasksRoutes.addItemPath,
      builder: (BuildContext context, state) {
        
      
      return AddItemPage();
    
      }
  ),
  

    GoRoute(
      name: TasksRoutes.viewTable,
      path: TasksRoutes.viewTablePath,
      builder: (BuildContext context, state) {
        
      
      return ViewTablePage();
    
      }
  ),
  
    GoRoute(
      name: TasksRoutes.tasks,
      path: TasksRoutes.tasksPath,
      builder: (BuildContext context, state) => TasksPage(),
    ),
  ];
}
