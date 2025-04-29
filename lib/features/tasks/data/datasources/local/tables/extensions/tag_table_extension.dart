

import 'package:dataroutine6/core/database/local/database.dart';

import '../../../../models/tag/tag_model.dart';

extension TagTableDataExtension on TagTableData {
  
    TagModel toModel() => TagModel(id: id, title: title);
}

extension TagTableListDataExtension on List<TagTableData> {
  
  List<TagModel> toModels() => map((data)=>data.toModel()).toList();

}




