import 'package:bookmark_bites/src/presentation/theme/app_colors.dart';
import 'package:bookmark_bites/src/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';

// This class holds the main theme data for the app.
class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      background: AppColors.background,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: AppColors.textDark,
      onSurface: AppColors.textDark,
      onError: Colors.white,
    ),

    // Typography
    textTheme: AppTypography.textTheme,

    // Component Themes
    scaffoldBackgroundColor: AppColors.background,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent, // Prevents color change on scroll
      iconTheme: const IconThemeData(color: AppColors.textDark),
      titleTextStyle: AppTypography.textTheme.headlineSmall,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTypography.textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );

  // We can define a darkTheme later if needed.
  // static final ThemeData darkTheme = ThemeData(...);
}