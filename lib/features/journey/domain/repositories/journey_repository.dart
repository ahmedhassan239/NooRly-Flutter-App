/// Journey repository interface.
library;

import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_summary_entity.dart';

/// Journey repository interface.
abstract class JourneyRepository {
  /// Get user's journey data.
  Future<JourneyEntity> getJourney();

  /// Get compact journey profile summary for Profile screen (GET /journey/summary).
  Future<JourneySummaryEntity> getJourneySummary();

  /// Get lesson by id.
  Future<LessonEntity> getLesson(String id);

  /// Get today's / next lesson for home dashboard (GET /lessons/today). Returns null if none.
  Future<LessonEntity?> getTodayLesson();

  /// Mark lesson as complete (by lesson id).
  Future<void> completeLesson(String lessonId);

  /// Get saved/bookmarked lessons.
  Future<List<LessonSummaryEntity>> getSavedLessons();

  /// Save/bookmark a lesson.
  Future<void> saveLesson(String lessonId);

  /// Unsave/unbookmark a lesson.
  Future<void> unsaveLesson(String lessonId);

  /// Get cached journey data.
  Future<JourneyEntity?> getCachedJourney();

  /// Clear cache.
  Future<void> clearCache();
}
