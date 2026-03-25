/// Provider and notifier for lesson details screen.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:flutter_app/features/lessons/presentation/state/lesson_details_state.dart';
import 'package:flutter_app/features/lessons/providers/lessons_providers.dart';

/// Lesson route param (String) = backend lesson id. API only; no mock/Lovable content.
final lessonDetailsProvider =
    StateNotifierProvider.family<LessonDetailsNotifier, LessonDetailsState, String>(
  (ref, lessonId) {
    final repository = ref.watch(lessonsRepositoryProvider);
    return LessonDetailsNotifier(lessonId: lessonId, repository: repository, ref: ref);
  },
);

class LessonDetailsNotifier extends StateNotifier<LessonDetailsState> {
  LessonDetailsNotifier({
    required this.lessonId,
    required LessonsRepository repository,
    required Ref ref,
  })  : _repository = repository,
        _ref = ref,
        super(const LessonDetailsLoading()) {
    load();
  }

  final String lessonId;
  final LessonsRepository _repository;
  final Ref _ref;

  Future<void> load() async {
    state = const LessonDetailsLoading();
    try {
      final locale = _ref.read(localeControllerProvider).languageCode;
      final lesson = await _repository.getLessonById(lessonId, locale: locale);
      if (lesson == null) {
        state = const LessonDetailsError('Lesson not found');
        return;
      }
      final existingReflection = lesson.reflectionText ?? '';
      state = LessonDetailsLoaded(
        lesson: lesson,
        isCompleted: false,
        reflectionText: existingReflection,
        nextLessonId: null,
        reflectionSaved: existingReflection.isNotEmpty,
      );
    } catch (e) {
      state = LessonDetailsError(e.toString());
    }
  }

  Future<void> completeLesson() async {
    final current = state;
    if (current is! LessonDetailsLoaded || current.isCompleted) return;
    try {
      await _repository.completeLessonById(current.lesson.id);
      state = LessonDetailsLoaded(
        lesson: current.lesson,
        isCompleted: true,
        reflectionText: current.reflectionText,
        nextLessonId: current.nextLessonId,
        reflectionSaved: current.reflectionSaved,
      );
    } catch (_) {
      // Keep state; could show error
    }
  }

  Future<void> saveReflection(String text) async {
    final current = state;
    if (current is! LessonDetailsLoaded) return;
    final normalized = text.trim();
    try {
      await _repository.saveReflection(current.lesson.id, normalized);
      state = LessonDetailsLoaded(
        lesson: current.lesson,
        isCompleted: current.isCompleted,
        reflectionText: normalized,
        nextLessonId: current.nextLessonId,
        reflectionSaved: normalized.isNotEmpty,
      );
    } catch (_) {
      // Keep state; could show error
    }
  }

  void setReflectionText(String text) {
    final current = state;
    if (current is! LessonDetailsLoaded) return;
    state = LessonDetailsLoaded(
      lesson: current.lesson,
      isCompleted: current.isCompleted,
      reflectionText: text,
      nextLessonId: current.nextLessonId,
      reflectionSaved: current.reflectionSaved,
    );
  }
}
