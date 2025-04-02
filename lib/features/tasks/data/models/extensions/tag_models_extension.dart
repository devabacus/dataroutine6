


import 'package:dataroutine6/core/database/local/database.dart';
import 'package:dataroutine6/features/tasks/data/models/tag_model.dart';
import 'package:dataroutine6/features/tasks/domain/entities/tag.dart';
import 'package:drift/drift.dart';

extension TagModelExtension on TagModel {
    TagTableCompanion toCompanion() => TagTableCompanion.insert(title: title);


  TagTableCompanion toCompanionWithId() => TagTableCompanion(id: Value(id), title: Value(title));

  TagEntity toEntity() => TagEntity(id: id, title: title);
}

extension TagModelListExtension on List<TagModel> {
  List<TagEntity> toEntities() => map((model) => model.toEntity()).toList();
}


