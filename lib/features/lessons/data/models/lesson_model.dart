import 'package:flutter_app/features/lessons/data/lesson_block_parser.dart';
import 'package:flutter_app/features/lessons/data/lesson_quran_hadith_parser.dart';
import 'package:flutter_app/features/lessons/domain/entities/lesson_entity.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_quran_hadith_models.dart';

/// Lesson Model (Data Layer)
class LessonModel {
  const LessonModel({
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

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    final quranRaw = json['quranVerses'] ??
        json['quran_verses'] ??
        json['quranAyahs'] ??
        json['quran_ayahs'] ??
        json['ayahs'];
    final hadithRaw = json['hadithItems'] ??
        json['hadith_items'] ??
        json['hadith'] ??
        json['hadiths'];
    return LessonModel(
      id: (json['id'] ?? '').toString(),
      dayNumber: json['dayNumber'] as int? ?? json['day_number'] as int? ?? 0,
      weekNumber: json['weekNumber'] as int? ?? json['week_number'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? json['summary'] as String? ?? '',
      content: (json['content'] as String? ?? '').replaceAll(r'\n', '\n'),
      readTime: json['readTime'] as int? ?? json['estimated_minutes'] as int? ?? json['duration'] as int? ?? 0,
      category: json['category'] as String? ?? 'faith',
      blocks: parseBlocks(json),
      quranVerses: parseQuranVersesFromJson(quranRaw),
      hadithItems: parseHadithItemsFromJson(hadithRaw),
    );
  }

  final String id;
  final int dayNumber;
  final int weekNumber;
  final String title;
  final String description;
  final String content;
  final int readTime;
  final String category;
  final List<LessonBlock> blocks;
  final List<QuranVerse> quranVerses;
  final List<HadithItem> hadithItems;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayNumber': dayNumber,
      'weekNumber': weekNumber,
      'title': title,
      'description': description,
      'content': content,
      'readTime': readTime,
      'category': category,
    };
  }

  /// Convert to entity
  LessonEntity toEntity() {
    return LessonEntity(
      id: id,
      dayNumber: dayNumber,
      weekNumber: weekNumber,
      title: title,
      description: description,
      content: content,
      readTime: readTime,
      category: _categoryFromString(category),
      blocks: blocks,
      quranVerses: quranVerses,
      hadithItems: hadithItems,
    );
  }

  LessonCategory _categoryFromString(String category) {
    switch (category) {
      case 'faith':
        return LessonCategory.faith;
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
