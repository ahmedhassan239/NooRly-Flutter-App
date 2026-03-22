/// Resolves Daily Inspiration content for a single app language.
///
/// Ensures the card shows only Arabic or only English (no mixed language).
library;

import 'package:flutter_app/features/home/data/daily_inspiration_api.dart';

/// Locale-specific content for the Daily Inspiration card.
/// Use this for rendering; do not mix [mainContent] with the other language.
class LocalizedInspirationContent {
  const LocalizedInspirationContent({
    required this.mainContent,
    required this.isRtl,
    required this.reference,
  });

  /// The single block of text to display (Arabic only or English only).
  final String mainContent;

  /// True when content is Arabic (RTL alignment).
  final bool isRtl;

  /// Source/reference line (surah, hadith source, etc.). May be localized by API.
  final String reference;
}

/// Returns content for the Daily Inspiration card in one language only.
///
/// - **Arabic locale** (`ar`): show [dto.arabic] only. Fallback to [dto.translation]
///   if Arabic is empty (e.g. API returned translation only).
/// - **English locale** (default): show [dto.translation] only. Fallback to [dto.arabic]
///   if translation is empty.
///
/// [localeCode] should be the current app locale (e.g. from [Locale.languageCode]).
LocalizedInspirationContent resolveInspirationByLocale(
  DailyInspirationDto dto,
  String localeCode,
) {
  final isArabic = localeCode.toLowerCase() == 'ar';

  String mainContent;
  if (isArabic) {
    mainContent = dto.arabic.trim().isNotEmpty ? dto.arabic : dto.translation;
  } else {
    mainContent = dto.translation.trim().isNotEmpty ? dto.translation : dto.arabic;
  }

  return LocalizedInspirationContent(
    mainContent: mainContent,
    isRtl: isArabic,
    reference: dto.reference,
  );
}
