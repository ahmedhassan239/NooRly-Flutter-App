/// Journey providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/journey/data/repositories/journey_repository_impl.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_summary_entity.dart';
import 'package:flutter_app/features/journey/domain/repositories/journey_repository.dart';

/// Journey repository provider.
final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return JourneyRepositoryImpl(apiClient: apiClient);
});

/// Journey data provider. Watches app locale so content is fetched and cached per language.
final journeyProvider = FutureProvider<JourneyEntity>((ref) async {
  final repository = ref.watch(journeyRepositoryProvider);
  final localeCode = ref.watch(localeControllerProvider).languageCode;

  final cached = await repository.getCachedJourney(localeCode: localeCode);
  try {
    // Always try network first so progression/unlock state stays current after
    // mutations (lesson completion). If network fails, we still return cache.
    return await repository.getJourney(localeCode: localeCode);
  } catch (_) {
    if (cached != null) return cached;
    rethrow;
  }
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

/// Journey profile summary for Profile screen (GET /journey/summary). Locale-aware.
final journeySummaryProvider =
    FutureProvider<JourneySummaryEntity>((ref) async {
  final repository = ref.watch(journeyRepositoryProvider);
  final localeCode = ref.watch(localeControllerProvider).languageCode;
  return repository.getJourneySummary(localeCode: localeCode);
});

/// Today's / next lesson for home dashboard (GET /lessons/today). Locale-aware; refetches when language changes.
final todayLessonProvider = FutureProvider<LessonEntity?>((ref) async {
  final repository = ref.watch(journeyRepositoryProvider);
  final localeCode = ref.watch(localeControllerProvider).languageCode;
  final today = await repository.getTodayLesson(localeCode: localeCode);
  if (today != null) return today;
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

/// Refresh journey provider (invalidates journey + current lesson + summary for home/profile).
final refreshJourneyProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    ref.invalidate(journeyProvider);
    ref.invalidate(todayLessonProvider);
    ref.invalidate(journeySummaryProvider);
  };
});
