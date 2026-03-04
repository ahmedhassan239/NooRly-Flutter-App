/// Display models for Quran verses and Hadith items on the lesson details screen.
/// English-only; used for Lovable-style quote cards.
library;

import 'package:flutter/foundation.dart';

/// A single Quran verse (English translation + reference).
@immutable
class QuranVerse {
  const QuranVerse({
    required this.surahNameEn,
    required this.surahNumber,
    required this.ayahNumber,
    required this.textEn,
  });

  final String surahNameEn;
  final int surahNumber;
  final int ayahNumber;
  final String textEn;

  /// Reference string: "SurahName (surahNumber:ayahNumber)".
  String get reference => '$surahNameEn ($surahNumber:$ayahNumber)';
}

/// A single Hadith item (English text + collection reference).
@immutable
class HadithItem {
  const HadithItem({
    required this.collection,
    required this.number,
    required this.textEn,
  });

  final String collection;
  final String number;
  final String textEn;

  /// Footer: "Collection • #Number".
  String get reference => '$collection • #$number';
}

/// Ref used when lesson only stores references (surah + ayah).
@immutable
class QuranAyahRef {
  const QuranAyahRef({
    required this.surahNumber,
    required this.ayahNumber,
  });

  final int surahNumber;
  final int ayahNumber;
}

/// Ref used when lesson only stores hadith reference.
@immutable
class HadithRef {
  const HadithRef({
    required this.collectionName,
    this.hadithNumber,
    this.hadithId,
  });

  final String collectionName;
  final String? hadithNumber;
  final String? hadithId;
}

/// English surah names by number (1–114). Use when API does not return surah_name_en.
String surahNameFromNumber(int n) {
  if (n < 1 || n > 114) return 'Surah $n';
  return _surahNamesEn[n] ?? 'Surah $n';
}

const Map<int, String> _surahNamesEn = {
  1: 'Al-Fatihah',
  2: 'Al-Baqarah',
  3: 'Ali \'Imran',
  4: 'An-Nisa',
  5: 'Al-Ma\'idah',
  6: 'Al-An\'am',
  7: 'Al-A\'raf',
  8: 'Al-Anfal',
  9: 'At-Tawbah',
  10: 'Yunus',
  11: 'Hud',
  12: 'Yusuf',
  13: 'Ar-Ra\'d',
  14: 'Ibrahim',
  15: 'Al-Hijr',
  16: 'An-Nahl',
  17: 'Al-Isra',
  18: 'Al-Kahf',
  19: 'Maryam',
  20: 'Taha',
  21: 'Al-Anbya',
  22: 'Al-Hajj',
  23: 'Al-Mu\'minun',
  24: 'An-Nur',
  25: 'Al-Furqan',
  26: 'Ash-Shu\'ara',
  27: 'An-Naml',
  28: 'Al-Qasas',
  29: 'Al-\'Ankabut',
  30: 'Ar-Rum',
  31: 'Luqman',
  32: 'As-Sajdah',
  33: 'Al-Ahzab',
  34: 'Saba',
  35: 'Fatir',
  36: 'Ya-Sin',
  37: 'As-Saffat',
  38: 'Sad',
  39: 'Az-Zumar',
  40: 'Ghafir',
  41: 'Fussilat',
  42: 'Ash-Shura',
  43: 'Az-Zukhruf',
  44: 'Ad-Dukhan',
  45: 'Al-Jathiyah',
  46: 'Al-Ahqaf',
  47: 'Muhammad',
  48: 'Al-Fath',
  49: 'Al-Hujurat',
  50: 'Qaf',
  51: 'Adh-Dhariyat',
  52: 'At-Tur',
  53: 'An-Najm',
  54: 'Al-Qamar',
  55: 'Ar-Rahman',
  56: 'Al-Waqi\'ah',
  57: 'Al-Hadid',
  58: 'Al-Mujadila',
  59: 'Al-Hashr',
  60: 'Al-Mumtahanah',
  61: 'As-Saf',
  62: 'Al-Jumu\'ah',
  63: 'Al-Munafiqun',
  64: 'At-Taghabun',
  65: 'At-Talaq',
  66: 'At-Tahrim',
  67: 'Al-Mulk',
  68: 'Al-Qalam',
  69: 'Al-Haqqah',
  70: 'Al-Ma\'arij',
  71: 'Nuh',
  72: 'Al-Jinn',
  73: 'Al-Muzzammil',
  74: 'Al-Muddaththir',
  75: 'Al-Qiyamah',
  76: 'Al-Insan',
  77: 'Al-Mursalat',
  78: 'An-Naba',
  79: 'An-Nazi\'at',
  80: '\'Abasa',
  81: 'At-Takwir',
  82: 'Al-Infitar',
  83: 'Al-Mutaffifin',
  84: 'Al-Inshiqaq',
  85: 'Al-Buruj',
  86: 'At-Tariq',
  87: 'Al-A\'la',
  88: 'Al-Ghashiyah',
  89: 'Al-Fajr',
  90: 'Al-Balad',
  91: 'Ash-Shams',
  92: 'Al-Layl',
  93: 'Ad-Duhaa',
  94: 'Ash-Sharh',
  95: 'At-Tin',
  96: 'Al-\'Alaq',
  97: 'Al-Qadr',
  98: 'Al-Bayyinah',
  99: 'Az-Zalzalah',
  100: 'Al-\'Adiyat',
  101: 'Al-Qari\'ah',
  102: 'At-Takathur',
  103: 'Al-\'Asr',
  104: 'Al-Humazah',
  105: 'Al-Fil',
  106: 'Quraysh',
  107: 'Al-Ma\'un',
  108: 'Al-Kawthar',
  109: 'Al-Kafirun',
  110: 'An-Nasr',
  111: 'Al-Masad',
  112: 'Al-Ikhlas',
  113: 'Al-Falaq',
  114: 'An-Nas',
};
