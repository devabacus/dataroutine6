import 'package:flutter/widgets.dart';

class TaskFormControllers {
  final TextEditingController title;
  final TextEditingController description;
  final TextEditingController categoryId;
  final TextEditingController createdAt;
  final TextEditingController dueDateTime;
  final TextEditingController duration;
  final TextEditingController tag;

  TaskFormControllers({
    TextEditingController? title,
    TextEditingController? description,
    TextEditingController? categoryId,
    TextEditingController? createdAt,
    TextEditingController? dueDateTime,
    TextEditingController? duration,
    TextEditingController? tag,
  }) : title = title ?? TextEditingController(),
       description = description ?? TextEditingController(),
       categoryId = categoryId ?? TextEditingController(),
       createdAt = createdAt ?? TextEditingController(),
       dueDateTime = dueDateTime ?? TextEditingController(),
       duration = duration ?? TextEditingController(),
       tag = tag ?? TextEditingController();

  void dispose() {
    title.dispose();
    description.dispose();
    categoryId.dispose();
    createdAt.dispose();
    dueDateTime.dispose();
    duration.dispose();
    tag.dispose();
  }

  void clearAll() {
  title.clear();
  description.clear();
  categoryId.clear();
  createdAt.clear();
  dueDateTime.clear();
  duration.clear();
  tag.clear();
}
}
