
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'delete_select_provider.g.dart';


@riverpod
class DeleteSelect extends _$DeleteSelect {
  @override
  bool build() {
      return false;
  }

  void setDeleteSelect(){
      state = true;
  }

  void resetDeleteSelect(){
      state = false;
  }
}



