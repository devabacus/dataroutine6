import '../../features/tasks/presentation/routing/tasks_routes_constants.dart';
import '../../features/home/presentation/routing/home_routes_constants.dart';
// ignore_for_file: unused_import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mlogger/mlogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../features/home/presentation/routing/home_router_config.dart';
import '../../features/home/presentation/routing/home_routes_constants.dart';
import '../../features/tasks/presentation/routing/tasks_router_config.dart';
import '../../features/tasks/presentation/routing/tasks_routes_constants.dart';
import './routes_constants.dart';

part 'router_config.g.dart';
 
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    // observers: [TalkerRouteObserver(log.talker)],
    initialLocation: TasksRoutes.viewCategoryPath,
    routes: [
			...getTasksRoutes(),
			...getHomeRoutes(),
        
    ]); 
}   

