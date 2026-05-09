import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Application typography system
/// Uses Inter font family with proper weights:
/// - Headline: Inter SemiBold (w600)
/// - Subline/Body: Inter Regular (w400)
/// - CTA: Inter SemiBold (w600)
class AppTypography {
  // Prevent instantiation
  AppTypography._();

  // ─── Headline styles: Inter SemiBold ──────────────────────────────────────

  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get displaySmall => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.25,
      );

  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // ─── Body / Subline styles: Inter Regular ─────────────────────────────────

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // ─── Label / CTA styles: Inter SemiBold ───────────────────────────────────

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.1,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.1,
      );

  // ─── Helper methods ────────────────────────────────────────────────────────

  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);

  // Commonly used text styles with colors
  static TextStyle get headingPrimary =>
      headlineMedium.copyWith(color: AppColors.textPrimaryLight);

  static TextStyle get headingSecondary =>
      titleMedium.copyWith(color: AppColors.textSecondaryLight);

  static TextStyle get bodyPrimary =>
      bodyMedium.copyWith(color: AppColors.textPrimaryLight);

  static TextStyle get bodySecondary =>
      bodyMedium.copyWith(color: AppColors.textSecondaryLight);

  static TextStyle get buttonText => labelLarge.copyWith(color: Colors.white);

  static TextStyle get linkText => labelMedium.copyWith(
        color: AppColors.primaryBlue,
        decoration: TextDecoration.underline,
      );

  static TextStyle get caption =>
      bodySmall.copyWith(color: AppColors.textSecondaryLight);

  static TextStyle get overline => labelSmall.copyWith(
        color: AppColors.textSecondaryLight,
        letterSpacing: 0.5,
      );
}
