import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/home/presentation/widgets/home_card.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Section 5: Need Help Now? – white card, green icon in circle, title, subtitle, chevron.
class NeedHelpCard extends StatelessWidget {
  const NeedHelpCard({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return HomeCard(
      onTap: onTap ?? () {},
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withAlpha(25),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              LucideIcons.helpCircle,
              size: 22,
              color: AppColors.accentGreen,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.needHelpNow,
                  style: AppTypography.body(color: colorScheme.onSurface)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!.quickSupportWhenYouNeedIt,
                  style: AppTypography.bodySm(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            size: 20,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
