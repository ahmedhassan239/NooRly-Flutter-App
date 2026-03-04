/// Parses Quran verses and Hadith items from lesson API/local JSON.
library;

import 'package:flutter_app/features/lessons/domain/models/lesson_quran_hadith_models.dart';

/// Parse Quran verses from JSON array.
/// Keys: quranVerses | quran_verses | quranAyahs.
/// Item keys: text_en | textEn | translation_en | translation; surah_number | surahNumber; ayah_number | ayahNumber; surah_name_en | surahNameEn.
List<QuranVerse> parseQuranVersesFromJson(dynamic raw) {
  if (raw is! List) return const [];
  final list = <QuranVerse>[];
  for (final e in raw) {
    if (e is! Map<String, dynamic>) continue;
    final surahNum = e['surah_number'] as int? ?? e['surahNumber'] as int? ?? e['surah'] as int? ?? 0;
    final ayahNum = e['ayah_number'] as int? ?? e['ayahNumber'] as int? ?? e['ayah'] as int? ?? 0;
    final surahNameEn = e['surah_name_en'] as String? ??
        e['surahNameEn'] as String? ??
        surahNameFromNumber(surahNum);
    final textEn = e['text_en'] as String? ??
        e['textEn'] as String? ??
        e['translation_en'] as String? ??
        e['translation'] as String? ??
        '';
    if (surahNum > 0 && ayahNum > 0 && textEn.isNotEmpty) {
      list.add(QuranVerse(
        surahNameEn: surahNameEn,
        surahNumber: surahNum,
        ayahNumber: ayahNum,
        textEn: textEn,
      ));
    }
  }
  return list;
}

/// Parse Hadith items from JSON array.
/// Keys: hadithItems | hadith_items.
/// Item keys: text_en | textEn | translation_en | translation | text; collection | collection_name | collectionName | book_name; number | hadith_number | hadithNumber.
List<HadithItem> parseHadithItemsFromJson(dynamic raw) {
  if (raw is! List) return const [];
  final list = <HadithItem>[];
  for (final e in raw) {
    if (e is! Map<String, dynamic>) continue;
    final collection = e['collection'] as String? ??
        e['collection_name'] as String? ??
        e['collectionName'] as String? ??
        e['book_name'] as String? ??
        e['book'] as String? ??
        '';
    final number = (e['number'] ?? e['hadith_number'] ?? e['hadithNumber'] ?? '').toString();
    final textEn = e['text_en'] as String? ??
        e['textEn'] as String? ??
        e['translation_en'] as String? ??
        e['translation'] as String? ??
        e['text'] as String? ??
        '';
    if (textEn.isNotEmpty) {
      list.add(HadithItem(
        collection: collection.isNotEmpty ? collection : 'Hadith',
        number: number.isEmpty ? '—' : number,
        textEn: textEn,
      ));
    }
  }
  return list;
}
