import 'package:flutter/material.dart';

import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';

/// Single-select row with radio on the right (for "When did you embrace Islam?" etc.).
class SelectableRadioRow extends StatelessWidget {
  const SelectableRadioRow({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
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
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.body(color: OnboardingColors.textPrimary),
                  ),
                ),
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
