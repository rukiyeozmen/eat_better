import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAF7),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6FAF7B),
      ),
      fontFamily: 'Arial',
    );
  }
}