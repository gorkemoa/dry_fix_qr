import 'package:flutter/material.dart';

class AppColors {
  static const Color darkBlue = Color(0xFF002452);
  static const Color gray = Color(0xFF969AB0);
  static const Color titleLight = Color(0xFFDCE1F0);
  static const Color blue = Color(0xFF0094BF);
  static const Color background = Color(0xFFF8F9FE);
  static const Color white = Colors.white;
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.darkBlue,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkBlue,
      primary: AppColors.darkBlue,
      secondary: AppColors.blue,
      surface: AppColors.white,
      background: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.darkBlue),
      titleTextStyle: TextStyle(
        color: AppColors.darkBlue,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.darkBlue,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
      titleLarge: TextStyle(
        color: AppColors.darkBlue,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
      bodyLarge: TextStyle(fontFamily: 'Inter'),
      bodyMedium: TextStyle(fontFamily: 'Inter'),
    ),
  );
}
