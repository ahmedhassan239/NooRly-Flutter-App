import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/lessons/data/datasources/lessons_local_datasource.dart';
import 'package:flutter_app/features/lessons/data/repositories/lessons_repository_impl.dart';
import 'package:flutter_app/features/lessons/domain/entities/lesson_entity.dart';
import 'package:flutter_app/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data Source Provider
final lessonsLocalDataSourceProvider = Provider<LessonsLocalDataSource>((ref) {
  return LessonsLocalDataSource();
});

/// Repository Provider
final lessonsRepositoryProvider = Provider<LessonsRepository>((ref) {
  final dataSource = ref.watch(lessonsLocalDataSourceProvider);
  final apiClient = ref.watch(apiClientProvider);
  return LessonsRepositoryImpl(dataSource, apiClient: apiClient);
});

/// All Lessons Provider
final allLessonsProvider = FutureProvider<List<LessonEntity>>((ref) async {
  final repository = ref.watch(lessonsRepositoryProvider);
  return repository.getAllLessons();
});

/// Week Titles Provider
final weekTitlesProvider = FutureProvider<Map<int, String>>((ref) async {
  final repository = ref.watch(lessonsRepositoryProvider);
  return repository.getWeekTitles();
});

/// Lessons by Week Provider
final lessonsByWeekProvider = FutureProvider.family<List<LessonEntity>, int>(
  (ref, weekNumber) async {
    final repository = ref.watch(lessonsRepositoryProvider);
    return repository.getLessonsByWeek(weekNumber);
  },
);

/// Lesson by Day Provider
final lessonByDayProvider = FutureProvider.family<LessonEntity?, int>(
  (ref, dayNumber) async {
    final repository = ref.watch(lessonsRepositoryProvider);
    return repository.getLessonByDay(dayNumber);
  },
);

/// Lesson by ID Provider
final lessonByIdProvider = FutureProvider.family<LessonEntity?, String>(
  (ref, id) async {
    final repository = ref.watch(lessonsRepositoryProvider);
    return repository.getLessonById(id);
  },
);
