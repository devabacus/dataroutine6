

import 'package:dataroutine6/features/tasks/domain/entities/task/task.dart';

import '../../../data/models/task/task_model.dart';

extension TaskEntityExtension on TaskEntity {
  
      TaskModel toModel() => TaskModel(id: id, title: title, description: description, duration: duration, createdAt: createdAt, dueDateTime: dueDateTime, categoryId: categoryId);

}

extension TaskEntitiesListExtension on List<TaskEntity> {

    List<TaskModel> toModels() => map((data)=>data.toModel()).toList();
    
 }

