import 'dart:core';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/category/upsert_category_page.dart';
import '../../presentation/pages/category/view_category_page.dart';
import '../../presentation/pages/tag/view_tag_page.dart';
import '../../presentation/pages/task/view_task_page.dart';
import '../../presentation/pages/tasks_page.dart';
import '../pages/tag/upsert_tag_page.dart';
import '../pages/task/upsert_task_page.dart';
import 'tasks_routes_constants.dart';

List<RouteBase> getTasksRoutes() {
  return [
    
    GoRoute(
      name: TasksRoutes.updateTag,
      path: TasksRoutes.updateTagPath,
      builder: (BuildContext context, state) {
        return UpserTagPage(isEditing: true);
      },
    ),

    GoRoute(
      name: TasksRoutes.addTag,
      path: TasksRoutes.addTagPath,
      builder: (BuildContext context, state) {
        return UpserTagPage();
      },
    ),


    GoRoute(
      name: TasksRoutes.addCategory,
      path: TasksRoutes.addCategoryPath,
      builder: (BuildContext context, state) {
        return UpsertCategoryPage();
      },
    ),

    GoRoute(
      name: TasksRoutes.editCategory,
      path: TasksRoutes.editCategoryPath,
      builder: (BuildContext context, state) {
        return UpsertCategoryPage(isEditing: true);
      },
    ),

    GoRoute(
      name: TasksRoutes.viewCategory,
      path: TasksRoutes.viewCategoryPath,
      builder: (BuildContext context, state) {
        final isFromTask = state.pathParameters['isFromTask'];
        return ViewCategoryPage(isFromTask: isFromTask!);
      },
    ),

    GoRoute(
      name: TasksRoutes.addTask,
      path: TasksRoutes.addTaskPath,
      builder: (BuildContext context, state) {
        return UpsertTaskPage();
      },
    ),
    GoRoute(
      name: TasksRoutes.editTask,
      path: TasksRoutes.editTaskPath,
      builder: (BuildContext context, state) {
        return UpsertTaskPage(isEditing: true,);
      },
    ),

    GoRoute(
      name: TasksRoutes.viewTask,
      path: TasksRoutes.viewTaskPath,
      builder: (BuildContext context, state) {
        return ViewTaskPage();
      },
    ),

    GoRoute(
      name: TasksRoutes.viewTag,
      path: TasksRoutes.viewTagPath,
      builder: (BuildContext context, state) {
        return ViewTagPage();
      },
    ),

    GoRoute(
      name: TasksRoutes.tasks,
      path: TasksRoutes.tasksPath,
      builder: (BuildContext context, state) => TasksPage(),
    ),
  ];
}
