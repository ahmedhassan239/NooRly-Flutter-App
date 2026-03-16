import 'package:flutter/material.dart';

import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';

/// Full-width rounded card for single or multi-select. Optional leading icon, title, subtitle.
class SelectableOptionCard extends StatelessWidget {
  const SelectableOptionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.isSelected = false,
    this.showRadio = false,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool isSelected;
  final bool showRadio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: OnboardingColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? OnboardingColors.primaryOrange.withValues(alpha: 0.6) : OnboardingColors.border,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTypography.body(color: OnboardingColors.textPrimary).copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: AppTypography.bodySm(color: OnboardingColors.textMuted),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showRadio)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? OnboardingColors.primaryOrange : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? OnboardingColors.primaryOrange : OnboardingColors.border,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
