import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, destructive }

/// Theme-aware button: resolves colors from `Theme.of(context).colorScheme` so
/// light and dark modes stay readable (avoids hardcoded `AppColors` on dark UI).
class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = _variantColors(colorScheme);
    final style = _getButtonStyle(context, colorScheme, colors);
    final labelStyle = AppTypography.buttonLabel(context, color: colors.fg);

    final textWidget = Text(
      text,
      style: labelStyle,
      textAlign: TextAlign.center,
      maxLines: 2,
      softWrap: true,
      overflow: TextOverflow.clip,
    );

    final Widget content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.fg,
              ),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: IconTheme(
              data: IconThemeData(size: 20, color: colors.fg),
              child: icon!,
            ),
          ),
        if (fullWidth) Expanded(child: textWidget) else textWidget,
      ],
    );

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: content,
    );

    if (fullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button.animate().scale(duration: 100.ms, curve: Curves.easeOut);
  }

  /// Resolved colors for the active variant (enabled state).
  ({Color bg, Color fg, BorderSide border}) _variantColors(ColorScheme cs) {
    return switch (variant) {
      AppButtonVariant.primary => (
          bg: cs.primary,
          fg: cs.onPrimary,
          border: BorderSide.none,
        ),
      AppButtonVariant.secondary => (
          bg: cs.surfaceContainerHighest,
          fg: cs.onSurface,
          border: BorderSide.none,
        ),
      AppButtonVariant.destructive => (
          bg: cs.error,
          fg: cs.onError,
          border: BorderSide.none,
        ),
      AppButtonVariant.outline => (
          bg: Colors.transparent,
          fg: cs.onSurface,
          border: BorderSide(color: cs.outline.withValues(alpha: 0.65)),
        ),
      AppButtonVariant.ghost => (
          bg: Colors.transparent,
          fg: cs.onSurface,
          border: BorderSide.none,
        ),
    };
  }

  ButtonStyle _getButtonStyle(
    BuildContext context,
    ColorScheme cs,
    ({Color bg, Color fg, BorderSide border}) colors,
  ) {
    final disabledBg = variant == AppButtonVariant.outline ||
            variant == AppButtonVariant.ghost
        ? Colors.transparent
        : Color.alphaBlend(
            cs.onSurface.withValues(alpha: 0.12),
            colors.bg,
          );

    return ElevatedButton.styleFrom(
      backgroundColor: colors.bg,
      foregroundColor: colors.fg,
      disabledBackgroundColor: disabledBg,
      disabledForegroundColor: cs.onSurface.withValues(alpha: 0.42),
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 12,
      ),
      minimumSize: const Size(64, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
        side: colors.border,
      ),
      textStyle: AppTypography.buttonLabel(context, color: colors.fg),
    );
  }
}
