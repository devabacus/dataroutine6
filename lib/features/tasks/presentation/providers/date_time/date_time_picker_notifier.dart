import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_time_picker_notifier.g.dart';

@riverpod
class DateTimePickerNotifier extends _$DateTimePickerNotifier {
  @override
  DateTime build() {
    return DateTime.now();
  }

  // обновляем дату сохраняя текущее время
  Future<void> updateDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: state,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != state) {
      state = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        state.hour,
        state.minute,
      );
    }
    print("Обновлена дата: $state"); // Для отладки
  }

  Future<void> updateTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(state),
    );

    if (pickedTime != null) {
      state = DateTime(
        state.year,
        state.month,
        state.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
    print("Обновленное время: $state"); // Для отладки
  }

  Future<void> updateDateAndTime(BuildContext context) async {
    await updateDate(context);
    await updateTime(context);
  }

  void setDateTime(DateTime dateTime) {
    state = dateTime;
  }

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
