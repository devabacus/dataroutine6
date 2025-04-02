
import 'package:flutter/material.dart';


mixin FormControllersMixin<T> {
  final Map<String, TextEditingController> controllers = {};
  
  TextEditingController getController(String fieldName) {
    if (!controllers.containsKey(fieldName)) {
      controllers[fieldName] = TextEditingController();
    }
    return controllers[fieldName]!;
  }
  
  void disposeControllers() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    controllers.clear();
  }
  
  void setControllerValue(String fieldName, String value) {
    getController(fieldName).text = value;
  }
  
  String getControllerValue(String fieldName) {
    return getController(fieldName).text;
  }
}