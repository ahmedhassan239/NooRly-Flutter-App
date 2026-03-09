import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/home/presentation/widgets/dotted_card_background.dart';
import 'package:flutter_app/features/prayer/data/prayer_models.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Section 1: Next prayer row card. Tap -> /prayer-times.
class PrayerNextCard extends StatelessWidget {
  const PrayerNextCard({
    this.nextPrayer,
    super.key,
    this.placeholder = false,
  });

  final PrayerCardData? nextPrayer;
  final bool placeholder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    if (placeholder || nextPrayer == null) {
      return DottedCard(
        onTap: () => context.go('/prayer-times'),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: _buildRow(
          context,
          title: l10n.nextPrayer,
          subtitle: l10n.setLocationForTimes,
          time: '',
          colorScheme: colorScheme,
        ),
      );
    }

    final p = nextPrayer!;
    if (kDebugMode) {
      debugPrint('[Home] Next prayer: ${p.name} at ${p.time}');
      debugPrint('[Home] Current time: ${DateTime.now()}');
      debugPrint('[Home] Remaining: ${p.remaining}');
    }

    final displayName = _localizedPrayerName(l10n, p.name);
    final displayRemaining = _formatRemainingLocalized(context, p);

    return DottedCard(
      onTap: () => context.go('/prayer-times'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: _buildRow(
        context,
        title: displayName,
        subtitle: displayRemaining,
        time: p.time,
        colorScheme: colorScheme,
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

  static String _formatRemainingLocalized(BuildContext context, PrayerCardData data) {
    final l10n = AppLocalizations.of(context)!;
    final timeDt = data.timeAsDateTime;
    if (timeDt == null) return data.remaining ?? l10n.remainingNow;
    final now = DateTime.now();
    if (!timeDt.isAfter(now)) return l10n.remainingNow;
    final duration = timeDt.difference(now);
    final totalMinutes = duration.inMinutes;
    if (totalMinutes < 60) return l10n.remainingInMinutes(totalMinutes);
    final h = duration.inHours;
    final m = totalMinutes - (h * 60);
    if (m == 0) return l10n.remainingInHours(h);
    return l10n.remainingInHoursMinutes(h, m);
  }

  Widget _buildRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
    required ColorScheme colorScheme,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.accentGold.withAlpha(25),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Icon(LucideIcons.sun, size: 22, color: AppColors.accentGold),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.h3(color: colorScheme.onSurface)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySm(
                    color: colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
        if (time.isNotEmpty)
          Text(
            time,
            style: AppTypography.bodySm(color: colorScheme.primary)
                .copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        const SizedBox(width: 8),
        Icon(
          LucideIcons.chevronRight,
          size: 20,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
