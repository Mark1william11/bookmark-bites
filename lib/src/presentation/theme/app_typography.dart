import 'package:bookmark_bites/src/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// This class holds all the text styles for the app.
class AppTypography {
  AppTypography._();

  // Using a stylish serif font for display/headings
  static final _displayFont = GoogleFonts.playfairDisplay(
    color: AppColors.textDark,
  );

  // Using a clean sans-serif for body text
  static final _bodyFont = GoogleFonts.montserrat(
    color: AppColors.textDark,
  );

  // The complete text theme for the app
  static final TextTheme textTheme = TextTheme(
    displayLarge: _displayFont.copyWith(fontSize: 57, fontWeight: FontWeight.bold),
    displayMedium: _displayFont.copyWith(fontSize: 45, fontWeight: FontWeight.bold),
    displaySmall: _displayFont.copyWith(fontSize: 36, fontWeight: FontWeight.normal),

    headlineLarge: _displayFont.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: _displayFont.copyWith(fontSize: 28, fontWeight: FontWeight.w600), // Semi-bold
    headlineSmall: _displayFont.copyWith(fontSize: 24, fontWeight: FontWeight.w600),

    titleLarge: _bodyFont.copyWith(fontSize: 22, fontWeight: FontWeight.w700), // Bold
    titleMedium: _bodyFont.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
    titleSmall: _bodyFont.copyWith(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),

    bodyLarge: _bodyFont.copyWith(fontSize: 16, fontWeight: FontWeight.normal, height: 1.5),
    bodyMedium: _bodyFont.copyWith(fontSize: 14, fontWeight: FontWeight.normal, height: 1.5),
    bodySmall: _bodyFont.copyWith(fontSize: 12, fontWeight: FontWeight.normal, height: 1.5),

    labelLarge: _bodyFont.copyWith(fontSize: 14, fontWeight: FontWeight.bold), // For buttons
    labelMedium: _bodyFont.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: _bodyFont.copyWith(fontSize: 11, fontWeight: FontWeight.normal),
  );
}