import 'package:flutter/material.dart';

import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';

/// Horizontal pagination dots (e.g. for preferences sub-steps). Selected = blue, rest = gray.
class OnboardingBottomDots extends StatelessWidget {
  const OnboardingBottomDots({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isSelected = i == currentIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? OnboardingColors.dotSelected : OnboardingColors.dotUnselected,
          ),
        );
      }),
    );
  }
}
