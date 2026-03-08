/// Journey-style section icon: same visual treatment as Lessons / Journey Weeks.
///
/// Matches [WeekCard] icon container exactly (week_card.dart):
/// - Container(width:40, height:40), radius 10, outlineVariant background.
/// - Glyph rendered as Text emoji at fontSize 20 — same as week_card.dart _buildWeekIcon Text branch.
/// Use for Hadith Collections, Verse Collections, Categories, Duas, Adhkar.
/// Pass emoji string from [iconForHadithCollection] / [iconForVerseCollection] / [iconForCategory].
library;

import 'package:flutter/material.dart';

/// Icon container size — matches Journey Week card.
const double noorlySectionIconSize = 40;
/// Container border radius — matches Journey Week card.
const double noorlySectionIconRadius = 10;
/// Emoji font size — matches week_card.dart Text(week.icon, style: TextStyle(fontSize: 20)).
const double noorlySectionIconGlyphSize = 20;
/// Gap between icon container and title — matches week_card.dart Row spacing.
const double noorlySectionIconGap = 12;

/// Reusable section icon widget.
/// [icon] must be an emoji string (e.g. '🕌', '📖', '💚').
/// Container style is fixed; only the emoji glyph changes per item.
class NoorlySectionIcon extends StatelessWidget {
  const NoorlySectionIcon({
    required this.icon,
    super.key,
  });

  final String icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: noorlySectionIconSize,
      height: noorlySectionIconSize,
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(noorlySectionIconRadius),
      ),
      child: Center(
        child: Text(
          icon,
          style: const TextStyle(fontSize: noorlySectionIconGlyphSize),
        ),
      ),
    );
  }
}
