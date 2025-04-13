import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_time_picker_notifier.g.dart';

@riverpod
class DateTimePickerNotifier extends _$DateTimePickerNotifier {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void setDateTime(DateTime dateTime) {
    state = dateTime;
  }

}
