import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double width(double val) {
    return MediaQuery.of(this).size.width * (val);
  }
}

extension InputDecorationExtension on InputDecoration {
  InputDecoration withBasicStyle(String hintText) {
    return copyWith(border: OutlineInputBorder(), hintText: hintText);
  }
}


