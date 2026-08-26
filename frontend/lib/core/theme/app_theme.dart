import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF13251F);
  static const backgroundElevated = Color(0xFF1B322A);

  static const lightBackground = Color(0xFFF7F4EC);
  static const lightBackgroundElevated = Color(0xFFFFFFFF);

  static const card = Color(0xFFF3E8D6);
  static const cardAlt = Color(0xFFEADFC9);

  static const accent = Color(0xFFCE9B4C);

  static const success = Color(0xFF6FA971);
  static const warning = Color(0xFFD9A441);
  static const missing = Color(0xFFD9714C);

  static const textLight = Color(0xFFF6F1E6);
  static const textLightMuted = Color(0xFFB9C4BD);

  static const textDark = Color(0xFF20291F);
  static const textDarkMuted = Color(0xFF6B6656);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: AppColors.background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.dark,
        primary: AppColors.accent,
        surface: AppColors.backgroundElevated,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: AppColors.backgroundElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textDark,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundElevated,
        hintStyle: const TextStyle(
          color: AppColors.textLightMuted,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.backgroundElevated,
        indicatorColor: AppColors.accent,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: AppColors.textLight,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textLight,
        ),
        bodySmall: TextStyle(
          color: AppColors.textLightMuted,
        ),
        titleLarge: TextStyle(
          color: AppColors.textLight,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: AppColors.textLight,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      scaffoldBackgroundColor: AppColors.lightBackground,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.light,
        primary: const Color(0xFF8A6425),
        surface: AppColors.lightBackgroundElevated,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: AppColors.lightBackgroundElevated,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textDark,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(
          color: AppColors.textDarkMuted,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE0D8C8),
          ),
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Color(0xFFEADFC9),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: AppColors.textDark,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textDark,
        ),
        bodySmall: TextStyle(
          color: AppColors.textDarkMuted,
        ),
        titleLarge: TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}