

import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class UpsertFormFactory {
  static Widget createBasicFormField(
    TextEditingController controller, {
    String? labelText,
    String? hintText,
    FormFieldValidator<String>? validator,
    Widget? trailing,
  }) {
    return ListTile(
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
        ),
        validator: validator,
      ),
      trailing: trailing,
    );
  }
  
  static Widget createSaveButton(
    VoidCallback onPressed, {
    String? text,
    bool isEditing = false,
  }) {
    return ElevatedButton(
      style: AppButtonStyle.basicStyle,
      onPressed: onPressed,
      child: Text(text ?? (isEditing ? "Обновить" : "Сохранить")),
    );
  }
}