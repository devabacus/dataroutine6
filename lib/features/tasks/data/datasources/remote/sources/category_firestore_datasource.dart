import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/category/category_model.dart';
import '../interfaces/category_remote_datasource_service.dart';

class CategoryFirestoreDataSource implements ICategoryRemoteDataSource {
  final FirebaseFirestore _firestore;
  
  // Константы для коллекций и полей
  static const String _categoriesCollection = 'categories';
  static const String _lastUpdatedField = 'lastUpdated';
  
  CategoryFirestoreDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;
  
  // Получение ссылки на коллекцию категорий
  // Теперь используем глобальную коллекцию без привязки к пользователю
  CollectionReference<Map<String, dynamic>> get _categoriesRef {
    return _firestore.collection(_categoriesCollection);
  }
  
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _categoriesRef.get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Здесь мы можем использовать doc.id как строковый ID, 
        // но для совместимости с существующим кодом преобразуем в int
        return CategoryModel(
          id: doc.id,
          title: data['title'] as String,
        );
      }).toList();
    } catch (e) {
      throw Exception('Не удалось получить категории: $e');
    }
  }
  
  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final doc = await _categoriesRef.doc(id.toString()).get();
      
      if (!doc.exists) {
        return null;
      }
      
      final data = doc.data()!;
      return CategoryModel(
        id: id,
        title: data['title'] as String,
      );
    } catch (e) {
      throw Exception('Не удалось получить категорию: $e');
    }
  }
  
  @override
  Future<String> createCategory(CategoryModel category) async {
    try {
      // При создании используем временную метку обновления
      final timestamp = FieldValue.serverTimestamp();
      final docRef = category.id != ''
          ? _categoriesRef.doc(category.id.toString())
          : _categoriesRef.doc();
          
      await docRef.set({
        'title': category.title,
        _lastUpdatedField: timestamp,
      });
      
      return docRef.id;
    } catch (e) {
      throw Exception('Не удалось создать категорию: $e');
    }
  }
  
  @override
  Future<void> updateCategory(CategoryModel category) async {
    try {
      final timestamp = FieldValue.serverTimestamp();
      await _categoriesRef.doc(category.id.toString()).update({
        'title': category.title,
        _lastUpdatedField: timestamp,
      });
    } catch (e) {
      throw Exception('Не удалось обновить категорию: $e');
    }
  }
  
  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _categoriesRef.doc(id.toString()).delete();
    } catch (e) {
      throw Exception('Не удалось удалить категорию: $e');
    }
  }
  
  @override
  Future<void> syncToRemote(List<CategoryModel> categories) async {
    // Создаем batch для выполнения множественных операций атомарно
    final batch = _firestore.batch();
    final timestamp = FieldValue.serverTimestamp();
    
    for (final category in categories) {
      final docRef = _categoriesRef.doc(category.id.toString());
      batch.set(docRef, {
        'title': category.title,
        _lastUpdatedField: timestamp,
      }, SetOptions(merge: true));
    }
    
    await batch.commit();
  }
  
  @override
  Future<List<CategoryModel>> getUpdatedSince(DateTime lastSyncTime) async {
    try {
      final snapshot = await _categoriesRef
          .where(_lastUpdatedField, isGreaterThan: Timestamp.fromDate(lastSyncTime))
          .get();
          
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryModel(
          id: doc.id,
          title: data['title'] as String,
        );
      }).toList();
    } catch (e) {
      throw Exception('Не удалось получить обновленные категории: $e');
    }
  }
  
  @override
  Stream<List<CategoryModel>> watchCategories() {
    return _categoriesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryModel(
          id: doc.id,
          title: data['title'] as String,
        );
      }).toList();
    });
  }
}