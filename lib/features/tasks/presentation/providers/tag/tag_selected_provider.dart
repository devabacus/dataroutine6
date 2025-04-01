import 'package:dataroutine6/features/tasks/domain/entities/tag.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tag_selected_provider.g.dart';

@riverpod
class TagSelected extends _$TagSelected {
  @override
  TagEntity? build() {
    return null;
  }

  void setTag(TagEntity tag) {
    state = tag;
  }
}
