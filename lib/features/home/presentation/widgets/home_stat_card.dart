import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';

/// Statistics card showing a value with label and icon
class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    required this.value,
    required this.label,
    required this.icon,
    super.key,
    this.iconColor,
    this.iconBackgroundColor,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveIconColor = iconColor ?? colorScheme.primary;
    final effectiveIconBgColor = iconBackgroundColor ?? effectiveIconColor.withAlpha(25);

    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: colorScheme.outline.withAlpha(128)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: effectiveIconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: effectiveIconColor,
                ),
              ),
              const SizedBox(height: 12),
              // Value
              Text(
                value,
                style: AppTypography.h2(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 2),
              // Label
              Text(
                label,
                style: AppTypography.caption(color: colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





