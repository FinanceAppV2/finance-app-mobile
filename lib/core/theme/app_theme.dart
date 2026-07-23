import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const background = Color(0xFF0D0E0D);
  static const cinzaEscuro = Color(0xFF585B56);
  static const verdeEscuro = Color(0xFF314A08);
  static const verdeMedio = Color(0xFF4C6C13);
  static const verdePrincipal = Color(0xFF5F9213);
  static const verdeDestaque = Color(0xFFA5F620);
  static const branco = Color(0xFFF0F1F0);
  static const cinzaClaro = Color(0xFF7B8767);

  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFFA726);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.verdePrincipal,
        brightness: Brightness.dark,
        primary: AppColors.verdePrincipal,
        secondary: AppColors.verdeDestaque,
        surface: AppColors.verdeEscuro,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.branco,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.verdeEscuro,
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.verdeEscuro,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.verdeMedio, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.verdeEscuro, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.verdeDestaque, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: TextStyle(color: AppColors.cinzaClaro),
        hintStyle: TextStyle(color: AppColors.branco.withValues(alpha: 0.5)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verdeDestaque,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: StadiumBorder(),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.branco, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppColors.branco, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.branco),
        bodyMedium: TextStyle(color: AppColors.cinzaEscuro),
        labelLarge: TextStyle(color: AppColors.branco),
      ),
    );
  }
}
