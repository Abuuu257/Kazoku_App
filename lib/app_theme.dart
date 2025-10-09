import 'package:flutter/material.dart';

class AppTheme {
  // Cool neutral palette seed (no brown)
  static const seed = Color(0xFF4F8EF7); // blue accent
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seed,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seed,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
