import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';

/// Empty State
///
/// Shows when there's no content or no saved items
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.description,
    this.icon,
    this.emoji,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData? icon;
  final String? emoji;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon or Emoji
            if (emoji != null)
              Text(
                emoji!,
                style: const TextStyle(fontSize: 48),
              )
            else if (icon != null)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: AppColors.mutedForeground,
                ),
              ),

            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              title,
              style: AppTypography.h3(color: AppColors.foreground),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            // Description
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                description,
                style: AppTypography.bodySm(color: AppColors.mutedForeground),
                textAlign: TextAlign.center,
              ),
            ),

            // Action Button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
