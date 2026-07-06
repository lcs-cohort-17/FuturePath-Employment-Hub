// app.theme
import 'package:flutter/material.dart';

class AppTheme {
  // Brand
  static const Color primary     = Color(0xFFE03A2F); // --brand (red)
  static const Color primaryDim  = Color(0xFF6B1A16); // --brand-dim
  static const Color primaryLow  = Color(0x1FE03A2F); // --brand-low (12% opacity)

  // Surfaces
  static const Color surface     = Color(0xFF111111); // --surf
  static const Color surface2    = Color(0xFF1A1A1A); // --surf2
  static const Color surface3    = Color(0xFF242424); // --surf3
  static const Color surface4    = Color(0xFF2E2E2E); // --surf4

  // Text
  static const Color textDark    = Color(0xFFF0EDE8); // --t1 (primary text)
  static const Color mutedText   = Color(0xFF9E9B96); // --t2
  static const Color subtleText  = Color(0xFF5C5A57); // --t3

  // Semantic colours
  static const Color success     = Color(0xFF2ECC8A); // --green
  static const Color successLow  = Color(0x1F2ECC8A); // --green-low
  static const Color warning     = Color(0xFFF5A623); // --amber
  static const Color warningLow  = Color(0x1FF5A623); // --amber-low
  static const Color info        = Color(0xFF4A9EE8);  // --blue
  static const Color infoLow     = Color(0x1F4A9EE8);  // --blue-low
  static const Color error       = Color(0xFFE03A2F); // same as brand
  static const Color errorLow    = Color(0x1FE03A2F); // --red-low

  // Borders
  static const Color border      = Color(0x14FFFFFF); // --bdr  (8% white)
  static const Color border2     = Color(0x24FFFFFF); // --bdr2 (14% white)

  // Legacy aliases (keep so existing widget refs don't break)
  static const Color accent      = primary;
  static const Color background  = surface;
  static const Color card        = surface2;
  static const Color secondary   = surface3;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: surface,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: surface3,
      surface: surface2,
      error: error,
      onPrimary: Colors.white,
      onSecondary: textDark,
      onSurface: textDark,
      onError: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: subtleText,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: const CardThemeData(
      color: surface2,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface2,
      hintStyle: const TextStyle(color: subtleText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: border2, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: border2, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 13),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge:  TextStyle(color: textDark),
      bodyMedium: TextStyle(color: textDark),
      bodySmall:  TextStyle(color: mutedText),
    ),
  );
}
