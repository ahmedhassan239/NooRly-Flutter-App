import 'package:flutter/material.dart';

import 'package:flutter_app/core/content/content_display_normalize.dart';

/// Shared rules for duas, adhkar, hadith, and verses:
/// - Arabic UI (`ar`): show Arabic body only, RTL.
/// - English UI: show English translation only, LTR (fallback to Arabic if translation empty).
abstract final class LocalizedReligiousContent {
  LocalizedReligiousContent._();

  static bool isArabicLocale(String languageCode) {
    final lc = languageCode.toLowerCase();
    return lc == 'ar' || lc.startsWith('ar_');
  }

  static TextDirection textDirectionFor(String languageCode) =>
      isArabicLocale(languageCode) ? TextDirection.rtl : TextDirection.ltr;

  /// Strips a single pair of surrounding ASCII quotes from API/mock strings.
  static String normalizedTranslation(String translation) {
    var t = translation.trim();
    if (t.length >= 2 && t.startsWith('"') && t.endsWith('"')) {
      t = t.substring(1, t.length - 1).trim();
    }
    return t;
  }

  /// Primary paragraph for cards and detail screens.
  static String primaryBody({
    required String languageCode,
    required String arabic,
    required String translation,
  }) {
    final ar = ContentDisplayNormalize.forDisplay(arabic);
    if (isArabicLocale(languageCode)) {
      return ar;
    }
    final en = normalizedTranslation(ContentDisplayNormalize.forDisplay(translation));
    if (en.isNotEmpty) return en;
    return ar;
  }

  static bool useArabicTypography(String languageCode) =>
      isArabicLocale(languageCode);

  /// Copy / share as a single-language block plus source.
  static String composePlainText({
    required String languageCode,
    required String arabic,
    required String translation,
    required String source,
  }) {
    final body = primaryBody(
      languageCode: languageCode,
      arabic: arabic,
      translation: translation,
    );
    final buf = StringBuffer();
    if (body.isNotEmpty) {
      buf.writeln(body);
    }
    final src = source.trim();
    if (src.isNotEmpty) {
      if (buf.isNotEmpty) buf.writeln();
      buf.write('— $src');
    }
    return buf.toString().trim();
  }

  /// Hadith / verse list items: [textAr] Arabic, [translationOrEn] English/main line from API.
  static String libraryPrimaryBody({
    required String languageCode,
    required String? textAr,
    required String translationOrEn,
  }) {
    return primaryBody(
      languageCode: languageCode,
      arabic: textAr ?? '',
      translation: translationOrEn,
    );
  }
}
