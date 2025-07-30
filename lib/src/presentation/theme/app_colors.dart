import 'package:flutter/material.dart';

// This class holds all the custom color palettes for the app.
class AppColors {
  AppColors._(); // This class is not meant to be instantiated.

  // Primary Palette
  static const Color primary = Color(0xFFE57F34); // A rich, warm orange
  static const Color primaryDark = Color(0xFFD16A2D); // A darker shade for gradients or highlights
  
  // Accent Palette
  static const Color accent = Color(0xFF2E8B57); // SeaGreen, for a fresh, complementary accent

  // Neutral Palette
  static const Color textDark = Color(0xFF212121); // A soft, dark charcoal for text
  static const Color textLight = Color(0xFF757575); // A lighter grey for subtitles and captions
  static const Color background = Color(0xFFFFF8F0); // A warm, creamy off-white
  static const Color surface = Color(0xFFFFFFFF); // Pure white for cards and surfaces
  static const Color border = Color(0xFFE0E0E0); // A light grey for borders and dividers

  // Feedback Palette
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
}