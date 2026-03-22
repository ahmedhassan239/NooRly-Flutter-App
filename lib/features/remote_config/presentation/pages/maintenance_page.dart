/// Maintenance mode page shown when backend sets maintenance_mode = true.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/remote_config/providers/remote_config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MaintenancePage extends ConsumerWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(maintenanceMessageProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.wrench,
                size: 80,
                color: colorScheme.primary.withValues(alpha: 0.8),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Under Maintenance',
                style: AppTypography.h2(color: colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                message ?? "We're making things better. Please check back soon.",
                style: AppTypography.body(color: colorScheme.onSurface.withValues(alpha: 0.8)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl2),
              FilledButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(LucideIcons.logIn, size: 20),
                label: const Text('Go to Login'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
