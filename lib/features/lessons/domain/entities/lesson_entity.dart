import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_quran_hadith_models.dart';

/// Lesson Category
enum LessonCategory { faith, salah, quran, habits, community }

/// Lesson Entity (Domain Model)
class LessonEntity {
  const LessonEntity({
    required this.id,
    required this.dayNumber,
    required this.weekNumber,
    required this.title,
    required this.description,
    required this.content,
    required this.readTime,
    required this.category,
    this.blocks = const [],
    this.quranVerses = const [],
    this.hadithItems = const [],
  });

  final String id;
  final int dayNumber;
  final int weekNumber;
  final String title;
  final String description;

  /// Raw content string (kept for legacy fallback / debugging only).
  /// The UI renders [blocks] instead of this field.
  final String content;

  final int readTime;
  final LessonCategory category;

  /// Structured content blocks — primary rendering source.
  /// Populated from `blocks` JSON array (new API) or converted from [content]
  /// Markdown via [MarkdownToBlocks] (legacy). Always non-null; may be empty.
  final List<LessonBlock> blocks;

  // Legacy separate arrays — kept for backward compat; also represented
  // as [VerseBlock] / [HadithBlock] entries inside [blocks].
  final List<QuranVerse> quranVerses;
  final List<HadithItem> hadithItems;

  static LessonCategory categoryFromString(String? value) {
    if (value == null || value.isEmpty) return LessonCategory.faith;
    return switch (value.toLowerCase()) {
      'salah'     => LessonCategory.salah,
      'quran'     => LessonCategory.quran,
      'habits'    => LessonCategory.habits,
      'community' => LessonCategory.community,
      _           => LessonCategory.faith,
    };
  }
}
