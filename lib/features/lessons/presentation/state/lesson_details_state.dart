/// State for the lesson details screen.
library;

import 'package:flutter_app/features/lessons/domain/entities/lesson_entity.dart';

/// Base state for lesson details.
sealed class LessonDetailsState {
  const LessonDetailsState();
}

/// Loading lesson.
class LessonDetailsLoading extends LessonDetailsState {
  const LessonDetailsLoading();
}

/// Lesson loaded from API only (no mock/Lovable content).
class LessonDetailsLoaded extends LessonDetailsState {
  const LessonDetailsLoaded({
    required this.lesson,
    required this.isCompleted,
    required this.reflectionText,
    this.nextLessonId,
    this.reflectionSaved = false,
  });

  final LessonEntity lesson;
  final bool isCompleted;
  final String reflectionText;
  final int? nextLessonId;
  final bool reflectionSaved;
}

/// Failed to load lesson.
class LessonDetailsError extends LessonDetailsState {
  const LessonDetailsError(this.message);
  final String message;
}
