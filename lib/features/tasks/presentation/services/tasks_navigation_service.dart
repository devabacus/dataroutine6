
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routing/tasks_routes_constants.dart';


class TasksNavigationService {

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

