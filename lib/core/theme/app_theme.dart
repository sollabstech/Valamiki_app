import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/color_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.textHint,
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: AppColors.error,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: AppColors.shadow,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.bottomNavInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary.withOpacity(0.15),
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: _buildTextTheme(Colors.black),
    );
  }

  static TextTheme _buildTextTheme(Color color) {
    return TextTheme(
      displayLarge: TextStyle(fontFamily: 'Poppins', fontSize: 57, fontWeight: FontWeight.w700, color: color),
      displayMedium: TextStyle(fontFamily: 'Poppins', fontSize: 45, fontWeight: FontWeight.w700, color: color),
      displaySmall: TextStyle(fontFamily: 'Poppins', fontSize: 36, fontWeight: FontWeight.w700, color: color),
      headlineLarge: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700, color: color),
      headlineMedium: TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.w600, color: color),
      headlineSmall: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.w600, color: color),
      titleLarge: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w600, color: color),
      titleMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500, color: color),
      titleSmall: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: color),
      bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w400, color: color),
      bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w400, color: color),
      bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w400, color: color),
      labelLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: color),
      labelMedium: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: color),
      labelSmall: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w400, color: color),
    );
  }
}
