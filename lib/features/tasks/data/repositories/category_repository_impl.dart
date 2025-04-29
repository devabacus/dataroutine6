// import '../../domain/entities/category/category.dart';
// import '../../domain/entities/extensions/category_entity_extension.dart';
// import '../../domain/repositories/category_repository.dart';
// import '../datasources/local/interfaces/category_local_datasource_service.dart';
// import '../models/extensions/category_models_extension.dart';

// class CategoryRepositoryImpl implements ICategoryRepository {
//   final ICategoryLocalDataSource _localDataSource;
  

//   CategoryRepositoryImpl(this._localDataSource);

//   @override
//   Future<List<CategoryEntity>> getCategories() async {
//     final categoryModels = await _localDataSource.getCategories();
//     return categoryModels.toEntities();
//   }

//   @override
//   Future<CategoryEntity> getCategoryById(int id) async {
//     final model = await _localDataSource.getCategoryById(id);
//     return model.toEntity();
//   }

//   @override
//   Future<int> createCategory(CategoryEntity category) {
//     return _localDataSource.createCategory(category.toModel());
//   }

//   @override
//   Future<void> deleteCategory(int id) async {
//     _localDataSource.deleteCategory(id);
//   }

//   @override
//   Future<void> updateCategory(CategoryEntity category) async {
//     _localDataSource.updateCategory(category.toModel());
//   }
// }


import '../../domain/entities/category/category.dart';
import '../../domain/entities/extensions/category_entity_extension.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/local/interfaces/category_local_datasource_service.dart';
import '../datasources/remote/interfaces/category_remote_datasource_service.dart';
import '../models/extensions/category_models_extension.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final ICategoryLocalDataSource _localDataSource;
  final ICategoryRemoteDataSource _remoteDataSource;
  final bool _shouldSyncWithRemote;

  CategoryRepositoryImpl(
    this._localDataSource, 
    this._remoteDataSource, 
    {bool shouldSyncWithRemote = true}
  ) : _shouldSyncWithRemote = shouldSyncWithRemote;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      // Сначала получаем данные из локального хранилища
      final localCategories = await _localDataSource.getCategories();
      
      // Если нужна синхронизация, пытаемся получить данные из облака
      if (_shouldSyncWithRemote) {
        try {
          final remoteCategories = await _remoteDataSource.getCategories();
          
          // Если локальных категорий нет или есть новые удаленные категории,
          // обновляем локальную базу данных
          if (localCategories.isEmpty || remoteCategories.isNotEmpty) {
            await _syncRemoteToLocal(remoteCategories);
            // Получаем обновленные данные после синхронизации
            final updatedCategories = await _localDataSource.getCategories();
            return updatedCategories.toEntities();
          }
        } catch (e) {
          // Если возникла ошибка при получении удаленных данных,
          // просто продолжаем использовать локальные данные
          print('Не удалось получить удаленные категории: $e');
        }
      }
      
      return localCategories.toEntities();
    } catch (e) {
      throw Exception('Ошибка при получении категорий: $e');
    }
  }

  @override
  Future<CategoryEntity> getCategoryById(int id) async {
    try {
      // Сначала пытаемся получить из локального источника
      final localCategory = await _localDataSource.getCategoryById(id);
      
      // Если нужна синхронизация и категория не найдена локально, пробуем удаленно
      if (_shouldSyncWithRemote) {
        try {
          final remoteCategory = await _remoteDataSource.getCategoryById(id);
          
          if (remoteCategory != null) {
            // Обновляем локальную базу, если нашли категорию в облаке
            await _localDataSource.updateCategory(remoteCategory);
            return remoteCategory.toEntity();
          }
        } catch (e) {
          // Продолжаем с локальными данными при ошибке
          print('Не удалось получить удаленную категорию: $e');
        }
      }
      
      return localCategory.toEntity();
    } catch (e) {
      throw Exception('Ошибка при получении категории: $e');
    }
  }

  @override
  Future<int> createCategory(CategoryEntity category) async {
    try {
      // Создаем в локальной базе
      final localId = await _localDataSource.createCategory(category.toModel());
      
      // Если нужно синхронизировать, пытаемся создать в облаке
      if (_shouldSyncWithRemote) {
        try {
          // Берем созданную категорию с правильным ID
          final createdCategory = await _localDataSource.getCategoryById(localId);
          await _remoteDataSource.createCategory(createdCategory);
        } catch (e) {
          // Ошибка при создании в облаке
          print('Не удалось создать категорию в облаке: $e');
          // Можно добавить в очередь синхронизации
        }
      }
      
      return localId;
    } catch (e) {
      throw Exception('Ошибка при создании категории: $e');
    }
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    try {
      // Обновляем локально
      await _localDataSource.updateCategory(category.toModel());
      
      // Если нужно синхронизировать, обновляем в облаке
      if (_shouldSyncWithRemote) {
        try {
          await _remoteDataSource.updateCategory(category.toModel());
        } catch (e) {
          // Ошибка при обновлении в облаке
          print('Не удалось обновить категорию в облаке: $e');
          // Можно добавить в очередь синхронизации
        }
      }
    } catch (e) {
      throw Exception('Ошибка при обновлении категории: $e');
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      // Удаляем локально
      await _localDataSource.deleteCategory(id);
      
      // Если нужно синхронизировать, удаляем в облаке
      if (_shouldSyncWithRemote) {
        try {
          await _remoteDataSource.deleteCategory(id);
        } catch (e) {
          // Ошибка при удалении в облаке
          print('Не удалось удалить категорию в облаке: $e');
          // Можно добавить в очередь синхронизации
        }
      }
    } catch (e) {
      throw Exception('Ошибка при удалении категории: $e');
    }
  }
  
  // Вспомогательный метод для синхронизации удаленных данных с локальными
  Future<void> _syncRemoteToLocal(List<dynamic> remoteCategories) async {
    for (final remoteCategory in remoteCategories) {
      try {
        // Пытаемся найти категорию с таким ID в локальной базе
        final existingCategory = await _localDataSource.getCategoryById(remoteCategory.id);
        if (existingCategory != null) {
          // Если категория существует, обновляем ее
          await _localDataSource.updateCategory(remoteCategory);
        } else {
          // Если категории нет, создаем новую
          await _localDataSource.createCategory(remoteCategory);
        }
      } catch (e) {
        // Если не смогли найти (вызвало исключение), создаем новую
        await _localDataSource.createCategory(remoteCategory);
      }
    }
  }
}