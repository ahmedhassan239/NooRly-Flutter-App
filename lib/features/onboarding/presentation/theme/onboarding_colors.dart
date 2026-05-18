import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';

/// Onboarding-specific colors matching the refreshed brand palette.
/// Uses the new Qaf emerald/teal/gold system for CTAs, accents, and charts.
class OnboardingColors {
  OnboardingColors._();

  /// Very light warm cream page background.
  static const Color background = AppColors.background;

  /// Primary CTA and progress bar — premium gold accent.
  static const Color primaryOrange = AppColors.accentGold;

  /// Soft cream accent for icon badges.
  static const Color iconBadgeBeige = AppColors.secondary;

  /// Deep foreground text for titles and labels.
  static const Color textPrimary = AppColors.foreground;

  /// Muted supporting text.
  static const Color textMuted = AppColors.mutedForeground;

  /// Warm subtle border for cards and inputs.
  static const Color border = AppColors.border;

  /// Selected state for chips.
  static const Color chipSelectedBg = AppColors.secondary;

  /// Selected pagination dot — brand teal.
  static const Color dotSelected = AppColors.primarySoftPurple;

  /// Unselected pagination dot.
  static const Color dotUnselected = Color(0xFFB0BEC5);

  /// Plan timeline — accent circles.
  static const Color planGreen = AppColors.accentGreen;
  static const Color planGreenBg = Color(0xFFE8F1EA);
  static const Color planBlue = AppColors.primarySoftPurple;
  static const Color planBlueBg = Color(0xFFDCE9E4);
  static const Color planOrange = AppColors.accentGold;
  static const Color planOrangeBg = Color(0xFFFFF2E1);

  /// Card/option background.
  static const Color cardBackground = Colors.white;

  /// Goal & challenge icon accents (Step 4).
  static const Color goalBasics = AppColors.secondary;
  static const Color goalPrayer = AppColors.accentGold;
  static const Color goalQuran = AppColors.accentGreen;
  static const Color goalHabits = AppColors.accentGold;
  static const Color goalCommunity = AppColors.accentGold;
  static const Color challengeArabic = AppColors.primarySoftPurple;
  static const Color challengePray = AppColors.accentGold;
  static const Color challengeTime = AppColors.primary;
  static const Color challengeConsistent = AppColors.primarySoftPurple;
  static const Color challengeDoubts = AppColors.mutedForeground;
  static const Color challengeSupport = AppColors.primarySoftPurple;
}
