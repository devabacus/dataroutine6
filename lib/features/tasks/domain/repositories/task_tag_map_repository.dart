import '../entities/tag/tag.dart';
import '../entities/task/task.dart';

abstract class ITaskTagMapRepository {
  /// Получить все теги для определённой задачи
  Future<List<TagEntity>> getTagsForTask(String taskId);

  /// Получить все задачи с определённым тегом
  Future<List<TaskEntity>> getTasksWithTag(String tagId);

  /// Добавить тег к задаче
  Future<void> addTagToTask(String taskId, String tagId);

  /// Удалить тег у задачи
  Future<void> removeTagFromTask(String taskId, String tagId);

  /// Удалить все теги у задачи
  Future<void> removeAllTagsFromTask(String taskId);

  // /// Обновить теги задачи (удаляет старые связи и устанавливает новые)
  // Future<void> updateTaskTags(int taskId, List<int> tagIds);

  // /// Проверить, имеет ли задача определённый тег
  // Future<bool> hasTaskTag(int taskId, int tagId);
}
