/// Journey/Learning entities.
library;

import 'package:flutter/foundation.dart';

/// User's learning journey.
@immutable
class JourneyEntity {
  const JourneyEntity({
    this.currentDay = 0,
    this.totalDays = 0,
    this.doneDays = 0,
    this.currentWeekNumber = 1,
    this.startDate,
    this.completedLessons = const [],
    this.weeks = const [],
    this.streak = 0,
    this.lastActivityDate,
  });

  /// Current day in the journey (1-based).
  final int currentDay;

  /// Total days/lessons in the journey.
  final int totalDays;

  /// Number of completed lessons (for display).
  final int doneDays;

  /// Current week number (1-based, from backend).
  final int currentWeekNumber;

  /// Journey start date.
  final DateTime? startDate;

  /// List of completed lesson IDs.
  final List<String> completedLessons;

  /// Weeks with lessons.
  final List<WeekEntity> weeks;

  /// Current streak (consecutive days).
  final int streak;

  /// Last activity date.
  final DateTime? lastActivityDate;

  /// Progress percentage (0-100) from completed/total lessons.
  double get progressPercentage {
    if (totalDays == 0) return 0;
    return (doneDays / totalDays) * 100;
  }

  /// Check if journey is complete.
  bool get isComplete => totalDays > 0 && doneDays >= totalDays;

  /// Get remaining lessons.
  int get remainingDays => totalDays - doneDays;

  /// Check if a lesson is completed.
  bool isLessonCompleted(String lessonId) => completedLessons.contains(lessonId);
}

/// Week in the journey.
@immutable
class WeekEntity {
  const WeekEntity({
    this.id,
    required this.weekNumber,
    required this.title,
    this.titleAr,
    this.description,
    this.descriptionAr,
    this.icon,
    this.iconUrl,
    this.lessons = const [],
    this.isUnlocked = false,
    this.isCompleted = false,
    this.isCurrent = false,
    this.doneCount = 0,
    this.totalCount = 0,
  });

  /// Week id from backend (for stable keys and API).
  final Object? id;

  /// Week number (1-based).
  final int weekNumber;

  /// Week title (English).
  final String title;

  /// Week title (Arabic).
  final String? titleAr;

  /// Week description (English).
  final String? description;

  /// Week description (Arabic).
  final String? descriptionAr;

  /// Icon: backend key (e.g. file slug from assets/icons).
  final String? icon;

  /// Absolute or relative icon asset URL from API (`icon_url`).
  final String? iconUrl;

  /// Lessons in this week.
  final List<LessonSummaryEntity> lessons;

  /// Whether week is unlocked.
  final bool isUnlocked;

  /// Whether week is completed.
  final bool isCompleted;

  /// Whether this is the current active week.
  final bool isCurrent;

  /// Number of completed lessons in this week (from backend).
  final int doneCount;

  /// Total lessons in this week (from backend).
  final int totalCount;

  /// Get localized title.
  String getTitle(String locale) {
    if (locale == 'ar' && titleAr != null) return titleAr!;
    return title;
  }

  /// Progress percentage for this week (uses backend counts when available).
  double get progressPercentage {
    final total = totalCount > 0 ? totalCount : lessons.length;
    if (total == 0) return 0;
    final done = totalCount > 0 ? doneCount : lessons.where((l) => l.isCompleted).length;
    return (done / total) * 100;
  }

  /// Display done count: backend value or derived from lessons.
  int get displayDoneCount => totalCount > 0 ? doneCount : lessons.where((l) => l.isCompleted).length;

  /// Display total count: backend value or lessons length.
  int get displayTotalCount => totalCount > 0 ? totalCount : lessons.length;
}

/// Lesson summary for journey view.
@immutable
class LessonSummaryEntity {
  const LessonSummaryEntity({
    required this.id,
    required this.dayNumber,
    required this.title,
    this.titleAr,
    this.duration,
    this.isCompleted = false,
    this.isUnlocked = false,
    this.completedAt,
  });

  /// Lesson ID.
  final String id;

  /// Day number (1-40).
  final int dayNumber;

  /// Lesson title (English).
  final String title;

  /// Lesson title (Arabic).
  final String? titleAr;

  /// Estimated duration in minutes.
  final int? duration;

  /// Whether lesson is completed.
  final bool isCompleted;

  /// Whether lesson is unlocked.
  final bool isUnlocked;

  /// Completion timestamp.
  final DateTime? completedAt;

  /// Get localized title.
  String getTitle(String locale) {
    if (locale == 'ar' && titleAr != null) return titleAr!;
    return title;
  }
}

/// Full lesson entity (current/active lesson for home, or lesson detail from API).
@immutable
class LessonEntity {
  const LessonEntity({
    required this.id,
    required this.dayNumber,
    required this.title,
    this.weekNumber,
    this.titleAr,
    this.description,
    this.descriptionAr,
    this.content,
    this.contentAr,
    this.videoUrl,
    this.audioUrl,
    this.imageUrl,
    this.duration,
    this.category,
    this.objectives = const [],
    this.keyPoints = const [],
    this.resources = const [],
    this.quiz,
    this.isCompleted = false,
    this.completedAt,
  });

  /// Lesson ID.
  final String id;

  /// Day number (1-40).
  final int dayNumber;

  /// Week number (1-based), when available from API (e.g. GET /lessons/today).
  final int? weekNumber;

  /// Lesson title (English).
  final String title;

  /// Lesson title (Arabic).
  final String? titleAr;

  /// Lesson description (English).
  final String? description;

  /// Lesson description (Arabic).
  final String? descriptionAr;

  /// Lesson content/body (English).
  final String? content;

  /// Lesson content/body (Arabic).
  final String? contentAr;

  /// Video URL.
  final String? videoUrl;

  /// Audio URL.
  final String? audioUrl;

  /// Image URL.
  final String? imageUrl;

  /// Duration in minutes.
  final int? duration;

  /// Lesson category.
  final String? category;

  /// Learning objectives.
  final List<String> objectives;

  /// Key points/takeaways.
  final List<String> keyPoints;

  /// Additional resources.
  final List<LessonResourceEntity> resources;

  /// Quiz for this lesson.
  final LessonQuizEntity? quiz;

  /// Whether lesson is completed.
  final bool isCompleted;

  /// Completion timestamp.
  final DateTime? completedAt;

  /// Get localized title.
  String getTitle(String locale) {
    if (locale == 'ar' && titleAr != null) return titleAr!;
    return title;
  }

  /// Get localized content.
  String? getContent(String locale) {
    if (locale == 'ar' && contentAr != null) return contentAr;
    return content;
  }
}

/// Lesson resource.
@immutable
class LessonResourceEntity {
  const LessonResourceEntity({
    required this.id,
    required this.title,
    this.titleAr,
    required this.type,
    required this.url,
  });

  final String id;
  final String title;
  final String? titleAr;
  final String type; // 'video', 'audio', 'article', 'pdf'
  final String url;
}

/// Lesson quiz.
@immutable
class LessonQuizEntity {
  const LessonQuizEntity({
    required this.id,
    required this.questions,
    this.passingScore = 70,
  });

  final String id;
  final List<QuizQuestionEntity> questions;
  final int passingScore;
}

/// Quiz question.
@immutable
class QuizQuestionEntity {
  const QuizQuestionEntity({
    required this.id,
    required this.question,
    this.questionAr,
    required this.options,
    required this.correctOptionIndex,
  });

  final String id;
  final String question;
  final String? questionAr;
  final List<String> options;
  final int correctOptionIndex;
}
