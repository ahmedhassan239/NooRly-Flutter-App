import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';

/// Stat card for Journey page header (Progress %, Done, Current Week)
class JourneyStatCard extends StatelessWidget {
  const JourneyStatCard({
    required this.value,
    required this.label,
    required this.icon,
    super.key,
    this.iconColor,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = iconColor ?? colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colorScheme.outline.withAlpha(128)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: effectiveColor,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.caption(color: colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}





