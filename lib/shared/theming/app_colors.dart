import 'package:flutter/material.dart';

class AppColors {
  static const Color lightGreen = Color(0xFF23CCB7);
  static const Color blackBlue = Color(0xFF0C3A5E);
  static const Color blue = Color(0xFF4F86FF);
  static const Color lightBlue = Color(0xFF4F86FF);
  static const Color buttonBordeColor = Color(0xFF4FA0FF);
  static const Color bordeColor = Color(0xFFD0D5DD);
  static const Color black = Color(0xFF1E1E1E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF878787);
  static const Color blackText = Color(0xFF000000);
  static const Color textColor = Color(0xff667085);
  static const Color errorColor = Color(0xffED1A34);
  static const Color orange = Color(0xffF47A27);
  static const Color purple = Color(0xffA551FF);
  static const Color red = Color(0xffFE5151);

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
