import '../../features/tasks/presentation/routing/tasks_routes_constants.dart';
import '../../features/home/presentation/routing/home_routes_constants.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {

    void navigateToTasks(BuildContext context) {
      context.goNamed(TasksRoutes.tasks);
    }
  

    void navigateToHome(BuildContext context) {
      context.goNamed(HomeRoutes.home);
    }
  
}
