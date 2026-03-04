/// Generic content models for API serialization.
library;

import 'package:flutter_app/core/content/domain/entities/content_entity.dart';

/// Removes HTML tags and normalizes whitespace for display.
String stripHtml(String? text) {
  if (text == null || text.isEmpty) return text ?? '';
  return text
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll(RegExp(r'&nbsp;'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

/// Returns first value from [json] for [keys] that is a string (or safe to use as string); null otherwise.
String? _stringFromJson(Map<String, dynamic> json, List<String> keys) {
  for (final k in keys) {
    final v = json[k];
    if (v == null) continue;
    if (v is String) return v;
    if (v is num) return v.toString();
  }
  return null;
}

/// Content model for API serialization.
class ContentModel extends ContentEntity {
  const ContentModel({
    required super.id,
    required super.type,
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
    super.imageUrl,
    super.order,
    super.isSaved,
    super.metadata,
  });

  /// Create from JSON with content type.
  /// Strips HTML tags from text fields for clean display.
  factory ContentModel.fromJson(Map<String, dynamic> json, ContentType type) {
    return ContentModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      type: type,
      arabicText: stripHtml(
        json['arabic_text'] as String? ??
            json['arabic'] as String? ??
            json['text'] as String? ??
            '',
      ),
      translation: stripHtml(
        json['translation'] as String? ?? json['english'] as String?,
      ),
      transliteration: stripHtml(json['transliteration'] as String?),
      title: stripHtml(json['title'] as String?),
      titleAr: stripHtml(json['title_ar'] as String?),
      source: stripHtml(json['source'] as String? ?? json['reference'] as String?),
      sourceAr: stripHtml(json['source_ar'] as String?),
      categoryId: (json['category_id'] ?? json['category'] ?? '').toString(),
      categoryName: json['category_name'] as String?,
      categoryNameAr: json['category_name_ar'] as String?,
      audioUrl: json['audio_url'] as String? ?? json['audio'] as String?,
      imageUrl: json['image_url'] as String? ?? json['image'] as String?,
      order: json['order'] as int? ?? 0,
      isSaved: json['is_saved'] as bool? ?? json['saved'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'arabic_text': arabicText,
      'translation': translation,
      'transliteration': transliteration,
      'title': title,
      'title_ar': titleAr,
      'source': source,
      'source_ar': sourceAr,
      'category_id': categoryId,
      'category_name': categoryName,
      'category_name_ar': categoryNameAr,
      'audio_url': audioUrl,
      'image_url': imageUrl,
      'order': order,
      'is_saved': isSaved,
      'metadata': metadata,
    };
  }

  /// Convert to entity.
  ContentEntity toEntity() {
    return ContentEntity(
      id: id,
      type: type,
      arabicText: arabicText,
      translation: translation,
      transliteration: transliteration,
      title: title,
      titleAr: titleAr,
      source: source,
      sourceAr: sourceAr,
      categoryId: categoryId,
      categoryName: categoryName,
      categoryNameAr: categoryNameAr,
      audioUrl: audioUrl,
      imageUrl: imageUrl,
      order: order,
      isSaved: isSaved,
      metadata: metadata,
    );
  }
}

/// Category model for API serialization.
class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    super.nameAr,
    super.description,
    super.descriptionAr,
    super.imageUrl,
    super.iconName,
    super.itemCount,
    super.order,
    super.type,
  });

  /// Create from JSON.
  factory CategoryModel.fromJson(Map<String, dynamic> json, {ContentType? type}) {
    return CategoryModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: json['name'] as String? ?? json['title'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? json['title_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      imageUrl: json['image_url'] as String? ?? json['image'] as String?,
      iconName: json['icon'] as String? ?? json['icon_name'] as String?,
      itemCount: json['item_count'] as int? ?? json['count'] as int? ?? 0,
      order: json['order'] as int? ?? 0,
      type: type,
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'image_url': imageUrl,
      'icon_name': iconName,
      'item_count': itemCount,
      'order': order,
      'type': type?.name,
    };
  }

  /// Convert to entity.
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      nameAr: nameAr,
      description: description,
      descriptionAr: descriptionAr,
      imageUrl: imageUrl,
      iconName: iconName,
      itemCount: itemCount,
      order: order,
      type: type,
    );
  }
}

