/// Journey summary API model.
library;

import 'package:flutter_app/features/journey/domain/entities/journey_summary_entity.dart';

/// Model for GET /api/v1/journey/summary response.
class JourneySummaryModel extends JourneySummaryEntity {
  const JourneySummaryModel({
    super.dayIndex,
    super.totalDays,
    super.streakDays,
    super.activeWeeks,
    super.leftDays,
    super.completedLessons,
    super.totalLessons,
    super.completionPercent,
    super.milestones,
    super.currentLesson,
  });

  factory JourneySummaryModel.fromJson(Map<String, dynamic> json) {
    final milestones = (json['milestones'] as List<dynamic>?)
            ?.map((e) => JourneyMilestoneModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final currentLesson = json['current_lesson'] != null
        ? JourneyCurrentLessonModel.fromJson(
            json['current_lesson'] as Map<String, dynamic>,
          )
        : null;

    return JourneySummaryModel(
      dayIndex: json['day_index'] as int? ?? 1,
      totalDays: json['total_days'] as int? ?? 90,
      streakDays: json['streak_days'] as int? ?? 0,
      activeWeeks: json['active_weeks'] as int? ?? 0,
      leftDays: json['left_days'] as int? ?? 0,
      completedLessons: json['completed_lessons'] as int? ?? 0,
      totalLessons: json['total_lessons'] as int? ?? 90,
      completionPercent: (json['completion_percent'] as num?)?.toDouble() ?? 0.0,
      milestones: milestones,
      currentLesson: currentLesson,
    );
  }
}

class JourneyMilestoneModel extends JourneyMilestoneEntity {
  const JourneyMilestoneModel({
    required super.week,
    required super.status,
    super.completedLessons,
    super.totalLessons,
  });

  factory JourneyMilestoneModel.fromJson(Map<String, dynamic> json) {
    return JourneyMilestoneModel(
      week: json['week'] as int? ?? 1,
      status: json['status'] as String? ?? 'locked',
      completedLessons: json['completed_lessons'] as int? ?? 0,
      totalLessons: json['total_lessons'] as int? ?? 0,
    );
  }
}

class JourneyCurrentLessonModel extends JourneyCurrentLessonEntity {
  const JourneyCurrentLessonModel({
    required super.lessonId,
    required super.title,
    required super.week,
    required super.day,
    super.status,
  });

  factory JourneyCurrentLessonModel.fromJson(Map<String, dynamic> json) {
    return JourneyCurrentLessonModel(
      lessonId: json['lesson_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      week: json['week'] as int? ?? 1,
      day: json['day'] as int? ?? 1,
      status: json['status'] as String? ?? 'current',
    );
  }
}
