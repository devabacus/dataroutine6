
abstract class TasksRoutes {

    static const editTask = 'tasks_edit_task';
    static const editTaskPath = '/tasks/edit_task';
  

    static const viewTask = 'tasks_view_task';
    static const viewTaskPath = '/tasks/view_task';
  

    static const addTask = 'tasks_add_task';
    static const addTaskPath = '/tasks/add_task';
  

    static const tagId = 'tagId';
    static const updateTag = 'tasks_update_tag';
    static const updateTagPath = '/tasks/update_tag/:$tagId';
  

    static const addTag = 'tasks_add_tag';
    static const addTagPath = '/tasks/add_tag';
  

    static const viewTag = 'tasks_view_tag';
    static const viewTagPath = '/tasks/view_tag';
  

    static const categoryId = 'categoryId';
    static const editItem = 'tasks_edit_item';
    static const editItemPath = '/tasks/edit_item/:$categoryId';

    static const addItem = 'tasks_add_item';
    static const addItemPath = '/tasks/add_item';
  

    static const viewTable = 'tasks_view_table';
    static const viewTablePath = '/tasks/view_table';
  
    static const tasks = 'tasks';
    static const tasksPath = '/tasks';
}
