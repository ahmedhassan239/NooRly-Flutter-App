import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/features/lessons/data/datasources/lessons_local_datasource.dart';
import 'package:flutter_app/features/lessons/data/lesson_block_parser.dart';
import 'package:flutter_app/features/lessons/data/lesson_quran_hadith_parser.dart';
import 'package:flutter_app/features/lessons/domain/entities/lesson_entity.dart';
import 'package:flutter_app/features/lessons/domain/repositories/lessons_repository.dart';

/// Lessons Repository Implementation
class LessonsRepositoryImpl implements LessonsRepository {
  LessonsRepositoryImpl(
    this._localDataSource, {
    ApiClient? apiClient,
  }) : _apiClient = apiClient;

  final LessonsLocalDataSource _localDataSource;
  final ApiClient? _apiClient;

  @override
  Future<List<LessonEntity>> getAllLessons() async {
    final models = await _localDataSource.getAllLessons();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Map<int, String>> getWeekTitles() async {
    return _localDataSource.getWeekTitles();
  }

  @override
  Future<List<LessonEntity>> getLessonsByWeek(int weekNumber) async {
    final allLessons = await getAllLessons();
    return allLessons.where((lesson) => lesson.weekNumber == weekNumber).toList();
  }

  @override
  Future<LessonEntity?> getLessonByDay(int dayNumber) async {
    final allLessons = await getAllLessons();
    try {
      return allLessons.firstWhere((lesson) => lesson.dayNumber == dayNumber);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<LessonEntity?> getLessonById(String id, {String? locale}) async {
    final client = _apiClient;
    if (client == null) return null;
    final lang = locale?.isNotEmpty == true ? locale! : 'en';
    try {
      final response = await client.get<Map<String, dynamic>>(
        LessonsEndpoints.detail(id),
        queryParameters: <String, dynamic>{
          'lang': lang,
          'include': 'quranAyahs,hadithItems',
        },
      );
      if (!response.status || response.data == null) return null;
      final d = response.data!;
      if (kDebugMode) {
        print('[LessonRepo] RAW keys: ${d.keys.toList()}');
        final rawContent = d['content'];
        final contentStr = rawContent is String ? rawContent : rawContent?.toString() ?? '';
        print('[LessonRepo] content length=${contentStr.length} preview=${contentStr.length > 80 ? '${contentStr.substring(0, 80)}...' : contentStr}');
      }
      final quranRaw = d['quranVerses'] ??
          d['quran_verses'] ??
          d['quranAyahs'] ??
          d['quran_ayahs'] ??
          d['ayahs'];
      final hadithRaw = d['hadithItems'] ??
          d['hadith_items'] ??
          d['hadith'] ??
          d['hadiths'];
      final quranVerses = parseQuranVersesFromJson(quranRaw);
      final hadithItems = parseHadithItemsFromJson(hadithRaw);
      if (kDebugMode) {
        print('[LessonRepo] quran=${quranVerses.length} hadith=${hadithItems.length}');
      }
      final rawContent = d['content'];
      final contentStr = (rawContent is String ? rawContent : rawContent?.toString() ?? '').replaceAll(r'\n', '\n');
      final blocks = parseBlocks(d);
      if (kDebugMode) {
        print('[LessonRepo] blocks=${blocks.length}');
      }
      return LessonEntity(
        id: (d['id'] ?? id).toString(),
        dayNumber: d['day_number'] as int? ?? 0,
        weekNumber: d['week_number'] as int? ?? 0,
        title: d['title'] as String? ?? '',
        description: d['summary'] as String? ?? '',
        content: contentStr,
        readTime:
            d['estimated_minutes'] as int? ?? d['duration'] as int? ?? 0,
        category: LessonEntity.categoryFromString(d['category'] as String?),
        blocks: blocks,
        quranVerses: quranVerses,
        hadithItems: hadithItems,
      );
    } catch (_) {
      // API failed (e.g. 500); fall back to local so user still sees content
      final allLessons = await getAllLessons();
      try {
        return allLessons.firstWhere((lesson) => lesson.id == id);
      } catch (_) {
        final dayNum = int.tryParse(id);
        if (dayNum != null && dayNum >= 1) {
          try {
            return allLessons.firstWhere((lesson) => lesson.dayNumber == dayNum);
          } catch (_) {}
        }
        try {
          return allLessons.firstWhere((lesson) => lesson.id == 'lesson_$id');
        } catch (_) {
          return null;
        }
      }
    }
  }

  @override
  Future<void> completeLesson(int dayNumber) async {
    final lesson = await getLessonByDay(dayNumber);
    if (lesson != null && _apiClient != null) {
      await completeLessonById(lesson.id);
    }
  }

  @override
  Future<void> completeLessonById(String id) async {
    final client = _apiClient;
    if (client == null) return;
    await client.post<void>(JourneyEndpoints.completeLesson(id));
  }

  @override
  Future<void> saveReflection(int dayNumber, String text) async {
    // TODO: PUT /api/v1/lessons/{id}/reflection when backend is ready
  }
}
