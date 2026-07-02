//app.theme
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1A365D);
  static const Color secondary = Color(0xFFEFF6FF);
  static const Color accent = Color(0xFF008080);
  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1E293B);
  static const Color mutedText = Color(0xFF64748B);
  static const Color error = Color(0xFFEF4444);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      surface: card,
      error: error,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: accent,
      unselectedItemColor: mutedText,
      type: BottomNavigationBarType.fixed,
    ),
  );
}