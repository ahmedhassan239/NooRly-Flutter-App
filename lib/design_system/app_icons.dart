import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// App Icons
///
/// Centralized icon system for consistent icon usage across the app.
/// All icons use Lucide Icons for consistency.
/// For custom SVG icons like the flock logo, use flutter_svg directly.
class AppIcons {
  AppIcons._();

  /// Spiritual Mark - Flock of Birds (Primary Icon)
  /// Use flutter_svg with 'assets/brand/flock_logo.svg' for this icon
  /// This is the centralized spiritual icon replacing all sparkle/bonus icons
  static const String flockBirdSvg = 'assets/brand/flock_logo.svg';

  /// Bonus/Highlight icon - Crescent Moon (Alternative)
  /// Used for bonus weeks, highlights, special features
  static const IconData bonus = LucideIcons.moon;

  /// Alternative bonus icon - mosque/landmark
  /// Can be used as an alternative to crescent moon
  static const IconData mosque = LucideIcons.landmark;

  /// Prayer icon
  static const IconData prayer = LucideIcons.heart;

  /// Tasbih/Dhikr icon
  static const IconData tasbih = LucideIcons.circle;
}
