import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application typography system
/// Uses Inter font family for modern, professional look
class AppTypography {
  // Prevent instantiation
  AppTypography._();

  // Font family
  static const String fontFamily = 'Inter';

  // Display text styles (largest headings)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.25,
    letterSpacing: -0.25,
  );

  // Heading text styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Title text styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body text styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Label text styles (for buttons, inputs, etc.)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // Helper methods to get colored text styles
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // Commonly used text styles with colors
  static TextStyle get headingPrimary => headlineMedium.copyWith(
        color: AppColors.textPrimaryLight,
      );

  static TextStyle get headingSecondary => titleMedium.copyWith(
        color: AppColors.textSecondaryLight,
      );

  static TextStyle get bodyPrimary => bodyMedium.copyWith(
        color: AppColors.textPrimaryLight,
      );

  static TextStyle get bodySecondary => bodyMedium.copyWith(
        color: AppColors.textSecondaryLight,
      );

  static TextStyle get buttonText => labelLarge.copyWith(
        color: Colors.white,
      );

  static TextStyle get linkText => labelMedium.copyWith(
        color: AppColors.primaryBlue,
        decoration: TextDecoration.underline,
      );

  static TextStyle get caption => bodySmall.copyWith(
        color: AppColors.textSecondaryLight,
      );

  static TextStyle get overline => labelSmall.copyWith(
        color: AppColors.textSecondaryLight,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w700,
      );
}
