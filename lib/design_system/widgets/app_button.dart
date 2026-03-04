
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, destructive }

class AppButton extends StatelessWidget {

  const AppButton({
    required this.text, required this.onPressed, super.key,
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
    final style = _getButtonStyle();
    
    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8),
              child: CircularProgressIndicator(
                strokeWidth: 2, 
                color: variant == AppButtonVariant.outline || variant == AppButtonVariant.ghost 
                    ? AppColors.primary 
                    : AppColors.primaryForeground,
              ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconTheme(
              data: IconThemeData(size: 18, color: style.foregroundColor?.resolve({})),
              child: icon!,
            ),
          ),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
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

  ButtonStyle _getButtonStyle() {
    Color? bg;
    Color? fg;
    BorderSide? border;
    const double elevation = 0;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = AppColors.primary;
        fg = AppColors.primaryForeground;
      case AppButtonVariant.secondary:
        bg = AppColors.secondary;
        fg = AppColors.secondaryForeground;
      case AppButtonVariant.destructive:
        bg = AppColors.destructive;
        fg = AppColors.destructiveForeground;
      case AppButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.foreground;
        border = const BorderSide(color: AppColors.border);
      case AppButtonVariant.ghost:
        bg = Colors.transparent;
        fg = AppColors.foreground;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      disabledBackgroundColor: bg.withValues(alpha: 0.5),
      disabledForegroundColor: fg.withValues(alpha: 0.5),
      elevation: elevation,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
        side: border ?? BorderSide.none,
      ),
      textStyle: AppTypography.body(),
    );
  }
}
