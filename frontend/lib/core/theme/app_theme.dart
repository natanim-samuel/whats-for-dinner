import 'package:flutter/material.dart';

/// Dark, moody, food-photography-forward palette — deep green background,
/// warm cream cards, soft gold accents. Matches the target design mockup.
class AppColors {
  static const background = Color(0xFF13251F); // deep green-black
  static const backgroundElevated = Color(0xFF1B322A);
  static const card = Color(0xFFF3E8D6); // warm cream
  static const cardAlt = Color(0xFFEADFC9);
  static const accent = Color(0xFFCE9B4C); // soft gold
  static const success = Color(0xFF6FA971); // ingredient availability
  static const warning = Color(0xFFD9A441);
  static const missing = Color(0xFFD9714C);
  static const textLight = Color(0xFFF6F1E6); // text on dark bg
  static const textLightMuted = Color(0xFFB9C4BD);
  static const textDark = Color(0xFF20291F); // text on cream cards
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
        iconTheme: IconThemeData(color: AppColors.textLight),
      ),
      cardTheme: CardThemeData(
        color: AppColors.backgroundElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textDark,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundElevated,
        hintStyle: const TextStyle(color: AppColors.textLightMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundElevated,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textLightMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.textLight),
        bodyLarge: TextStyle(color: AppColors.textLight),
      ),
    );
  }
}