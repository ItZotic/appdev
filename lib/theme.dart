import 'package:flutter/material.dart';

ThemeData buildSmartTheme() {
  const primaryColor = Color(0xFF2BC4A3);
  const darkColor = Color(0xFF131526);

  final base = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: Color(0xFF5B61F6),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: Color(0xFF222436),
    ),
    useMaterial3: true,
    fontFamily: 'Roboto',
  );

  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFFF7F8FC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: darkColor,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    textTheme: base.textTheme.apply(
      bodyColor: const Color(0xFF222436),
      displayColor: const Color(0xFF222436),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE5E7F1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE5E7F1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
  );
}
