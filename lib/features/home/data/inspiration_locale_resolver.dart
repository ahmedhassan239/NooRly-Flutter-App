/// Resolves Daily Inspiration content for a single app language.
///
/// Ensures the card shows only Arabic or only English (no mixed language).
library;

import 'package:flutter_app/core/content/library_reference_format.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/core/utils/locale_digits.dart';
import 'package:flutter_app/features/home/data/daily_inspiration_api.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

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
  AppLocalizations l10n,
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
    reference: _localizedReferenceLine(dto, localeCode, l10n),
  );
}

String _localizedReferenceLine(
  DailyInspirationDto dto,
  String localeCode,
  AppLocalizations l10n,
) {
  final raw = dto.reference.trim();
  if (raw.isEmpty) return '';

  if (!LocalizedReligiousContent.isArabicLocale(localeCode)) {
    return raw;
  }

  if (referenceContainsArabicScript(raw)) {
    return toLocaleDigits(raw, localeCode);
  }

  final t = dto.type.toLowerCase();
  if (t == 'ayah' || t == 'verse' || t == 'quran') {
    final fromFields =
        tryParseEnglishSurahNameAndAyah(dto.surah, dto.ayahNumber);
    if (fromFields != null) {
      return formatLibraryVerseReference(
        languageCode: localeCode,
        apiReference: null,
        surahNumber: fromFields.surah,
        ayahNumber: fromFields.ayah,
        surahNameEn: null,
        surahNameAr: null,
      );
    }
    final surahOnly = dto.surah?.trim();
    if (surahOnly != null && surahOnly.isNotEmpty) {
      return formatLibraryVerseReference(
        languageCode: localeCode,
        apiReference: surahOnly,
        surahNumber: null,
        ayahNumber: dto.ayahNumber,
        surahNameEn: null,
        surahNameAr: null,
      );
    }
    return formatLibraryVerseReference(
      languageCode: localeCode,
      apiReference: raw,
      surahNumber: null,
      ayahNumber: dto.ayahNumber,
      surahNameEn: null,
      surahNameAr: null,
    );
  }

  if (t == 'hadith') {
    return formatHadithSourcePlainLine(
      l10n,
      localeCode,
      dto.source ?? raw,
    );
  }

  return formatLooseReligiousSourceLine(
    l10n,
    localeCode,
    dto.source ?? raw,
    sourceAr: null,
  );
}
