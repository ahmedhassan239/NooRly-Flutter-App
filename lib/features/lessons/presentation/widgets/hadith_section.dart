/// Hadith section for the lesson details screen (Lovable-style quote cards).
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/core/content/content_display_normalize.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_quran_hadith_models.dart';

/// Section showing attached Hadith items with a distinct Hadith-themed style.
class HadithSection extends StatelessWidget {
  const HadithSection({
    required this.items,
    super.key,
  });

  final List<HadithItem> items;

  static const double _radius = 20;
  static const double _accentWidth = 4;
  static const double _padding = 20;

  /// Hadith-themed background: subtle amber/warm tint (fixed, distinct from Quran).
  static Color _cardBackground(ColorScheme scheme) {
    return Color.lerp(
      scheme.surface,
      const Color(0xFFB45309),
      0.06,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final accent = const Color(0xFFB45309);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(LucideIcons.quote, size: 18, color: accent),
            const SizedBox(width: 8),
            Text(
              'HADITH',
              style: AppTypography.caption(color: accent)
                  .copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _cardBackground(colorScheme),
            borderRadius: BorderRadius.circular(_radius),
            border: Border(
              left: BorderSide(color: accent, width: _accentWidth),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: _padding + _accentWidth,
                      endIndent: _padding,
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  _HadithTile(
                    item: items[i],
                    colorScheme: colorScheme,
                    padding: _padding,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HadithTile extends StatelessWidget {
  const _HadithTile({
    required this.item,
    required this.colorScheme,
    required this.padding,
  });

  final HadithItem item;
  final ColorScheme colorScheme;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final body = ContentDisplayNormalize.forDisplay(item.textEn);
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            body,
            style: AppTypography.body(color: colorScheme.onSurface).copyWith(
                  height: 1.55,
                  fontSize: 15,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.reference,
            style: AppTypography.caption(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
