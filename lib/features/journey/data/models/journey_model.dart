/// Journey models for API serialization.
library;

import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';

/// Journey model.
class JourneyModel extends JourneyEntity {
  const JourneyModel({
    super.currentDay,
    super.totalDays,
    super.doneDays,
    super.currentWeekNumber,
    super.startDate,
    super.completedLessons,
    super.weeks,
    super.streak,
    super.lastActivityDate,
  });

  /// Parse backend journey API response: { plan, overall, weeks }.
  factory JourneyModel.fromJson(Map<String, dynamic> json) {
    final overall = json['overall'] is Map<String, dynamic>
        ? json['overall'] as Map<String, dynamic>
        : <String, dynamic>{};
    final weeksRaw = json['weeks'];
    final weeksList = weeksRaw is List<dynamic> ? weeksRaw : <dynamic>[];
    final weeks = <WeekModel>[];
    for (final e in weeksList) {
      if (e is Map<String, dynamic>) {
        weeks.add(WeekModel.fromBackendJson(e));
      }
    }

    final totalDays = overall['total_days'] as int? ?? 0;
    final doneDays = overall['done_days'] as int? ?? 0;
    final currentWeek = overall['current_week'] as int? ?? 1;

    return JourneyModel(
      currentDay: 0,
      totalDays: totalDays,
      doneDays: doneDays,
      currentWeekNumber: currentWeek,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      completedLessons: const [],
      weeks: weeks,
      streak: json['streak'] as int? ?? 0,
      lastActivityDate: json['last_activity_date'] != null
          ? DateTime.tryParse(json['last_activity_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_day': currentDay,
      'total_days': totalDays,
      'done_days': doneDays,
      'overall': {
        'total_days': totalDays,
        'done_days': doneDays,
        'current_week': currentWeekNumber,
      },
      'weeks': weeks.map((e) => (e as WeekModel).toJson()).toList(),
      'start_date': startDate?.toIso8601String(),
      'completed_lessons': completedLessons,
      'streak': streak,
      'last_activity_date': lastActivityDate?.toIso8601String(),
    };
  }
}

/// Week model.
class WeekModel extends WeekEntity {
  const WeekModel({
    super.id,
    required super.weekNumber,
    required super.title,
    super.titleAr,
    super.description,
    super.descriptionAr,
    super.icon,
    super.iconUrl,
    super.lessons,
    super.isUnlocked,
    super.isCompleted,
    super.isCurrent = false,
    super.doneCount = 0,
    super.totalCount = 0,
  });

  /// Parse week from API (has days[]) or from cache (has lessons[] at top level).
  factory WeekModel.fromBackendJson(Map<String, dynamic> json) {
    final id = json['id'];
    final weekNumber = json['week_number'] as int? ?? 1;
    final title = json['title'] as String? ?? 'Week $weekNumber';
    final isCurrent = json['is_current'] as bool? ?? false;
    final done = json['done'] as int? ?? 0;
    final total = json['total'] as int? ?? 0;

    List<LessonSummaryModel> lessons;
    final days = json['days'] is List<dynamic> ? json['days'] as List<dynamic> : <dynamic>[];
    if (days.isNotEmpty) {
      lessons = <LessonSummaryModel>[];
      for (final dayObj in days) {
        if (dayObj is! Map<String, dynamic>) continue;
        final dayNum = dayObj['day'] as int? ?? 1;
        final dayLessons = dayObj['lessons'];
        final lessonList = dayLessons is List<dynamic> ? dayLessons : <dynamic>[];
        for (final les in lessonList) {
          if (les is Map<String, dynamic>) {
            lessons.add(
              LessonSummaryModel.fromBackendLessonJson(les, dayNumber: dayNum),
            );
          }
        }
      }
    } else {
      // Cache format: lessons at top level (from toJson)
      final lessonsRaw = json['lessons'];
      final list = lessonsRaw is List<dynamic> ? lessonsRaw : <dynamic>[];
      lessons = list
          .whereType<Map<String, dynamic>>()
          .map((e) => LessonSummaryModel.fromJson(e))
          .toList();
    }

    final totalCount = total > 0 ? total : lessons.length;
    return WeekModel(
      id: id,
      weekNumber: weekNumber,
      title: title,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      lessons: lessons,
      isUnlocked: true,
      isCompleted: totalCount > 0 && done >= totalCount,
      isCurrent: isCurrent,
      doneCount: done,
      totalCount: totalCount,
    );
  }

  factory WeekModel.fromJson(Map<String, dynamic> json) {
    return WeekModel(
      id: json['id'],
      weekNumber: json['week_number'] as int? ?? json['week'] as int? ?? 1,
      title: json['title'] as String? ?? 'Week ${json['week_number'] ?? 1}',
      titleAr: json['title_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      icon: json['icon_key'] as String? ?? json['icon'] as String?,
      iconUrl: json['icon_url'] as String?,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonSummaryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isUnlocked: json['is_unlocked'] as bool? ?? json['unlocked'] as bool? ?? false,
      isCompleted: json['is_completed'] as bool? ?? json['completed'] as bool? ?? false,
      isCurrent: json['is_current'] as bool? ?? false,
      doneCount: json['done'] as int? ?? 0,
      totalCount: json['total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'week_number': weekNumber,
      'title': title,
      'title_ar': titleAr,
      'description': description,
      'description_ar': descriptionAr,
      'icon': icon,
      'icon_url': iconUrl,
      'lessons': lessons.map((e) => (e as LessonSummaryModel).toJson()).toList(),
      'is_unlocked': isUnlocked,
      'is_completed': isCompleted,
      'is_current': isCurrent,
      'done': doneCount,
      'total': totalCount,
    };
  }
}

/// Lesson summary model.
class LessonSummaryModel extends LessonSummaryEntity {
  const LessonSummaryModel({
    required super.id,
    required super.dayNumber,
    required super.title,
    super.titleAr,
    super.duration,
    super.isCompleted,
    super.isUnlocked,
    super.completedAt,
  });

  /// Backend lesson shape: { id, title, minutes, category, type, is_done, is_current, is_locked }.
  factory LessonSummaryModel.fromBackendLessonJson(
    Map<String, dynamic> json, {
    required int dayNumber,
  }) {
    final id = (json['id'] ?? '').toString();
    final isDone = json['is_done'] as bool? ?? false;
    final isLocked = json['is_locked'] as bool? ?? true;
    return LessonSummaryModel(
      id: id,
      dayNumber: dayNumber,
      title: json['title'] as String? ?? 'Lesson',
      duration: json['minutes'] as int?,
      isCompleted: isDone,
      isUnlocked: !isLocked,
      completedAt: null,
    );
  }

  factory LessonSummaryModel.fromJson(Map<String, dynamic> json) {
    return LessonSummaryModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      dayNumber: json['day_number'] as int? ?? json['day'] as int? ?? 1,
      title: json['title'] as String? ?? 'Day ${json['day_number'] ?? 1}',
      titleAr: json['title_ar'] as String?,
      duration: json['duration'] as int?,
      isCompleted: json['is_completed'] as bool? ?? json['completed'] as bool? ?? false,
      isUnlocked: json['is_unlocked'] as bool? ?? json['unlocked'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_number': dayNumber,
      'title': title,
      'title_ar': titleAr,
      'duration': duration,
      'is_completed': isCompleted,
      'is_unlocked': isUnlocked,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

/// Lesson model.
class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.dayNumber,
    required super.title,
    super.weekNumber,
    super.titleAr,
    super.description,
    super.descriptionAr,
    super.content,
    super.contentAr,
    super.videoUrl,
    super.audioUrl,
    super.imageUrl,
    super.duration,
    super.category,
    super.objectives,
    super.keyPoints,
    super.resources,
    super.quiz,
    super.isCompleted,
    super.completedAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: (json['id'] ?? json['lesson_id'] ?? json['_id'] ?? '').toString(),
      dayNumber: json['day_number'] as int? ?? json['day'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      weekNumber: json['week_number'] as int? ?? json['week'] as int?,
      titleAr: json['title_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      content: json['content'] as String? ?? json['body'] as String?,
      contentAr: json['content_ar'] as String?,
      videoUrl: json['video_url'] as String? ?? json['video'] as String?,
      audioUrl: json['audio_url'] as String? ?? json['audio'] as String?,
      imageUrl: json['image_url'] as String? ?? json['image'] as String?,
      duration: json['duration'] as int? ??
          json['estimated_read_time'] as int? ??
          json['estimated_minutes'] as int?,
      category: json['category'] as String?,
      objectives: (json['objectives'] as List<dynamic>?)?.cast<String>() ?? [],
      keyPoints: (json['key_points'] as List<dynamic>?)?.cast<String>() ?? [],
      resources: (json['resources'] as List<dynamic>?)
              ?.map((e) => LessonResourceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      quiz: json['quiz'] != null
          ? LessonQuizModel.fromJson(json['quiz'] as Map<String, dynamic>)
          : null,
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_number': dayNumber,
      'week_number': weekNumber,
      'title': title,
      'title_ar': titleAr,
      'description': description,
      'description_ar': descriptionAr,
      'content': content,
      'content_ar': contentAr,
      'video_url': videoUrl,
      'audio_url': audioUrl,
      'image_url': imageUrl,
      'duration': duration,
      'category': category,
      'objectives': objectives,
      'key_points': keyPoints,
      'resources': resources.map((e) => (e as LessonResourceModel).toJson()).toList(),
      'quiz': quiz != null ? (quiz as LessonQuizModel).toJson() : null,
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

/// Lesson resource model.
class LessonResourceModel extends LessonResourceEntity {
  const LessonResourceModel({
    required super.id,
    required super.title,
    super.titleAr,
    required super.type,
    required super.url,
  });

  factory LessonResourceModel.fromJson(Map<String, dynamic> json) {
    return LessonResourceModel(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      type: json['type'] as String? ?? 'article',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'type': type,
      'url': url,
    };
  }
}

/// Lesson quiz model.
class LessonQuizModel extends LessonQuizEntity {
  const LessonQuizModel({
    required super.id,
    required super.questions,
    super.passingScore,
  });

  factory LessonQuizModel.fromJson(Map<String, dynamic> json) {
    return LessonQuizModel(
      id: (json['id'] ?? '').toString(),
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => QuizQuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      passingScore: json['passing_score'] as int? ?? 70,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questions': questions.map((e) => (e as QuizQuestionModel).toJson()).toList(),
      'passing_score': passingScore,
    };
  }
}

/// Quiz question model.
class QuizQuestionModel extends QuizQuestionEntity {
  const QuizQuestionModel({
    required super.id,
    required super.question,
    super.questionAr,
    required super.options,
    required super.correctOptionIndex,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: (json['id'] ?? '').toString(),
      question: json['question'] as String? ?? '',
      questionAr: json['question_ar'] as String?,
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? [],
      correctOptionIndex: json['correct_option_index'] as int? ??
          json['correct_index'] as int? ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'question_ar': questionAr,
      'options': options,
      'correct_option_index': correctOptionIndex,
    };
  }
}
