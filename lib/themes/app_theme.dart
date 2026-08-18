import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData getLightTheme(Color primaryColor) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor, 
        foregroundColor: Colors.white,
      ),
      cardColor: Colors.grey[100],
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
    );
  }

  static ThemeData getDarkTheme(Color primaryColor) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor, 
        foregroundColor: Colors.white,
      ),
      cardColor: const Color(0xFF1E1E1E),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
    );
  }
}