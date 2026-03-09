/// Single prayer row: icon, name, time, status badge, optional remaining.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/prayer/data/prayer_models.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final isNext = data.status == PrayerStatus.next;
    final isDone = data.status == PrayerStatus.done;
    final displayName = _localizedPrayerName(l10n, data.name);
    final remainingText = _localizedRemaining(context, data);

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
              displayName,
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
              if (remainingText != null && remainingText.isNotEmpty)
                Text(
                  remainingText,
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

  static String _localizedPrayerName(AppLocalizations l10n, String name) {
    switch (name) {
      case 'Fajr': return l10n.prayerFajr;
      case 'Dhuhr': return l10n.prayerDhuhr;
      case 'Asr': return l10n.prayerAsr;
      case 'Maghrib': return l10n.prayerMaghrib;
      case 'Isha': return l10n.prayerIsha;
      default: return name;
    }
  }

  static String? _localizedRemaining(BuildContext context, PrayerCardData data) {
    if (data.status != PrayerStatus.next && data.status != PrayerStatus.upcoming) {
      return null;
    }
    final timeDt = data.timeAsDateTime;
    if (timeDt == null) return data.remaining;
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    if (timeDt.isBefore(now) || timeDt.isAtSameMomentAs(now)) return l10n.remainingNow;
    final duration = timeDt.difference(now);
    final totalMinutes = duration.inMinutes;
    if (totalMinutes < 60) return l10n.remainingInMinutes(totalMinutes);
    final h = duration.inHours;
    final m = totalMinutes - (h * 60);
    if (m == 0) return l10n.remainingInHours(h);
    return l10n.remainingInHoursMinutes(h, m);
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
    final l10n = AppLocalizations.of(context)!;
    String label;
    Color bgColor;
    Color textColor;
    IconData? icon;

    switch (status) {
      case PrayerStatus.done:
        label = l10n.prayerDone;
        bgColor = AppColors.accentGreen;
        textColor = Colors.white;
        icon = LucideIcons.check;
      case PrayerStatus.next:
        label = l10n.prayerNext;
        bgColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        icon = null;
      case PrayerStatus.upcoming:
        label = l10n.prayerUpcoming;
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
