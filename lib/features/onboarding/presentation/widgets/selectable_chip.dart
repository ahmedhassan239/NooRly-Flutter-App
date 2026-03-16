import 'package:flutter/material.dart';

import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';

/// Pill chip with optional leading icon. Selected = beige bg, white-ish text.
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Widget? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: Material(
        color: isSelected ? OnboardingColors.chipSelectedBg : OnboardingColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? OnboardingColors.primaryOrange.withValues(alpha: 0.5) : OnboardingColors.border,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      size: 18,
                      color: isSelected ? OnboardingColors.primaryOrange : OnboardingColors.textPrimary,
                    ),
                    child: icon!,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTypography.bodySm(
                    color: isSelected ? OnboardingColors.textPrimary : OnboardingColors.textPrimary,
                  ).copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
