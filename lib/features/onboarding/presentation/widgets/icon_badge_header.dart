import 'package:flutter/material.dart';

import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';

/// Section header: circular beige icon badge + title + subtitle.
class IconBadgeHeader extends StatelessWidget {
  const IconBadgeHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final Widget icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: OnboardingColors.iconBadgeBeige,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: icon,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTypography.h1(color: OnboardingColors.textPrimary),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: AppTypography.body(color: OnboardingColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}
