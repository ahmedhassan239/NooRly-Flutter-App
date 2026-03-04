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
    this.quranVerses = const [],
    this.hadithItems = const [],
  });

  final String id;
  final int dayNumber;
  final int weekNumber;
  final String title;
  final String description;
  final String content; // Markdown content
  final int readTime; // Minutes
  final LessonCategory category;

  /// Quran verses attached to this lesson (from API or resolved by refs).
  final List<QuranVerse> quranVerses;

  /// Hadith items attached to this lesson (from API or resolved by refs).
  final List<HadithItem> hadithItems;

  /// Map from API lesson payload (e.g. GET /lessons/:id).
  static LessonCategory categoryFromString(String? value) {
    if (value == null || value.isEmpty) return LessonCategory.faith;
    switch (value.toLowerCase()) {
      case 'salah':
        return LessonCategory.salah;
      case 'quran':
        return LessonCategory.quran;
      case 'habits':
        return LessonCategory.habits;
      case 'community':
        return LessonCategory.community;
      default:
        return LessonCategory.faith;
    }
  }
}
