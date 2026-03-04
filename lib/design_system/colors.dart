import 'package:flutter/material.dart';

/// Design System Colors
///
/// All colors extracted from Tailwind config and index.css
/// HSL values converted to Flutter Color
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF1E40AF); // HSL(221, 83%, 40%) - Deep Blue
  static const Color primaryForeground = Color(0xFFFAFBFF); // HSL(210, 40%, 98%)
  static const Color primarySoftPurple = Color(0xFF8B5CF6); // HSL(258, 90%, 66%) - Soft Purple
  static const Color primaryLightBlue = Color(0xFF3B82F6); // HSL(217, 91%, 60%) - Light Blue

  // Accent Colors
  static const Color accentCoral = Color(0xFFFB923C); // HSL(27, 96%, 61%) - Warm Coral
  static const Color accentGreen = Color(0xFF10B981); // HSL(160, 84%, 39%) - Soft Green
  static const Color accentGold = Color(0xFFF59E0B); // HSL(38, 92%, 50%) - Gold

  // Neutrals - Warm & Comfortable
  static const Color background = Color(0xFFF5F7FA); // HSL(220, 30%, 96%) - Warm Off-White
  static const Color foreground = Color(0xFF1F2937); // HSL(220, 25%, 14%) - Rich Dark
  static const Color offWhite = Color(0xFFEBEEF3); // HSL(220, 25%, 94%)
  static const Color muted = Color(0xFFEFEFF0); // HSL(220, 20%, 94%)
  static const Color mutedForeground = Color(0xFF52596B); // HSL(220, 15%, 38%)
  static const Color textTertiary = Color(0xFF7A8096); // HSL(220, 12%, 52%)

  // Borders & Inputs
  static const Color border = Color(0xFFD5D9E0); // HSL(220, 18%, 86%)
  static const Color input = Color(0xFFE8EAEE); // HSL(220, 20%, 92%)
  static const Color ring = Color(0xFF1E40AF); // HSL(221, 83%, 40%)

  // Cards & Popovers
  static const Color card = Color(0xFFFDFDFE); // HSL(220, 30%, 99%)
  static const Color surface = card; // Reference card for toast/notification backgrounds
  static const Color cardForeground = Color(0xFF1F2937); // HSL(220, 25%, 14%)
  static const Color popover = Color(0xFFFDFDFE); // HSL(220, 30%, 99%)
  static const Color popoverForeground = Color(0xFF1F2937); // HSL(220, 25%, 14%)

  // Secondary
  static const Color secondary = Color(0xFFEBEEF3); // HSL(220, 25%, 94%)
  static const Color secondaryForeground = Color(0xFF1F2937); // HSL(220, 25%, 14%)

  // Accent (main accent uses coral)
  static const Color accent = Color(0xFFFB923C); // HSL(27, 96%, 61%)
  static const Color accentForeground = Color(0xFFFFFFFF); // White

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // HSL(160, 84%, 39%)
  static const Color error = Color(0xFFEF4444); // HSL(0, 84%, 60%)
  static const Color warning = Color(0xFFF59E0B); // HSL(38, 92%, 50%)
  static const Color info = Color(0xFF3B82F6); // HSL(217, 91%, 60%)

  // Destructive
  static const Color destructive = Color(0xFFEF4444); // HSL(0, 84%, 60%)
  static const Color destructiveForeground = Color(0xFFFAFBFF); // HSL(210, 40%, 98%)

  // Sidebar
  static const Color sidebarBackground = Color(0xFFFAFBFC); // HSL(210, 20%, 98%)
  static const Color sidebarForeground = Color(0xFF1E293B); // HSL(215, 28%, 17%)
  static const Color sidebarPrimary = Color(0xFF1E40AF); // HSL(221, 83%, 40%)
  static const Color sidebarPrimaryForeground = Color(0xFFFFFFFF); // White
  static const Color sidebarAccent = Color(0xFFFB923C); // HSL(27, 96%, 61%)
  static const Color sidebarAccentForeground = Color(0xFFFFFFFF); // White
  static const Color sidebarBorder = Color(0xFFE5E7EB); // HSL(220, 13%, 91%)
  static const Color sidebarRing = Color(0xFF1E40AF); // HSL(221, 83%, 40%)

  // Dark Mode Colors (for future dark mode support)
  static const Color darkBackground = Color(0xFF121212); // HSL(0, 0%, 7%)
  static const Color darkForeground = Color(0xFFFFFFFF); // White
  static const Color darkPrimary = Color(0xFF60A5FA); // HSL(217, 91%, 60%) - Lighter blue
  static const Color darkCard = Color(0xFF1F1F1F); // HSL(0, 0%, 12%)
  static const Color darkBorder = Color(0xFF333333); // HSL(0, 0%, 20%)

  /// Parses a HEX color string to [Color].
  /// Supports #RRGGBB and #AARRGGBB. Returns null if invalid.
  static Color? fromHex(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    var s = hex.trim();
    if (s.startsWith('#')) s = s.substring(1);
    if (s.length == 6) {
      final r = int.tryParse(s.substring(0, 2), radix: 16);
      final g = int.tryParse(s.substring(2, 4), radix: 16);
      final b = int.tryParse(s.substring(4, 6), radix: 16);
      if (r != null && g != null && b != null) {
        return Color(0xFF000000 | (r << 16) | (g << 8) | b);
      }
    } else if (s.length == 8) {
      final a = int.tryParse(s.substring(0, 2), radix: 16);
      final r = int.tryParse(s.substring(2, 4), radix: 16);
      final g = int.tryParse(s.substring(4, 6), radix: 16);
      final b = int.tryParse(s.substring(6, 8), radix: 16);
      if (a != null && r != null && g != null && b != null) {
        return Color((a << 24) | (r << 16) | (g << 8) | b);
      }
    }
    return null;
  }
}
