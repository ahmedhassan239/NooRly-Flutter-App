import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:overlay_support/overlay_support.dart';

class AppToast {
  /// Shows a toast notification with theme-aware colors
  /// 
  /// Uses Theme.of(context) to get current theme colors
  /// Falls back to SnackBar if context is not available
  static void show(
    String message, {
    BuildContext? context,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    Widget? icon,
  }) {
    // If context is provided, use theme colors
    if (context != null) {
      final colorScheme = Theme.of(context).colorScheme;
      showSimpleNotification(
        Text(
          message,
          style: AppTypography.bodySm(
            color: textColor ?? colorScheme.onSurface,
          ),
        ),
        background: backgroundColor ?? colorScheme.surfaceContainerHighest,
        duration: duration,
        leading: icon,
        elevation: 4,
        slideDismissDirection: DismissDirection.up,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      );
    } else {
      // Fallback for when context is not available
      showSimpleNotification(
        Text(
          message,
          style: AppTypography.bodySm(
            color: textColor ?? AppColors.foreground,
          ),
        ),
        background: backgroundColor ?? AppColors.surface,
        duration: duration,
        leading: icon,
        elevation: 4,
        slideDismissDirection: DismissDirection.up,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      );
    }
  }

  static void showSuccess(String message, {BuildContext? context}) {
    final colorScheme = context != null ? Theme.of(context).colorScheme : null;
    show(
      message,
      context: context,
      backgroundColor: colorScheme?.surfaceContainerHighest,
      icon: Icon(
        Icons.check_circle,
        color: AppColors.accentGreen,
      ),
    );
  }

  static void showError(String message, {BuildContext? context}) {
    final colorScheme = context != null ? Theme.of(context).colorScheme : null;
    show(
      message,
      context: context,
      backgroundColor: colorScheme?.surfaceContainerHighest,
      icon: Icon(
        Icons.error,
        color: AppColors.error,
      ),
    );
  }
}
