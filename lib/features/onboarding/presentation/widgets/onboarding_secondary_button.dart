import 'package:flutter/material.dart';

import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';

/// "Skip for now" text button below primary CTA.
class OnboardingSecondaryButton extends StatelessWidget {
  const OnboardingSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: AppTypography.bodySm(color: OnboardingColors.textMuted),
          ),
        ),
      ),
    );
  }
}
