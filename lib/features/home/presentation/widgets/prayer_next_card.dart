import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/home/presentation/widgets/dotted_card_background.dart';
import 'package:flutter_app/features/prayer/data/prayer_models.dart';
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

    if (placeholder || nextPrayer == null) {
      return DottedCard(
        onTap: () => context.go('/prayer-times'),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: _buildRow(
          context,
          title: 'Next Prayer',
          subtitle: 'Set location for times',
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

    return DottedCard(
      onTap: () => context.go('/prayer-times'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: _buildRow(
        context,
        title: p.name,
        subtitle: p.remaining ?? 'now',
        time: p.time,
        colorScheme: colorScheme,
      ),
    );
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
          child: const Icon(
            LucideIcons.sun,
            size: 22,
            color: AppColors.accentGold,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.h3(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySm(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
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
