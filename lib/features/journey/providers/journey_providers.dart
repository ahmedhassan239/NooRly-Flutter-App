/// Journey providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/journey/data/repositories/journey_repository_impl.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';
import 'package:flutter_app/features/journey/domain/repositories/journey_repository.dart';

/// Journey repository provider.
final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return JourneyRepositoryImpl(apiClient: apiClient);
});

/// Journey data provider.
final journeyProvider = FutureProvider<JourneyEntity>((ref) async {
  final repository = ref.watch(journeyRepositoryProvider);

  // Try cached data first
  final cached = await repository.getCachedJourney();
  if (cached != null) {
    // Refresh in background
    repository.getJourney().ignore();
    return cached;
  }

  return repository.getJourney();
});

/// Current day provider.
final currentDayProvider = Provider<int>((ref) {
  final journeyAsync = ref.watch(journeyProvider);
  return journeyAsync.maybeWhen(
    data: (journey) => journey.currentDay,
    orElse: () => 0,
  );
});

/// Journey progress provider.
final journeyProgressProvider = Provider<double>((ref) {
  final journeyAsync = ref.watch(journeyProvider);
  return journeyAsync.maybeWhen(
    data: (journey) => journey.progressPercentage,
    orElse: () => 0,
  );
});

/// Journey weeks provider.
final journeyWeeksProvider = Provider<List<WeekEntity>>((ref) {
  final journeyAsync = ref.watch(journeyProvider);
  return journeyAsync.maybeWhen(
    data: (journey) => journey.weeks,
    orElse: () => [],
  );
});

/// Today's / next lesson for home dashboard (GET /lessons/today). Fallback: first uncompleted from journey.
final todayLessonProvider = FutureProvider<LessonEntity?>((ref) async {
  final repository = ref.watch(journeyRepositoryProvider);
  final today = await repository.getTodayLesson();
  if (today != null) return today;
  // Fallback: first uncompleted lesson from journey
  final journeyAsync = ref.watch(journeyProvider);
  final journey = journeyAsync.valueOrNull;
  if (journey == null) return null;
  for (final week in journey.weeks) {
    for (final lesson in week.lessons) {
      if (!lesson.isCompleted && lesson.isUnlocked) {
        return repository.getLesson(lesson.id);
      }
    }
  }
  return null;
});

/// Lesson detail provider (by lesson id).
final lessonDetailProvider =
    FutureProvider.family<LessonEntity, String>((ref, id) async {
  final repository = ref.watch(journeyRepositoryProvider);
  return repository.getLesson(id);
});

/// Saved lessons provider.
final savedLessonsProvider = FutureProvider<List<LessonSummaryEntity>>((ref) async {
  final repository = ref.watch(journeyRepositoryProvider);
  return repository.getSavedLessons();
});

/// Complete lesson action (by lesson id).
class CompleteLessonNotifier extends StateNotifier<AsyncValue<void>> {
  CompleteLessonNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> complete(String lessonId) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(journeyRepositoryProvider).completeLesson(lessonId);
      // Refresh journey data
      _ref.invalidate(journeyProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Complete lesson provider.
final completeLessonProvider =
    StateNotifierProvider<CompleteLessonNotifier, AsyncValue<void>>((ref) {
  return CompleteLessonNotifier(ref);
});

/// Refresh journey provider.
final refreshJourneyProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    ref.invalidate(journeyProvider);
  };
});
