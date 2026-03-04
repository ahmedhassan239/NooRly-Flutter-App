import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/typography.dart';

/// Section title with optional "See All" action
class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle({
    required this.title,
    super.key,
    this.onSeeAll,
    this.seeAllText = 'See All',
    this.padding,
  });

  final String title;
  final VoidCallback? onSeeAll;
  final String seeAllText;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.h3(color: colorScheme.onSurface),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                seeAllText,
                style: AppTypography.bodySm(color: colorScheme.primary),
              ),
            ),
        ],
      ),
    );
  }
}