/// Verse model with Quran-specific fields.
class VerseModel extends VerseEntity {
  const VerseModel({
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
    super.surahNumber,
    super.surahName,
    super.surahNameAr,
    super.verseNumber,
    super.juzNumber,
    super.pageNumber,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      arabicText: json['arabic_text'] as String? ??
          json['arabic'] as String? ??
          json['text'] as String? ??
          '',
      translation: json['translation'] as String? ?? json['english'] as String?,
      transliteration: json['transliteration'] as String?,
      audioUrl: json['audio_url'] as String? ?? json['audio'] as String?,
      categoryId: (json['category_id'] ?? json['theme_id'] ?? '').toString(),
      categoryName: json['category_name'] as String? ?? json['theme'] as String?,
      categoryNameAr: json['category_name_ar'] as String?,
      isSaved: json['is_saved'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
      surahNumber: json['surah_number'] as int? ?? json['surah'] as int?,
      surahName: json['surah_name'] as String?,
      surahNameAr: json['surah_name_ar'] as String?,
      verseNumber: json['verse_number'] as int? ?? json['ayah'] as int?,
      juzNumber: json['juz_number'] as int? ?? json['juz'] as int?,
      pageNumber: json['page_number'] as int? ?? json['page'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabic_text': arabicText,
      'translation': translation,
      'transliteration': transliteration,
      'audio_url': audioUrl,
      'category_id': categoryId,
      'category_name': categoryName,
      'category_name_ar': categoryNameAr,
      'is_saved': isSaved,
      'metadata': metadata,
      'surah_number': surahNumber,
      'surah_name': surahName,
      'surah_name_ar': surahNameAr,
      'verse_number': verseNumber,
      'juz_number': juzNumber,
      'page_number': pageNumber,
    };
  }
}

/// Hadith model with hadith-specific fields.
class HadithModel extends HadithEntity {
  const HadithModel({
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
    super.narrator,
    super.narratorAr,
    super.bookName,
    super.bookNameAr,
    super.hadithNumber,
    super.grade,
    super.gradeAr,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      arabicText: json['arabic_text'] as String? ??
          json['arabic'] as String? ??
          json['text'] as String? ??
          '',
      translation: json['translation'] as String? ?? json['english'] as String?,
      transliteration: json['transliteration'] as String?,
      source: json['source'] as String? ?? json['reference'] as String?,
      sourceAr: json['source_ar'] as String?,
      categoryId: (json['category_id'] ?? json['topic_id'] ?? '').toString(),
      categoryName: json['category_name'] as String? ?? json['topic'] as String?,
      categoryNameAr: json['category_name_ar'] as String?,
      isSaved: json['is_saved'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
      narrator: json['narrator'] as String?,
      narratorAr: json['narrator_ar'] as String?,
      bookName: json['book_name'] as String? ?? json['book'] as String?,
      bookNameAr: json['book_name_ar'] as String?,
      hadithNumber: json['hadith_number'] as int? ?? json['number'] as int?,
      grade: json['grade'] as String?,
      gradeAr: json['grade_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabic_text': arabicText,
      'translation': translation,
      'transliteration': transliteration,
      'source': source,
      'source_ar': sourceAr,
      'category_id': categoryId,
      'category_name': categoryName,
      'category_name_ar': categoryNameAr,
      'is_saved': isSaved,
      'metadata': metadata,
      'narrator': narrator,
      'narrator_ar': narratorAr,
      'book_name': bookName,
      'book_name_ar': bookNameAr,
      'hadith_number': hadithNumber,
      'grade': grade,
      'grade_ar': gradeAr,
    };
  }
}

/// Dhikr model with dhikr-specific fields.
class DhikrModel extends DhikrEntity {
  const DhikrModel({
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
    super.repetitionCount,
    super.virtue,
    super.virtueAr,
    super.timing,
    super.timingAr,
  });

  factory DhikrModel.fromJson(Map<String, dynamic> json) {
    final content = json['content'] is Map<String, dynamic>
        ? json['content'] as Map<String, dynamic>
        : null;
    final textMap = content?['text'] is Map ? content!['text'] as Map : null;
    final rewardMap = content?['reward'] is Map ? content!['reward'] as Map : null;

    final String arabicText;
    final String? translation;
    final String? virtue;
    final int repetitionCount;
    if (textMap != null) {
      arabicText = (textMap['ar'] ?? '').toString();
      translation = (textMap['en'] ?? '').toString().isNotEmpty
          ? (textMap['en'] ?? '').toString()
          : null;
      virtue = rewardMap != null
          ? ((rewardMap['en'] ?? rewardMap['ar'] ?? '').toString().isNotEmpty
              ? (rewardMap['en'] ?? rewardMap['ar'] ?? '').toString()
              : null)
          : null;
      repetitionCount = (json['repeat_count'] as num?)?.toInt() ??
          (json['count'] as num?)?.toInt() ??
          1;
    } else {
      arabicText = _stringFromJson(json, ['text_ar', 'arabic_text', 'arabic', 'text']) ?? '';
      translation = _stringFromJson(json, ['translation', 'english', 'english_text', 'text']);
      final rewardRaw = json['reward'];
      if (rewardRaw is Map) {
        final r = rewardRaw as Map;
        virtue = (r['en'] ?? r['ar'] ?? '').toString().trim().isNotEmpty
            ? (r['en'] ?? r['ar'] ?? '').toString()
            : null;
      } else {
        virtue = _stringFromJson(json, ['virtue', 'benefit', 'reward']);
      }
      repetitionCount = json['repetition_count'] as int? ??
          json['count'] as int? ??
          json['repeat'] as int? ??
          1;
    }

    final category = json['category'];
    final categoryId = json['category_id'] ?? (category is Map ? category['id'] : null);
    final categoryName = _stringFromJson(json, ['category_name']) ??
        (category is Map ? category['name']?.toString() : null);

    return DhikrModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      arabicText: arabicText,
      translation: translation,
      transliteration: _stringFromJson(json, ['transliteration']),
      title: _stringFromJson(json, ['title']),
      titleAr: _stringFromJson(json, ['title_ar']),
      source: _stringFromJson(json, ['source', 'reference']),
      sourceAr: _stringFromJson(json, ['source_ar']),
      categoryId: categoryId?.toString(),
      categoryName: categoryName,
      categoryNameAr: _stringFromJson(json, ['category_name_ar']),
      audioUrl: _stringFromJson(json, ['audio_url', 'audio']),
      isSaved: json['is_saved'] as bool? ?? false,
      metadata: json['metadata'] is Map<String, dynamic> ? json['metadata'] as Map<String, dynamic> : null,
      repetitionCount: repetitionCount,
      virtue: virtue,
      virtueAr: _stringFromJson(json, ['virtue_ar']),
      timing: _stringFromJson(json, ['timing', 'time']),
      timingAr: _stringFromJson(json, ['timing_ar']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabic_text': arabicText,
      'translation': translation,
      'transliteration': transliteration,
      'title': title,
      'title_ar': titleAr,
      'source': source,
      'source_ar': sourceAr,
      'category_id': categoryId,
      'category_name': categoryName,
      'category_name_ar': categoryNameAr,
      'audio_url': audioUrl,
      'is_saved': isSaved,
      'metadata': metadata,
      'repetition_count': repetitionCount,
      'virtue': virtue,
      'virtue_ar': virtueAr,
      'timing': timing,
      'timing_ar': timingAr,
    };
  }
}
