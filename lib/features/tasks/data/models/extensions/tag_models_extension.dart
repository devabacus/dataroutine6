


import 'package:dataroutine6/core/database/local/database.dart';
import 'package:dataroutine6/features/tasks/data/models/tag_model.dart';

extension TagModelExtension on TagModel {
    TagTableCompanion toCompanion() => TagTableCompanion.insert(title: title);
    
}
