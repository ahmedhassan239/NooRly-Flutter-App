import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';

/// Reusable card widget for Settings sections
/// Ensures consistent styling across all settings cards
class SettingsCard extends StatelessWidget {
  const SettingsCard({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colorScheme.outline.withAlpha(128),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
