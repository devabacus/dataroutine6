import 'package:flutter/material.dart';

class DateTimePickerUtils {
  static Future<DateTime?> selectDate(
    BuildContext context,
    DateTime initialDate,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != initialDate) {
      return DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        initialDate.hour,
        initialDate.minute,
      );
    }
    return null;
  }

  static Future<DateTime?> selectTime(
    BuildContext context,
    DateTime initialDateTime,
  ) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime),
    );

    if (pickedTime != null) {
      return DateTime(
        initialDateTime.year,
        initialDateTime.month,
        initialDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
    return null;
  }

  static String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

 static DateTime? parseDateTime(String input) {
    // Ожидаемый формат: "DD.MM.YYYY HH:MM"
    try {
      final parts = input.split(' ');
      if (parts.length != 2) return null;

      final datePart = parts[0].split('.');
      if (datePart.length != 3) return null;

      final timePart = parts[1].split(':');
      if (timePart.length != 2) return null;

      final day = int.parse(datePart[0]);
      final month = int.parse(datePart[1]);
      final year = int.parse(datePart[2]);

      final hour = int.parse(timePart[0]);
      final minute = int.parse(timePart[1]);

      return DateTime(year, month, day, hour, minute);
    } catch (e) {
      print("error parsing date: $e");
      return null;
    }
  }
}
