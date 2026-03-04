/// Placeholder when user navigates to a feature that is disabled by remote config.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FeatureDisabledPage extends StatelessWidget {
  const FeatureDisabledPage({super.key, this.featureName});

  final String? featureName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final name = featureName ?? 'This feature';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.lock,
                size: 64,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Feature not available',
                style: AppTypography.h2(color: colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '$name is currently disabled. Check back later or contact support.',
                style: AppTypography.body(color: colorScheme.onSurface.withValues(alpha: 0.8)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl2),
              FilledButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
