/// Generic content entities for Duas, Hadith, Verses, Adhkar.
library;

import 'package:flutter/foundation.dart';

/// Content type enum.
enum ContentType {
  dua,
  hadith,
  verse,
  dhikr,
}

/// Base content entity.
@immutable
class ContentEntity {
  const ContentEntity({
    required this.id,
    required this.type,
    required this.arabicText,
    this.translation,
    this.transliteration,
    this.title,
    this.titleAr,
    this.source,
    this.sourceAr,
    this.categoryId,
    this.categoryName,
    this.categoryNameAr,
    this.audioUrl,
    this.imageUrl,
    this.order = 0,
    this.isSaved = false,
    this.metadata,
  });

  /// Unique identifier.
  final String id;

  /// Content type.
  final ContentType type;

  /// Arabic text.
  final String arabicText;

  /// Translation (English or other).
  final String? translation;

  /// Transliteration (phonetic).
  final String? transliteration;

  /// Title (English).
  final String? title;

  /// Title (Arabic).
  final String? titleAr;

  /// Source/reference (English).
  final String? source;

  /// Source/reference (Arabic).
  final String? sourceAr;

  /// Category ID.
  final String? categoryId;

  /// Category name (English).
  final String? categoryName;

  /// Category name (Arabic).
  final String? categoryNameAr;

  /// Audio URL.
  final String? audioUrl;

  /// Image URL.
  final String? imageUrl;

  /// Display order.
  final int order;

  /// Whether item is saved/favorited.
  final bool isSaved;

  /// Additional metadata.
  final Map<String, dynamic>? metadata;

  /// Get localized title.
  String? getTitle(String locale) {
    if (locale == 'ar' && titleAr != null) return titleAr;
    return title;
  }

  /// Get localized category name.
  String? getCategoryName(String locale) {
    if (locale == 'ar' && categoryNameAr != null) return categoryNameAr;
    return categoryName;
  }

  /// Get localized source.
  String? getSource(String locale) {
    if (locale == 'ar' && sourceAr != null) return sourceAr;
    return source;
  }

