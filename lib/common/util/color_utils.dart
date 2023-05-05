import 'package:flutter/material.dart';

class ColorUtils {
  static Color stringToColor(String stringColor) {
    return Color(int.parse("FF$stringColor", radix: 16));
  }

  static bool isBlackShade(String stringColor) {
    final color = stringToColor(stringColor);
    final int threshold = 50;

    return color.red < threshold &&
        color.green < threshold &&
        color.blue < threshold;
  }
}
