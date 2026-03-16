import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';

/// Top row: back arrow, progress bar, step fraction (e.g. 2/6).
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(LucideIcons.arrowLeft, color: OnboardingColors.textPrimary),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: OnboardingColors.textPrimary,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: totalSteps > 0 ? currentStep / totalSteps : 0,
                    backgroundColor: OnboardingColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(OnboardingColors.primaryOrange),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$currentStep/$totalSteps',
                style: AppTypography.caption(color: OnboardingColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
