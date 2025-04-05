

import 'package:dataroutine6/features/tasks/domain/entities/tag/tag.dart';

import '../../../data/models/tag/tag_model.dart';

extension TagEntityExtension on TagEntity {
  
  TagModel toModel() => TagModel(id: id, title: title);
}

extension TagEntityListExtension on List<TagEntity> {
  List<TagModel> toModels() => map((entity) => entity.toModel()).toList();
}