
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../usecases/tag/create.dart';
import '../../usecases/tag/delete.dart';
import '../../usecases/tag/update.dart';
import '../../usecases/tag/get_all.dart';
import '../../../data/providers/tag/tag_data_providers.dart';

part 'tag_usecase_providers.g.dart';

@riverpod
GetTagUseCase getTagUseCase(Ref ref) {
  final repository = ref.read(tagRepositoryProvider);
  return GetTagUseCase(repository);
}

@riverpod
CreateTagUseCase createTagUseCase(Ref ref) {
  final repository = ref.read(tagRepositoryProvider);
  return CreateTagUseCase(repository);
}

@riverpod
DeleteTagUseCase deleteTagUseCase(Ref ref) {
  final repository = ref.read(tagRepositoryProvider);
  return DeleteTagUseCase(repository);
}

@riverpod
UpdateTagUseCase updateTagUseCase(Ref ref) {
  final repository = ref.read(tagRepositoryProvider);
  return UpdateTagUseCase(repository);
}
