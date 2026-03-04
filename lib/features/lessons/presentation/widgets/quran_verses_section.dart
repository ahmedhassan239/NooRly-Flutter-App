/// Quran verses section for the lesson details screen (Lovable-style quote cards).
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_quran_hadith_models.dart';

/// Section showing attached Quran verses with a distinct Quran-themed style.
class QuranVersesSection extends StatelessWidget {
  const QuranVersesSection({
    required this.verses,
    super.key,
  });

  final List<QuranVerse> verses;

  static const double _radius = 20;
  static const double _accentWidth = 4;
  static const double _padding = 20;

  /// Quran-themed background: subtle teal/green tint (fixed, recognizable).
  static Color _cardBackground(ColorScheme scheme) {
    return Color.lerp(
      scheme.surface,
      const Color(0xFF0D9488),
      0.06,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    if (verses.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final accent = const Color(0xFF0D9488);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(LucideIcons.bookOpen, size: 18, color: accent),
            const SizedBox(width: 8),
            Text(
              'QURAN VERSES',
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
                for (int i = 0; i < verses.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: _padding + _accentWidth,
                      endIndent: _padding,
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  _VerseTile(
                    verse: verses[i],
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

class _VerseTile extends StatelessWidget {
  const _VerseTile({
    required this.verse,
    required this.colorScheme,
    required this.padding,
  });

  final QuranVerse verse;
  final ColorScheme colorScheme;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            verse.textEn,
            style: AppTypography.body(color: colorScheme.onSurface)
                .copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              verse.reference,
              style: AppTypography.caption(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
