import 'package:flutter/material.dart';
import 'package:staff_app/shared/theming/app_colors.dart';

class AppTheme {
  static light() {
    return ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: AppColors.lightGreen,
        primarySwatch: AppColors.createMaterialColor(AppColors.lightGreen),

        // Define the default font family.
        fontFamily: 'Montserrat',
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          border: OutlineInputBorder(),
        )

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        // textTheme: const TextTheme(

        // ),
        );
  }
}