  /// Copy with new values.
  ContentEntity copyWith({
    String? id,
    ContentType? type,
    String? arabicText,
    String? translation,
    String? transliteration,
    String? title,
    String? titleAr,
    String? source,
    String? sourceAr,
    String? categoryId,
    String? categoryName,
    String? categoryNameAr,
    String? audioUrl,
    String? imageUrl,
    int? order,
    bool? isSaved,
    Map<String, dynamic>? metadata,
  }) {
    return ContentEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      arabicText: arabicText ?? this.arabicText,
      translation: translation ?? this.translation,
      transliteration: transliteration ?? this.transliteration,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      source: source ?? this.source,
      sourceAr: sourceAr ?? this.sourceAr,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryNameAr: categoryNameAr ?? this.categoryNameAr,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
      isSaved: isSaved ?? this.isSaved,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

/// Category entity.
@immutable
class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.imageUrl,
    this.iconName,
    this.itemCount = 0,
    this.order = 0,
    this.type,
  });

  /// Unique identifier.
  final String id;

  /// Category name (English).
  final String name;

  /// Category name (Arabic).
  final String? nameAr;

  /// Description (English).
  final String? description;

  /// Description (Arabic).
  final String? descriptionAr;

  /// Image URL.
  final String? imageUrl;

  /// Icon name.
  final String? iconName;

  /// Number of items in category.
  final int itemCount;

  /// Display order.
  final int order;

  /// Content type this category belongs to.
  final ContentType? type;

  /// Get localized name.
  String getName(String locale) {
    if (locale == 'ar' && nameAr != null) return nameAr!;
    return name;
  }

  /// Get localized description.
  String? getDescription(String locale) {
    if (locale == 'ar' && descriptionAr != null) return descriptionAr;
    return description;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Verse-specific entity with additional Quran metadata.
@immutable
class VerseEntity extends ContentEntity {
  const VerseEntity({
    required super.id,
    required super.arabicText,
    super.translation,
    super.transliteration,
    super.audioUrl,
    super.categoryId,
    super.categoryName,
    super.categoryNameAr,
    super.isSaved,
    super.metadata,
    this.surahNumber,
    this.surahName,
    this.surahNameAr,
    this.verseNumber,
    this.juzNumber,
    this.pageNumber,
  }) : super(type: ContentType.verse);

  /// Surah number (1-114).
  final int? surahNumber;

  /// Surah name (English).
  final String? surahName;

  /// Surah name (Arabic).
  final String? surahNameAr;

  /// Verse number within surah.
  final int? verseNumber;

  /// Juz number (1-30).
  final int? juzNumber;

  /// Page number in Mushaf.
  final int? pageNumber;

  /// Get reference string.
  String get reference {
    if (surahName == null || verseNumber == null) return id;
    return '$surahName $verseNumber';
  }

  /// Get Arabic reference.
  String get referenceAr {
    if (surahNameAr == null || verseNumber == null) return id;
    return '$surahNameAr $verseNumber';
  }
}

/// Hadith-specific entity with chain of narration.
@immutable
class HadithEntity extends ContentEntity {
  const HadithEntity({
    required super.id,
    required super.arabicText,
    super.translation,
    super.transliteration,
    super.source,
    super.sourceAr,
    super.categoryId,
    super.categoryName,
    super.categoryNameAr,
    super.isSaved,
    super.metadata,
    this.narrator,
    this.narratorAr,
    this.bookName,
    this.bookNameAr,
    this.hadithNumber,
    this.grade,
    this.gradeAr,
  }) : super(type: ContentType.hadith);

  /// Narrator name (English).
  final String? narrator;

  /// Narrator name (Arabic).
  final String? narratorAr;

  /// Book name (English).
  final String? bookName;

  /// Book name (Arabic).
  final String? bookNameAr;

  /// Hadith number in the book.
  final int? hadithNumber;

  /// Hadith grade (Sahih, Hasan, etc.).
  final String? grade;

  /// Hadith grade (Arabic).
  final String? gradeAr;

  /// Get localized narrator.
  String? getNarrator(String locale) {
    if (locale == 'ar' && narratorAr != null) return narratorAr;
    return narrator;
  }

  /// Get localized book name.
  String? getBookName(String locale) {
    if (locale == 'ar' && bookNameAr != null) return bookNameAr;
    return bookName;
  }

  /// Get localized grade.
  String? getGrade(String locale) {
    if (locale == 'ar' && gradeAr != null) return gradeAr;
    return grade;
  }
}

/// Dhikr-specific entity with repetition count.
@immutable
class DhikrEntity extends ContentEntity {
  const DhikrEntity({
    required super.id,
    required super.arabicText,
    super.translation,
    super.transliteration,
    super.title,
    super.titleAr,
    super.source,
    super.sourceAr,
    super.categoryId,
    super.categoryName,
    super.categoryNameAr,
    super.audioUrl,
    super.isSaved,
    super.metadata,
    this.repetitionCount = 1,
    this.virtue,
    this.virtueAr,
    this.timing,
    this.timingAr,
  }) : super(type: ContentType.dhikr);

  /// Number of times to repeat.
  final int repetitionCount;

  /// Virtue/benefit of the dhikr (English).
  final String? virtue;

  /// Virtue/benefit of the dhikr (Arabic).
  final String? virtueAr;

  /// When to recite (morning, evening, etc.).
  final String? timing;

  /// When to recite (Arabic).
  final String? timingAr;

  /// Get localized virtue.
  String? getVirtue(String locale) {
    if (locale == 'ar' && virtueAr != null) return virtueAr;
    return virtue;
  }

  /// Get localized timing.
  String? getTiming(String locale) {
    if (locale == 'ar' && timingAr != null) return timingAr;
    return timing;
  }
}
