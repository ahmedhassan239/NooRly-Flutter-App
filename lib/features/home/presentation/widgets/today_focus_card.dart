import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/home/presentation/widgets/dotted_card_background.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Section 3: Today's Focus card. Rows: Continue lesson, Dhikr, Prepare for prayer.
class TodayFocusCard extends StatelessWidget {
  const TodayFocusCard({
    super.key,
    this.onContinueLesson,
    this.onPrepareForPrayer,
  });

  final VoidCallback? onContinueLesson;
  final VoidCallback? onPrepareForPrayer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return DottedCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.todaysFocus,
            style: AppTypography.h3(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          _FocusRow(
            icon: LucideIcons.bookOpen,
            label: l10n.continueYourLesson,
            onTap: onContinueLesson,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 10),
          _FocusRow(
            icon: LucideIcons.sparkles,
            label: l10n.takeTwoMinutesForDhikr,
            onTap: () => context.push('/adhkar'),
            colorScheme: colorScheme,
          ),
          if (onPrepareForPrayer != null) ...[
            const SizedBox(height: 10),
            _FocusRow(
              icon: LucideIcons.clock,
              label: l10n.prepareForNextPrayer,
              onTap: onPrepareForPrayer,
              colorScheme: colorScheme,
            ),
          ],
        ],
      ),
    );
  }
}

class _FocusRow extends StatelessWidget {
  const _FocusRow({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: colorScheme.onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: AppTypography.body(color: colorScheme.onSurface)),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
