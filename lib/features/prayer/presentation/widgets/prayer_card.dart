/// Single prayer row: icon, name, time, status badge, optional remaining.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/prayer/data/prayer_models.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PrayerCard extends StatelessWidget {
  const PrayerCard({
    required this.data,
    super.key,
  });

  final PrayerCardData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isNext = data.status == PrayerStatus.next;
    final isDone = data.status == PrayerStatus.done;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isNext
              ? colorScheme.primary
              : isDone
                  ? AppColors.accentGreen.withAlpha(128)
                  : colorScheme.outline.withAlpha(128),
          width: isNext ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _iconBackground(data.status, colorScheme),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                data.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              data.name,
              style: AppTypography.body(color: colorScheme.onSurface)
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.time,
                style: AppTypography.body(
                  color: isNext ? colorScheme.primary : colorScheme.onSurface,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              if (data.remaining != null && data.remaining!.isNotEmpty)
                Text(
                  data.remaining!,
                  style: AppTypography.caption(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          _StatusBadge(status: data.status, colorScheme: colorScheme),
        ],
      ),
    );
  }
}

Color _iconBackground(PrayerStatus status, ColorScheme colorScheme) {
  switch (status) {
    case PrayerStatus.done:
      return AppColors.accentGreen.withAlpha(25);
    case PrayerStatus.next:
      return colorScheme.primary.withAlpha(25);
    case PrayerStatus.upcoming:
      return colorScheme.surface;
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
    required this.colorScheme,
  });

  final PrayerStatus status;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    String label;
    Color bgColor;
    Color textColor;
    IconData? icon;

    switch (status) {
      case PrayerStatus.done:
        label = 'Done';
        bgColor = AppColors.accentGreen;
        textColor = Colors.white;
        icon = LucideIcons.check;
      case PrayerStatus.next:
        label = 'Next';
        bgColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        icon = null;
      case PrayerStatus.upcoming:
        label = 'Upcoming';
        bgColor = colorScheme.outlineVariant;
        textColor = colorScheme.onSurface.withValues(alpha: 0.7);
        icon = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.caption(color: textColor).copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
