import 'package:flutter/material.dart';

import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';

/// Base scaffold for onboarding screens: warm gray background, padding, scroll + bottom CTA.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.child,
    this.bottomBar,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final Widget child;
  final Widget? bottomBar;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: padding,
                child: child,
              ),
            ),
            if (bottomBar != null) bottomBar!,
          ],
        ),
      ),
    );
  }
}
