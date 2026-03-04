import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/app_icons.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Helper widget to render icons, with special handling for star/sparkle icons
/// to display as Islamic-themed bonus icon (crescent moon)
class IconHelper extends StatelessWidget {
  const IconHelper({
    required this.icon,
    required this.color,
    this.size = 24.0,
    super.key,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Check if this is a star icon and replace with Islamic bonus icon
    if (icon == LucideIcons.star) {
      return Icon(
        AppIcons.bonus,
        color: color,
        size: size,
      );
    }
    
    // For all other icons, use the regular Icon widget
    return Icon(
      icon,
      color: color,
      size: size,
    );
  }
}
