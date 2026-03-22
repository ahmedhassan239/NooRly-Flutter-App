/// Journey-style section icon: same visual treatment as Lessons / Journey Weeks.
///
/// Matches [WeekCard] icon container exactly (week_card.dart):
/// - Container(width:40, height:40), radius 10, outlineVariant background.
/// - Glyph rendered as Text emoji at fontSize 20 — same as week_card.dart _buildWeekIcon Text branch.
/// Use for Hadith Collections, Verse Collections, Categories, Duas, Adhkar.
/// Pass emoji string from [iconForHadithCollection] / [iconForVerseCollection] / [iconForCategory].
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/widgets/backend_remote_icon.dart';

/// Icon container size — matches Journey Week card.
const double noorlySectionIconSize = 40;
/// Container border radius — matches Journey Week card.
const double noorlySectionIconRadius = 10;
/// Emoji font size — matches week_card.dart Text(week.icon, style: TextStyle(fontSize: 20)).
const double noorlySectionIconGlyphSize = 20;
/// Gap between icon container and title — matches week_card.dart Row spacing.
const double noorlySectionIconGap = 12;

/// Reusable section icon widget.
/// Prefer [iconUrl] from the API when set (SVG/PNG via [BackendRemoteIcon]);
/// otherwise [icon] is an emoji string (e.g. '🕌', '📖', '💚').
class NoorlySectionIcon extends StatelessWidget {
  const NoorlySectionIcon({
    required this.icon,
    super.key,
    this.iconUrl,
  });

  /// Emoji fallback when [iconUrl] is null/empty.
  final String icon;

  /// Backend `icon_url` (absolute or site-relative).
  final String? iconUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final url = iconUrl?.trim();
    final resolved = url != null && url.isNotEmpty
        ? (ApiConfig.resolvePublicUrl(url) ?? url)
        : null;

    return Container(
      width: noorlySectionIconSize,
      height: noorlySectionIconSize,
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(noorlySectionIconRadius),
      ),
      child: Center(
        child: resolved != null
            ? BackendRemoteIcon(
                url: resolved,
                size: noorlySectionIconGlyphSize + 4,
                fallback: Text(
                  icon,
                  style: const TextStyle(fontSize: noorlySectionIconGlyphSize),
                ),
              )
            : Text(
                icon,
                style: const TextStyle(fontSize: noorlySectionIconGlyphSize),
              ),
      ),
    );
  }
}
