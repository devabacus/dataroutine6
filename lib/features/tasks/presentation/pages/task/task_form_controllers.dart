import 'package:flutter/widgets.dart';

class TaskFormControllers {
  final TextEditingController title;
  final TextEditingController description;
  final TextEditingController categoryId;
  final TextEditingController createdAt;
  final TextEditingController duration;
  final TextEditingController tag;

  TaskFormControllers({
    TextEditingController? title,
    TextEditingController? description,
    TextEditingController? categoryId,
    TextEditingController? createdAt,
    TextEditingController? duration,
    TextEditingController? tag,
  }) : title = title ?? TextEditingController(),
       description = description ?? TextEditingController(),
       categoryId = categoryId ?? TextEditingController(),
       createdAt = createdAt ?? TextEditingController(),
       duration = duration ?? TextEditingController(),
       tag = tag ?? TextEditingController();

  void dispose(){
      title.dispose();
      description.dispose();
      categoryId.dispose();
      createdAt.dispose();
      duration.dispose();
      tag.dispose();
  }     
}
