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
    primaryColor: AppColors.blue,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkBlue),
      titleTextStyle: TextStyle(
        color: AppColors.darkBlue,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
