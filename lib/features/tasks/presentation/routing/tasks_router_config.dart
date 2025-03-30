import '../../presentation/pages/view_table_page.dart';

import '../../presentation/pages/tasks_page.dart';
import 'tasks_routes_constants.dart';

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


List<RouteBase> getTasksRoutes() {
  return [

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
