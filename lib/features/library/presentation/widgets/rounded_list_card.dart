/// Rounded card for category/collection list: left emoji icon (Journey Week style), title, subtitle, chevron.
///
/// Pass [icon] as an emoji string from the backend-driven mapper
/// (e.g. [iconForHadithCollection], [iconForVerseCollection], [iconForCategory]).
library;

import 'package:flutter/material.dart';

import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/noorly_section_icon.dart'
    show NoorlySectionIcon, noorlySectionIconGap;
import 'package:lucide_icons/lucide_icons.dart';

class RoundedListCard extends StatelessWidget {
  const RoundedListCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon,
    this.iconUrl,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  /// Emoji string for the icon. Falls back to 🔖 when null.
  final String? icon;

  /// When set, [NoorlySectionIcon] loads this URL (API `icon_url`).
  final String? iconUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveIcon = icon ?? '🔖';

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
              NoorlySectionIcon(icon: effectiveIcon, iconUrl: iconUrl),
              const SizedBox(width: noorlySectionIconGap),
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
