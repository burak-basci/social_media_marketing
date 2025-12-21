import 'package:flutter/material.dart';

/// Application color palette
/// Based on modern social media marketing platform design
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary colors - Blue for trust and professionalism
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueDark = Color(0xFF1E40AF);
  static const Color primaryBlueLight = Color(0xFF3B82F6);

  // Success - Green for completed posts and positive actions
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color successLight = Color(0xFF34D399);

  // Warning - Amber for scheduled posts and pending actions
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFBBF24);

  // Error - Red for failed posts and errors
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFF87171);

  // Neutral colors - For backgrounds, text, and borders
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral900 = Color(0xFF171717);

  // Platform-specific accent colors
  static const Color platformX = Color(0xFF1DA1F2);
  static const Color platformLinkedIn = Color(0xFF0A66C2);
  static const Color platformInstagram = Color(0xFFE4405F);
  static const Color platformFacebook = Color(0xFF1877F2);
  static const Color platformPinterest = Color(0xFFE60023);

  // Background colors
  static const Color backgroundLight = neutral50;
  static const Color backgroundDark = neutral900;
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = neutral800;

  // Text colors
  static const Color textPrimaryLight = neutral900;
  static const Color textSecondaryLight = neutral600;
  static const Color textDisabledLight = neutral400;

  static const Color textPrimaryDark = neutral50;
  static const Color textSecondaryDark = neutral300;
  static const Color textDisabledDark = neutral500;

  // Border colors
  static const Color borderLight = neutral200;
  static const Color borderDark = neutral700;

  // Shadow colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);
}
