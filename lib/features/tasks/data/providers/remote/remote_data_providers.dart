import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasources/remote/interfaces/category_remote_datasource_service.dart';
import '../../datasources/remote/sources/category_firestore_datasource.dart';

part 'remote_data_providers.g.dart';

// Провайдер для Firestore
@riverpod
FirebaseFirestore firestore(Ref ref) {
  return FirebaseFirestore.instance;
}

// Провайдер для удаленного источника данных категорий
@riverpod
ICategoryRemoteDataSource categoryRemoteDataSource(Ref ref) {
  final firestoreInstance = ref.watch(firestoreProvider);
  
  return CategoryFirestoreDataSource(
    firestore: firestoreInstance,
  );
}