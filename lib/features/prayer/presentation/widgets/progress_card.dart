/// Daily progress card: completed / missed / remaining.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/prayer/data/prayer_models.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.progress,
    super.key,
  });

  final DailyProgressData progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colorScheme.outline.withAlpha(128)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.trendingUp,
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.dailyProgress,
                  style: AppTypography.bodySm(color: colorScheme.onSurface)
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  progress.fraction,
                  style: AppTypography.bodySm(color: colorScheme.primary)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    value: progress.completed.toString(),
                    label: AppLocalizations.of(context)!.prayerCompleted,
                    valueColor: colorScheme.primary,
                    colorScheme: colorScheme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(
                    value: progress.missed.toString(),
                    label: AppLocalizations.of(context)!.prayerMissed,
                    valueColor: colorScheme.error,
                    colorScheme: colorScheme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(
                    value: progress.remaining.toString(),
                    label: AppLocalizations.of(context)!.prayerRemaining,
                    valueColor: colorScheme.onSurface,
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.colorScheme,
  });

  final String value;
  final String label;
  final Color valueColor;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.h2(color: valueColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.caption(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ).copyWith(
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
