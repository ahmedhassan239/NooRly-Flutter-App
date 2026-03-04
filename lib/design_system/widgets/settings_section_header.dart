import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';

/// Reusable section header for Settings sections
/// Ensures consistent typography and spacing
class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.md,
      ),
      child: Text(
        title,
        style: AppTypography.body(color: colorScheme.onSurface)
            .copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
