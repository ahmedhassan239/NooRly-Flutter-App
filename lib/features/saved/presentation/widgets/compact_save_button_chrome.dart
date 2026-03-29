/// Visual chrome for the compact Save / Saved control (shared by [SaveButton] and local/mock saves).
/// Keeps Hadith, Verse, Dua, and Adhkar list cards pixel-aligned.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CompactSaveButtonChrome extends StatelessWidget {
  const CompactSaveButtonChrome({
    required this.compact,
    required this.isSaved,
    required this.isPending,
    required this.savedLabel,
    required this.saveLabel,
    required this.onTap,
    super.key,
  });

  final bool compact;
  final bool isSaved;
  final bool isPending;
  final String savedLabel;
  final String saveLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(compact ? AppRadius.sm : AppRadius.md),
      child: Opacity(
        opacity: isPending ? 0.7 : 1,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: compact ? 10 : 14,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: isSaved
                ? AppColors.accentGreen.withAlpha(25)
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(compact ? AppRadius.sm : AppRadius.md),
            border: Border.all(
              color: isSaved
                  ? AppColors.accentGreen.withAlpha(80)
                  : colorScheme.outline.withAlpha(100),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isPending)
                SizedBox(
                  width: compact ? 18 : 20,
                  height: compact ? 18 : 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                )
              else
                Icon(
                  isSaved ? LucideIcons.heartOff : LucideIcons.heart,
                  size: compact ? 18 : 20,
                  color: isSaved
                      ? AppColors.accentGreen
                      : colorScheme.onSurface.withAlpha(150),
                ),
              SizedBox(width: compact ? 6 : 8),
              Text(
                isPending ? '...' : (isSaved ? savedLabel : saveLabel),
                style: (compact
                        ? AppTypography.caption(
                            color: isSaved
                                ? AppColors.accentGreen
                                : colorScheme.onSurface.withAlpha(150),
                          )
                        : AppTypography.bodySm(
                            color: isSaved
                                ? AppColors.accentGreen
                                : colorScheme.onSurface.withAlpha(150),
                          ))
                    .copyWith(
                  fontSize: compact ? 12 : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
