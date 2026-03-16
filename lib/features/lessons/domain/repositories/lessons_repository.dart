import 'package:flutter_app/features/lessons/domain/entities/lesson_entity.dart';

/// Lessons Repository Interface
abstract class LessonsRepository {
  /// Get all lessons
  Future<List<LessonEntity>> getAllLessons();

  /// Get week titles
  Future<Map<int, String>> getWeekTitles();

  /// Get lessons by week
  Future<List<LessonEntity>> getLessonsByWeek(int weekNumber);

  /// Get single lesson by day number
  Future<LessonEntity?> getLessonByDay(int dayNumber);

  /// Get single lesson by ID. [locale] (e.g. 'ar', 'en') is used for API content language.
  Future<LessonEntity?> getLessonById(String id, {String? locale});

  /// Mark lesson as complete (by day number).
  Future<void> completeLesson(int dayNumber);

  /// Mark lesson as complete by ID (calls backend API).
  Future<void> completeLessonById(String id);

  /// Save reflection for a lesson (by day number).
  Future<void> saveReflection(int dayNumber, String text);
}
