import 'package:flutter/material.dart';

/// Helper class to get theme-aware colors
/// This ensures all pages use theme colors instead of hardcoded AppColors
class ThemeHelper {
  ThemeHelper._();

  /// Get surface color (background)
  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  /// Get onSurface color (foreground text)
  static Color onSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  /// Get surfaceContainerHighest color (card background)
  static Color surfaceContainerHighest(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;

  /// Get outline color (border)
  static Color outline(BuildContext context) =>
      Theme.of(context).colorScheme.outline;

  /// Get outlineVariant color (muted background)
  static Color outlineVariant(BuildContext context) =>
      Theme.of(context).colorScheme.outlineVariant;

  /// Get primary color
  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  /// Get onPrimary color
  static Color onPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;

  /// Get muted foreground color (70% opacity)
  static Color mutedForeground(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);

  /// Get error color
  static Color error(BuildContext context) =>
      Theme.of(context).colorScheme.error;
}
