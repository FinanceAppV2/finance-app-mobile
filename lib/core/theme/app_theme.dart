import 'package:flutter/material.dart';

/// Paleta Leme — tema escuro (design "Leme — Marca e telas").
class AppColors {
  AppColors._();

  // Fundos e superfícies
  static const background = Color(0xFF0D0E0D); // Carvão — fundo das telas
  static const superficie = Color(0xFF171917); // Cards, campos
  static const elevado = Color(0xFF202320); // Sheets, menus, diálogos
  static const linha = Color(0xFF2C2F2C); // Bordas, divisores, trilhas

  // Marca
  static const latao = Color(0xFFB8893E); // Marca, destaques gráficos
  static const lataoClaro = Color(0xFFD6AE62); // Destaque, links, foco

  // Texto
  static const marfim = Color(0xFFEEEDE7); // Texto principal, botão primário
  static const textoSuave = Color(0xFFC9C8C1); // Rótulos de campos
  static const cinza = Color(0xFF9A9C95); // Texto secundário, ícones
  static const nevoa = Color(0xFF5B5F5A); // Estados inativos

  // Semânticas
  static const success = Color(0xFF4CB97F); // Receita — entradas, positivo
  static const error = Color(0xFFE5705F); // Despesa — saídas, alerta
  static const warning = Color(0xFFE3A548);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.latao,
        brightness: Brightness.dark,
        primary: AppColors.lataoClaro,
        onPrimary: AppColors.background,
        secondary: AppColors.latao,
        surface: AppColors.superficie,
        onSurface: AppColors.marfim,
        outline: AppColors.linha,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.marfim,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.superficie,
        elevation: 0,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.elevado,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.elevado,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.linha,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.superficie,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.linha, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.linha, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lataoClaro, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.textoSuave),
        hintStyle: const TextStyle(color: AppColors.cinza),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.marfim,
          foregroundColor: AppColors.background,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.lataoClaro),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.lataoClaro,
        linearTrackColor: AppColors.linha,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.marfim, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppColors.marfim, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.marfim),
        bodyMedium: TextStyle(color: AppColors.cinza),
        labelLarge: TextStyle(color: AppColors.marfim),
      ),
    );
  }
}
