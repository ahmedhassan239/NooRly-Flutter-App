/// Rounded card for category/collection list: left icon circle, title, subtitle, chevron.
library;

import 'package:flutter/material.dart';

import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RoundedListCard extends StatelessWidget {
  const RoundedListCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveIcon = icon ?? LucideIcons.bookmark;
    final effectiveColor = iconColor ?? colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: colorScheme.outline.withAlpha(128),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: effectiveColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  effectiveIcon,
                  size: 24,
                  color: effectiveColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodySm(
                        color: colorScheme.onSurface,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTypography.caption(
                          color: colorScheme.onSurface.withAlpha(150),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: colorScheme.onSurface.withAlpha(150),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
