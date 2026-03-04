import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/lessons/data/models/lesson_model.dart';

/// Local JSON Data Source for Lessons
class LessonsLocalDataSource {
  static const String _assetPath = 'assets/data/lessons.json';

  List<LessonModel>? _cachedLessons;
  Map<int, String>? _cachedWeekTitles;

  /// Get all lessons
  Future<List<LessonModel>> getAllLessons() async {
    if (_cachedLessons != null) {
      return _cachedLessons!;
    }

    final jsonString = await rootBundle.loadString(_assetPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final lessonsList = jsonData['lessons'] as List<dynamic>;

    _cachedLessons = lessonsList
        .map((json) => LessonModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return _cachedLessons!;
  }

  /// Get week titles
  Future<Map<int, String>> getWeekTitles() async {
    if (_cachedWeekTitles != null) {
      return _cachedWeekTitles!;
    }

    final jsonString = await rootBundle.loadString(_assetPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final weekTitlesData = jsonData['weekTitles'] as Map<String, dynamic>;

    _cachedWeekTitles = weekTitlesData.map(
      (key, value) => MapEntry(int.parse(key), value as String),
    );

    return _cachedWeekTitles!;
  }

  /// Clear cache
  void clearCache() {
    _cachedLessons = null;
    _cachedWeekTitles = null;
  }
}
