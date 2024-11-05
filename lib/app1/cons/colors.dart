import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color.fromRGBO(76, 175, 80, 1);
  static const Color secondaryColor = const Color.fromRGBO(76, 175, 80, 1);
  static const Color shrimmerColorText = Color.fromARGB(255, 205, 203, 203);
  static const Color shrimmerContainerColor =
      Color.fromARGB(255, 237, 237, 237);

  static const Color inputFieldBorderColor = Color(0xFFB7B5B5);
  static const Color backgroundColor = Colors.white;
  static const Color cardColor = Color.fromARGB(255, 241, 243, 244);
  static const Color iconColors = Colors.black87;
}

// theme_config.dart

class EasyCanteenTheme {
  static ThemeData zomatoInspired() {
    return ThemeData(
      primaryColor: Color(0xFFE23744),
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: Color(0xFFE23744),
        secondary: Color(0xFF1C1C1C),
        surface: Colors.white,
        background: Colors.white,
        error: Color(0xFFB00020),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1C1C1C),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1C),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF1C1C1C),
        ),
      ),
    );
  }

  static ThemeData uberEatsInspired() {
    return ThemeData(
      primaryColor: Color(0xFF06C167),
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: Color(0xFF06C167),
        secondary: Color(0xFF000000),
        surface: Colors.white,
        background: Colors.white,
        error: Color(0xFFB00020),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF000000),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF000000),
        ),
      ),
    );
  }

  static ThemeData swiggyInspired() {
    return ThemeData(
      primaryColor: Color(0xFFFC8019),
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: Color(0xFFFC8019),
        secondary: Color(0xFF282C3F),
        surface: Colors.white,
        background: Colors.white,
        error: Color(0xFFB00020),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF282C3F),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF282C3F),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF282C3F),
        ),
      ),
    );
  }
}
