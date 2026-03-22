/// Locale-aware reference lines for Library cards (Quran, Hadith, Duas, Adhkar).
library;

import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/core/content/quran_surah_names_ar.dart';
import 'package:flutter_app/core/content/quran_surah_names_en.dart';
import 'package:flutter_app/core/utils/locale_digits.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

/// True if [s] contains Arabic script (reference already localized).
bool referenceContainsArabicScript(String s) {
  return RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
  ).hasMatch(s);
}

/// Parses trailing `surah:ayah` (e.g. `Al-Baqarah 2:255`, `2:255`).
({int surah, int ayah})? tryParseSurahColonAyah(String source) {
  final t = source.trim();
  final m = RegExp(r'(\d+):(\d+)\s*$').firstMatch(t);
  if (m == null) return null;
  final surah = int.tryParse(m.group(1)!);
  final ayah = int.tryParse(m.group(2)!);
  if (surah == null || ayah == null) return null;
  if (surah < 1 || surah > 114 || ayah < 1) return null;
  return (surah: surah, ayah: ayah);
}

/// Parses `Name 255` when ayah is a separate field (daily inspiration style).
({int surah, int ayah})? tryParseEnglishSurahNameAndAyah(
  String? surahField,
  int? ayahNumber,
) {
  if (ayahNumber == null || ayahNumber < 1) return null;
  final name = surahField?.trim() ?? '';
  if (name.isEmpty) return null;
  final sn = matchEnglishSurahNumber(name);
  if (sn == null) return null;
  return (surah: sn, ayah: ayahNumber);
}

int? matchEnglishSurahNumber(String roughName) {
  final target = _normalizeSurahKey(roughName);
  if (target.isEmpty) return null;
  for (final e in kQuranSurahNameEnByNumber.entries) {
    if (_normalizeSurahKey(e.value) == target) return e.key;
  }
  for (final e in kQuranSurahNameEnByNumber.entries) {
    final k = _normalizeSurahKey(e.value);
    if (target.contains(k) || k.contains(target)) return e.key;
  }
  return null;
}

String _normalizeSurahKey(String s) {
  return s
      .toLowerCase()
      .replaceAll(RegExp(r'[\s\-_.\u2019\u0027]'), '')
      .replaceAll(RegExp(r'^al|^ar|^as|^ad|^an|^at'), '');
}

String _arabicSurahLine(int? surahNum, String? surahNameAr) {
  if (surahNum != null) {
    final full = quranSurahTitleArFromNumber(surahNum);
    if (full.isNotEmpty) return full;
  }
  final short = surahNameAr?.trim() ?? '';
  if (short.isEmpty) return '';
  if (short.startsWith('سُور') || short.startsWith('سورة')) return short;
  return 'سورة $short';
}

/// Verse reference for library / saved lists.
String formatLibraryVerseReference({
  required String languageCode,
  String? apiReference,
  int? surahNumber,
  int? ayahNumber,
  String? surahNameEn,
  String? surahNameAr,
}) {
  final isAr = LocalizedReligiousContent.isArabicLocale(languageCode);
  final ref = apiReference?.trim() ?? '';

  if (isAr) {
    if (ref.isNotEmpty && referenceContainsArabicScript(ref)) {
      return toLocaleDigits(ref, languageCode);
    }

    // "Al-Baqarah 255" (space, no colon)
    final spaceAyah = ref.isNotEmpty
        ? RegExp(r'^(.+?)\s+(\d+)\s*$').firstMatch(ref)
        : null;
    if (spaceAyah != null) {
      final sn = matchEnglishSurahNumber(spaceAyah.group(1)!);
      final ay = int.tryParse(spaceAyah.group(2)!);
      if (sn != null && ay != null && ay > 0) {
        final surahLine = _arabicSurahLine(sn, surahNameAr);
        final line = surahLine.isNotEmpty
            ? surahLine
            : quranSurahTitleArFromNumber(sn);
        if (line.isNotEmpty) {
          return '$line — ${toLocaleDigits('$ay', languageCode)}';
        }
      }
    }

    final parsedFromRef = tryParseSurahColonAyah(ref);
    final sn = surahNumber ?? parsedFromRef?.surah;
    final an = ayahNumber ?? parsedFromRef?.ayah;

    if (an != null && sn != null) {
      final surahLine = _arabicSurahLine(sn, surahNameAr);
      if (surahLine.isEmpty) {
        return toLocaleDigits('سورة $sn — $an', languageCode);
      }
      final ayahDigits = toLocaleDigits('$an', languageCode);
      return '$surahLine — $ayahDigits';
    }

    if (ref.isNotEmpty) {
      final loose = tryParseSurahColonAyah(ref);
      if (loose != null) {
        final title = quranSurahTitleArFromNumber(loose.surah);
        final ayahDigits = toLocaleDigits('${loose.ayah}', languageCode);
        if (title.isNotEmpty) return '$title — $ayahDigits';
      }
    }
    return ref.isNotEmpty ? ref : '';
  }

  // English
  if (ref.isNotEmpty && !referenceContainsArabicScript(ref)) {
    return ref;
  }

  final an = ayahNumber;
  if (an != null) {
    final en = surahNameEn?.trim() ?? '';
    final ar = surahNameAr?.trim() ?? '';
    if (en.isNotEmpty && ar.isNotEmpty) return '$en ($ar) $an';
    if (en.isNotEmpty) return '$en $an';
    if (ar.isNotEmpty) return '$ar $an';
    if (surahNumber != null) {
      final enTitle = quranSurahTitleEnFromNumber(surahNumber);
      if (enTitle.isNotEmpty) return '$enTitle $an';
    }
  }

  if (ref.isNotEmpty) return ref;
  return '';
}

