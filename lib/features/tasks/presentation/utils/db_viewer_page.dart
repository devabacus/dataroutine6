
import 'package:dataroutine6/core/database/local/provider/database_provider.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class DbViewerPage extends ConsumerWidget {
  const DbViewerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DriftDbViewer(ref.read(appDatabaseProvider));
  }
}

