

import 'package:dataroutine6/features/tasks/domain/entities/tag.dart';

import '../../../data/models/tag_model.dart';

extension TagEntityExtension on TagEntity {
  
  TagModel toModel() => TagModel(id: id, title: title);

  
}
