abstract class TasksRoutes {

    static const dbViewer = 'tasks_db_viewer';
    static const dbViewerPath = '/tasks/db_viewer';
  
  static const updateTag = 'tasks_update_tag';
  static const updateTagPath = '/tasks/update_tag';

  static const addTag = 'tasks_add_tag';
  static const addTagPath = '/tasks/add_tag';

  static const viewTag = 'tasks_view_tag';
  static const viewTagPath = '/tasks/view_tag';

  static const addCategory = 'tasks_add_category';
  static const addCategoryPath = '/tasks/add_category';

  static const editCategory = 'tasks_edit_category';
  static const editCategoryPath = '/tasks/edit_category';

  static const isFromTask = 'isFromTask';

  static const viewCategory = 'tasks_view_category';
  static const viewCategoryPath = '/tasks/view_category/:$isFromTask';

  static const editTask = 'tasks_edit_task';
  static const editTaskPath = '/tasks/edit_task';

  static const viewTask = 'tasks_view_task';
  static const viewTaskPath = '/tasks/view_task';

  static const addTask = 'tasks_add_task';
  static const addTaskPath = '/tasks/add_task';

  static const tasks = 'tasks';
  static const tasksPath = '/tasks';
}
