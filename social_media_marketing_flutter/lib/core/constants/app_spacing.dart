import 'package:flutter/material.dart';

/// Application spacing and sizing constants
/// Based on 8px grid system
class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  // Base unit (8px)
  static const double baseUnit = 8.0;

  // Spacing scale
  static const double xs = baseUnit * 0.5; // 4px
  static const double sm = baseUnit * 1; // 8px
  static const double md = baseUnit * 2; // 16px
  static const double lg = baseUnit * 3; // 24px
  static const double xl = baseUnit * 4; // 32px
  static const double xxl = baseUnit * 6; // 48px
  static const double xxxl = baseUnit * 8; // 64px

  // Padding presets
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(vertical: xl);

  // Border radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 6.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusFull = 999.0;

  // BorderRadius presets
  static final BorderRadius borderRadiusXS = BorderRadius.circular(radiusXS);
  static final BorderRadius borderRadiusSM = BorderRadius.circular(radiusSM);
  static final BorderRadius borderRadiusMD = BorderRadius.circular(radiusMD);
  static final BorderRadius borderRadiusLG = BorderRadius.circular(radiusLG);
  static final BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // Icon sizes
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 48.0;

  // Button heights
  static const double buttonHeightSM = 32.0;
  static const double buttonHeightMD = 40.0;
  static const double buttonHeightLG = 48.0;

  // Input field heights
  static const double inputHeightSM = 36.0;
  static const double inputHeightMD = 44.0;
  static const double inputHeightLG = 52.0;

  // Container constraints
  static const double maxContentWidth = 1200.0;
  static const double minContentWidth = 320.0;
  static const double navigationRailWidth = 240.0;
  static const double navigationRailCollapsedWidth = 72.0;

  // Card dimensions
  static const double cardElevation = 2.0;
  static const double cardElevationHover = 8.0;

  // Divider thickness
  static const double dividerThickness = 1.0;

  // Gaps (for Row/Column spacing using Gap widgets)
  static const double gapXS = xs;
  static const double gapSM = sm;
  static const double gapMD = md;
  static const double gapLG = lg;
  static const double gapXL = xl;
}

/// SizedBox shortcuts for common spacing
class Gap extends SizedBox {
  const Gap.xs({super.key}) : super(height: AppSpacing.xs, width: AppSpacing.xs);
  const Gap.sm({super.key}) : super(height: AppSpacing.sm, width: AppSpacing.sm);
  const Gap.md({super.key}) : super(height: AppSpacing.md, width: AppSpacing.md);
  const Gap.lg({super.key}) : super(height: AppSpacing.lg, width: AppSpacing.lg);
  const Gap.xl({super.key}) : super(height: AppSpacing.xl, width: AppSpacing.xl);

  const Gap.horizontal(double width, {super.key}) : super(width: width);
  const Gap.vertical(double height, {super.key}) : super(height: height);
}
