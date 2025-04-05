
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/tag/tag.dart';
import '../../../domain/providers/tag/tag_usecase_providers.dart';

part 'tag_state_providers.g.dart';

@riverpod
class Tag extends _$Tag {
  @override
  Future<List<TagEntity>> build() {
    return ref.read(getTagUseCaseProvider)();
  }

  Future<void> addTag(TagEntity tag) async {


    state = await AsyncValue.guard
    
    (() async {
      await ref.read(createTagUseCaseProvider)(tag);
      return ref.read(getTagUseCaseProvider)();
    });

  }

  Future<void> updateTag(TagEntity tag) async {
    state = await AsyncValue.guard(() async {
      await ref.read(updateTagUseCaseProvider)(tag);
      return ref.read(getTagUseCaseProvider)();
    });
  }

  Future<void> deleteTag(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(deleteTagUseCaseProvider)(id);
      return ref.read(getTagUseCaseProvider)();
    });
  }
}
