import 'package:flutter/material.dart';

/// Single source of truth for the app's pink/blue visual identity, so the
/// two accent colors stay consistent without being repeated across widgets.
class AppTheme {
  AppTheme._();

  static const Color pink = Color(0xFFFF6FA5);
  static const Color blue = Color(0xFF5B9DF0);
  static const Color background = Color(0xFFFFF8FA);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: pink,
      brightness: Brightness.light,
    ).copyWith(secondary: blue);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
