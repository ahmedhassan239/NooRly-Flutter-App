/// Journey profile summary entity (for Profile screen).
library;

import 'package:flutter/foundation.dart';

/// Compact journey summary from GET /api/v1/journey/summary.
@immutable
class JourneySummaryEntity {
  const JourneySummaryEntity({
    this.dayIndex = 1,
    this.totalDays = 90,
    this.streakDays = 0,
    this.activeWeeks = 0,
    this.leftDays = 0,
    this.completedLessons = 0,
    this.totalLessons = 90,
    this.completionPercent = 0.0,
    this.milestones = const [],
    this.currentLesson,
  });

  /// Current day in the journey (1..90).
  final int dayIndex;

  /// Total days (90).
  final int totalDays;

  /// Consecutive days with at least one lesson completed.
  final int streakDays;

  /// Number of weeks with at least one lesson started or completed.
  final int activeWeeks;

  /// Days remaining (total_days - day_index).
  final int leftDays;

  /// Count of completed lessons in journey.
  final int completedLessons;

  /// Total lessons in journey.
  final int totalLessons;

  /// Completion percentage (0–100).
  final double completionPercent;

  /// Per-week milestone status.
  final List<JourneyMilestoneEntity> milestones;

  /// Current (next) lesson for UI linking, or null if none.
  final JourneyCurrentLessonEntity? currentLesson;
}

/// Single week milestone in the summary.
@immutable
class JourneyMilestoneEntity {
  const JourneyMilestoneEntity({
    required this.week,
    required this.status,
    this.completedLessons = 0,
    this.totalLessons = 0,
  });

  final int week;
  /// One of: completed, in_progress, locked
  final String status;
  final int completedLessons;
  final int totalLessons;
}

/// Minimal current lesson for Profile/linking.
@immutable
class JourneyCurrentLessonEntity {
  const JourneyCurrentLessonEntity({
    required this.lessonId,
    required this.title,
    required this.week,
    required this.day,
    this.status = 'current',
  });

  final int lessonId;
  final String title;
  final int week;
  final int day;
  final String status;
}
