import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/features/lessons/data/lesson_content_data.dart';

/// Saved lesson data for display
class SavedLessonData {
  final int dayNumber;
  final String title;
  final String category;
  final String duration;
  final DateTime savedAt;

  const SavedLessonData({
    required this.dayNumber,
    required this.title,
    required this.category,
    required this.duration,
    required this.savedAt,
  });
}

/// State notifier for managing saved lessons
class SavedLessonsNotifier extends StateNotifier<List<SavedLessonData>> {
  SavedLessonsNotifier() : super([]);

  bool isLessonSaved(int dayNumber) {
    return state.any((lesson) => lesson.dayNumber == dayNumber);
  }

  void toggleSaveLesson(int dayNumber) {
    if (isLessonSaved(dayNumber)) {
      unsaveLesson(dayNumber);
    } else {
      saveLesson(dayNumber);
    }
  }

  void saveLesson(int dayNumber) {
    if (isLessonSaved(dayNumber)) return;

    final lessonContent = LessonContentData.getLessonByDay(dayNumber);
    if (lessonContent == null) return;

    final savedLesson = SavedLessonData(
      dayNumber: dayNumber,
      title: lessonContent.title,
      category: lessonContent.category,
      duration: lessonContent.duration,
      savedAt: DateTime.now(),
    );

    state = [...state, savedLesson];
  }

  void unsaveLesson(int dayNumber) {
    state = state.where((lesson) => lesson.dayNumber != dayNumber).toList();
  }

  void clearAllSaved() {
    state = [];
  }
}

/// Provider for saved lessons
final savedLessonsProvider =
    StateNotifierProvider<SavedLessonsNotifier, List<SavedLessonData>>(
  (ref) => SavedLessonsNotifier(),
);

/// Helper provider to check if a specific lesson is saved
final isLessonSavedProvider = Provider.family<bool, int>((ref, dayNumber) {
  final savedLessons = ref.watch(savedLessonsProvider);
  return savedLessons.any((lesson) => lesson.dayNumber == dayNumber);
});

/// Provider for saved lessons count
final savedLessonsCountProvider = Provider<int>((ref) {
  return ref.watch(savedLessonsProvider).length;
});