String _stringifyHadithNumber(Object? n) {
  if (n == null) return '';
  if (n is num) return n.toInt().toString();
  return n.toString().trim();
}

/// Maps common English collection labels to Arabic when API omits `collection_name_ar`.
String? _hadithCollectionEnToAr(String? en) {
  final k = en?.trim().toLowerCase() ?? '';
  if (k.isEmpty) return null;
  const m = <String, String>{
    'bukhari': 'صحيح البخاري',
    'sahih al-bukhari': 'صحيح البخاري',
    'sahih bukhari': 'صحيح البخاري',
    'muslim': 'صحيح مسلم',
    'sahih muslim': 'صحيح مسلم',
    'tirmidhi': 'سنن الترمذي',
    'sunan at-tirmidhi': 'سنن الترمذي',
    'sunan tirmidhi': 'سنن الترمذي',
    'abu dawud': 'سنن أبي داود',
    'abudawud': 'سنن أبي داود',
    'sunan abu dawud': 'سنن أبي داود',
    'ibn majah': 'سنن ابن ماجه',
    'sunan ibn majah': 'سنن ابن ماجه',
    'nasai': 'سنن النسائي',
    "an-nasa'i": 'سنن النسائي',
    'sunan an-nasai': 'سنن النسائي',
    'ahmad': 'مسند أحمد',
    'musnad ahmad': 'مسند أحمد',
    'ibn as-sunni': 'ابن السني',
    'ibn assunni': 'ابن السني',
    'quran': 'القرآن الكريم',
  };
  if (m.containsKey(k)) return m[k];
  for (final e in m.entries) {
    if (k.contains(e.key)) return e.value;
  }
  return null;
}

/// Hadith collection + number for library cards.
String formatLibraryHadithReference({
  required AppLocalizations l10n,
  required String languageCode,
  String? collectionName,
  String? collectionNameAr,
  Object? hadithNumber,
}) {
  final isAr = LocalizedReligiousContent.isArabicLocale(languageCode);
  final collEn = collectionName?.trim() ?? '';
  final collArRaw = collectionNameAr?.trim() ?? '';
  final numStr = _stringifyHadithNumber(hadithNumber);

  if (isAr) {
    var book = collArRaw.isNotEmpty
        ? collArRaw
        : (_hadithCollectionEnToAr(collEn) ?? collEn);
    if (book.isEmpty) return '';
    if (numStr.isEmpty) return toLocaleDigits(book, languageCode);
    return l10n.libraryContentHadithRef(
      toLocaleDigits(book, languageCode),
      toLocaleDigits(numStr, languageCode),
    );
  }

  var book = collEn.isNotEmpty ? collEn : collArRaw;
  if (book.isEmpty) return '';
  if (numStr.isEmpty) return book;
  return l10n.libraryContentHadithRef(book, numStr);
}

/// Parses `Sahih al-Bukhari, 1` style mock strings.
({String book, String number})? _parseHadithCommaNumber(String s) {
  final m = RegExp(r'^(.+?),\s*([0-9]+)\s*$').firstMatch(s.trim());
  if (m == null) return null;
  return (book: m.group(1)!.trim(), number: m.group(2)!);
}

/// Localized hadith source from a single English line (mock / legacy).
String formatHadithSourcePlainLine(
  AppLocalizations l10n,
  String languageCode,
  String sourceEn,
) {
  final trimmed = sourceEn.trim();
  if (trimmed.isEmpty) return '';
  final isAr = LocalizedReligiousContent.isArabicLocale(languageCode);
  if (!isAr) return trimmed;

  if (referenceContainsArabicScript(trimmed)) {
    return toLocaleDigits(trimmed, languageCode);
  }

  final parsed = _parseHadithCommaNumber(trimmed);
  if (parsed != null) {
    return formatLibraryHadithReference(
      l10n: l10n,
      languageCode: languageCode,
      collectionName: parsed.book,
      collectionNameAr: null,
      hadithNumber: parsed.number,
    );
  }

  return _hadithCollectionEnToAr(trimmed) ?? trimmed;
}

/// Dua / dhikr / generic English source → Arabic display.
String formatLooseReligiousSourceLine(
  AppLocalizations l10n,
  String languageCode,
  String sourceEn, {
  String? sourceAr,
}) {
  final isAr = LocalizedReligiousContent.isArabicLocale(languageCode);
  if (!isAr) return sourceEn.trim();

  final ar = sourceAr?.trim() ?? '';
  if (ar.isNotEmpty) return toLocaleDigits(ar, languageCode);

  final en = sourceEn.trim();
  if (en.isEmpty) return '';

  if (referenceContainsArabicScript(en)) {
    return toLocaleDigits(en, languageCode);
  }

  final lower = en.toLowerCase();
  if (lower == 'quran' || lower == 'al-quran') {
    return l10n.librarySourceQuran;
  }

  final verse = formatLibraryVerseReference(
    languageCode: languageCode,
    apiReference: en,
    surahNumber: null,
    ayahNumber: null,
    surahNameEn: null,
    surahNameAr: null,
  );
  if (verse.isNotEmpty && referenceContainsArabicScript(verse)) {
    return verse;
  }

  final hadithLine = formatHadithSourcePlainLine(l10n, languageCode, en);
  if (referenceContainsArabicScript(hadithLine) ||
      hadithLine != en ||
      _hadithCollectionEnToAr(en) != null) {
    return hadithLine;
  }

  return en;
}
