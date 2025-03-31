
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routing/tasks_routes_constants.dart';


class TasksNavigationService {

    void navigateToUpdateTag(BuildContext context, String tagId) {
      context.goNamed(TasksRoutes.updateTag, pathParameters: {'tagId': tagId});
    }
  

    void navigateToAddTag(BuildContext context) {
      context.goNamed(TasksRoutes.addTag);
    }
  

    void navigateToViewTag(BuildContext context) {
      context.goNamed(TasksRoutes.viewTag);
    }
  

    void navigateToEditItem(BuildContext context, String categoryId) {
      context.goNamed(TasksRoutes.editItem, pathParameters: {'categoryId': categoryId});
    }

    void navigateToAddItem(BuildContext context) {
      context.goNamed(TasksRoutes.addItem);
    }
  

    void navigateToViewTable(BuildContext context) {
      context.goNamed(TasksRoutes.viewTable);
    }
  
  
  void navigateToTasks(BuildContext context){
      context.goNamed(TasksRoutes.tasks);
  }

}

