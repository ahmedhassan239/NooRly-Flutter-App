import 'package:flutter/material.dart';

/// Design System Colors
///
/// All colors extracted from Tailwind config and index.css
/// HSL values converted to Flutter Color
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF0F5F41); // Deep Emerald
  static const Color primaryForeground = Color(0xFFF7EFE3); // Warm off-white
  static const Color primarySoftPurple = Color(0xFF2E7460); // Rich teal variant
  static const Color primaryLightBlue = Color(0xFF3B8D77); // Soft teal highlight

  // Accent Colors
  static const Color accentCoral = Color(0xFFB38B52); // Warm gold accent
  static const Color accentGreen = Color(0xFF4B8B6E); // Supportive foliage green
  static const Color accentGold = Color(0xFFC69B62); // Premium gold

  // Neutrals - Warm & Comfortable
  static const Color background = Color(0xFFF8F1E7); // Cream background
  static const Color foreground = Color(0xFF172917); // Deep text
  static const Color offWhite = Color(0xFFFAF3EB); // Soft off-white
  static const Color muted = Color(0xFFF2E7DA); // Subtle supporting tone
  static const Color mutedForeground = Color(0xFF6B6A63); // Muted text
  static const Color textTertiary = Color(0xFF7B766D); // Soft tertiary text

  // Borders & Inputs
  static const Color border = Color(0xFFD3BFA6); // Warm subtle border
  static const Color input = Color(0xFFF7EEE3); // Gentle input fill
  static const Color ring = primary;

  // Cards & Popovers
  static const Color card = Color(0xFFFFFFFF); // Clean card surface
  static const Color surface = Color(0xFFFBF5EE); // Light surface
  static const Color cardForeground = Color(0xFF172917); // Deep text
  static const Color popover = Color(0xFFFFFFFF); // Clean popover surface
  static const Color popoverForeground = Color(0xFF172917); // Deep text

  // Secondary
  static const Color secondary = Color(0xFFE9DAC8); // Soft cream surface
  static const Color secondaryForeground = foreground;

  // Accent (main accent uses gold)
  static const Color accent = accentGold;
  static const Color accentForeground = Color(0xFF1B241B); // Dark text for gold

  // Semantic Colors
  static const Color success = Color(0xFF2F8A68); // Deep success green
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFB68B4D); // Burnished gold
  static const Color info = Color(0xFF2A8D79); // Calm teal

  // Destructive
  static const Color destructive = Color(0xFFEF4444);
  static const Color destructiveForeground = Color(0xFFFFFFFF);

  // Sidebar
  static const Color sidebarBackground = Color(0xFFF9F2E7);
  static const Color sidebarForeground = foreground;
  static const Color sidebarPrimary = primary;
  static const Color sidebarPrimaryForeground = Color(0xFFFFFFFF);
  static const Color sidebarAccent = accentGold;
  static const Color sidebarAccentForeground = accentForeground;
  static const Color sidebarBorder = Color(0xFFD7C7AF);
  static const Color sidebarRing = primary;

  // Dark Mode Colors (for future dark mode support)
  static const Color darkBackground = Color(0xFF081A14); // Deep charcoal green
  static const Color darkSurface = Color(0xFF112A22); // Deep teal surface
  static const Color darkSurfaceAlt = Color(0xFF16342B); // Soft dark surface
  static const Color darkCard = Color(0xFF173427); // Elevated dark card
  static const Color darkForeground = Color(0xFFE8E3D8); // Light text
  static const Color darkMutedForeground = Color(0xFF8A8B83); // Soft muted text
  static const Color darkPrimary = Color(0xFF4C966E); // Rich dark teal
  static const Color darkSecondary = Color(0xFF1F7F69); // Calm teal accent
  static const Color darkBorder = Color(0xFF264635); // Subtle dark border

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
