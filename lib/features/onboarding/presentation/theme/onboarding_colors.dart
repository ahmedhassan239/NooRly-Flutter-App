import 'package:flutter/material.dart';

/// Onboarding-specific colors matching the design screenshots.
/// Warm beige/orange tones, soft backgrounds, clear hierarchy.
class OnboardingColors {
  OnboardingColors._();

  /// Very light warm gray page background (#F8F8F8 / #F7F7F9)
  static const Color background = Color(0xFFF8F8F8);

  /// Primary CTA and progress bar — warm Noorly orange
  static const Color primaryOrange = Color(0xFFFF8C38);

  /// Soft beige for icon badges
  static const Color iconBadgeBeige = Color(0xFFF5E5D8);

  /// Dark navy/charcoal for titles and labels
  static const Color textPrimary = Color(0xFF333333);

  /// Muted gray for subtitles and placeholder
  static const Color textMuted = Color(0xFF757575);

  /// Subtle border gray for cards and inputs
  static const Color border = Color(0xFFE0E0E0);

  /// Selected state for chips (warm beige/orange tint)
  static const Color chipSelectedBg = Color(0xFFF5E5D8);

  /// Selected pagination dot (blue as in design)
  static const Color dotSelected = Color(0xFF2196F3);

  /// Unselected pagination dot
  static const Color dotUnselected = Color(0xFFB0BEC5);

  /// Plan timeline — accent circles
  static const Color planGreen = Color(0xFF4CAF50);
  static const Color planGreenBg = Color(0xFFE8F5E9);
  static const Color planBlue = Color(0xFF2196F3);
  static const Color planBlueBg = Color(0xFFE3F2FD);
  static const Color planOrange = Color(0xFFFF9800);
  static const Color planOrangeBg = Color(0xFFFFF3E0);

  /// Card/option background
  static const Color cardBackground = Colors.white;

  /// Goal & challenge icon accents (Step 4)
  static const Color goalBasics = Color(0xFF8D6E63);      // light brown/beige
  static const Color goalPrayer = Color(0xFFF9A825);     // gold
  static const Color goalQuran = Color(0xFF2E7D32);      // green
  static const Color goalHabits = Color(0xFFF9A825);     // gold
  static const Color goalCommunity = Color(0xFFF9A825);  // gold
  static const Color challengeArabic = Color(0xFF1976D2);   // light blue
  static const Color challengePray = Color(0xFFE65100);    // orange/red
  static const Color challengeTime = Color(0xFF8D6E63);    // beige/brown
  static const Color challengeConsistent = Color(0xFF1976D2);
  static const Color challengeDoubts = Color(0xFF616161);   // gray
  static const Color challengeSupport = Color(0xFF1976D2);
}
