import 'package:flutter/material.dart';

class ColorUtils {
  static Color stringToColor(String code) {
    return Color(int.parse("FF$code", radix: 16));
  }
}