import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routing/tasks_routes_constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Меню',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Задачи'),
              onTap: () {
                Navigator.pop(context);
                context.goNamed(TasksRoutes.viewTask);
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Категории'),
              onTap: () {
                Navigator.pop(context);
                context.goNamed(TasksRoutes.viewCategory, pathParameters: {TasksRoutes.isFromTask: 'false'});
              },
            ),
            ListTile(
              leading: Icon(Icons.tag),
              title: Text('Теги'),
              onTap: () {
                Navigator.pop(context);
                context.goNamed(TasksRoutes.viewTag);
              },
            ),
          ],
        ),
      );
  }
}


