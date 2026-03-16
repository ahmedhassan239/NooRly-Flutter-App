import 'package:flutter/material.dart';

import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';

/// One row in the "Your Starting Plan" timeline: circle icon + week label + title + subtitle.
class PlanTimelineItem extends StatelessWidget {
  const PlanTimelineItem({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.weekLabel,
    required this.title,
    required this.subtitle,
  });

  final Widget icon;
  final Color iconBgColor;
  final String weekLabel;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: icon,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weekLabel,
                  style: AppTypography.caption(color: OnboardingColors.textMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: AppTypography.body(color: OnboardingColors.textPrimary).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySm(color: OnboardingColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
