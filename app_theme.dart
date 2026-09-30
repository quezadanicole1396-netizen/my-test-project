import 'package:flutter/material.dart';

class AppTheme {
  static const cream = Color(0xFFFFF8F0);
  static const brown = Color(0xFF9A6848);
  static const darkBrown = Color(0xFF4E342E);
  static const peach = Color(0xFFF2D4BE);
  static const sage = Color(0xFFDCE8D5);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(seedColor: brown),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
