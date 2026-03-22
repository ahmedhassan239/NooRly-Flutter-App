/// Journey repository interface.
library;

import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_summary_entity.dart';

/// Journey repository interface.
abstract class JourneyRepository {
  /// Get user's journey data. [localeCode] (e.g. 'ar', 'en') is sent as ?lang= and used for cache key.
  Future<JourneyEntity> getJourney({required String localeCode});

  /// Get compact journey profile summary (GET /journey/summary). [localeCode] sent as ?lang=.
  Future<JourneySummaryEntity> getJourneySummary({required String localeCode});

  /// Get lesson by id.
  Future<LessonEntity> getLesson(String id);

  /// Get today's / next lesson (GET /lessons/today). [localeCode] sent as ?lang= for localized title.
  Future<LessonEntity?> getTodayLesson({required String localeCode});

  /// Mark lesson as complete (by lesson id).
  Future<void> completeLesson(String lessonId);

  /// Get saved/bookmarked lessons.
  Future<List<LessonSummaryEntity>> getSavedLessons();

  /// Save/bookmark a lesson.
  Future<void> saveLesson(String lessonId);

  /// Unsave/unbookmark a lesson.
  Future<void> unsaveLesson(String lessonId);

  /// Get cached journey data for [localeCode]. Cache key is locale-specific.
  Future<JourneyEntity?> getCachedJourney({required String localeCode});

  /// Clear journey and current-lesson caches (all locales).
  Future<void> clearCache();
}
