/// Home dashboard providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/hadith/data/daily_hadith_api.dart';
import 'package:flutter_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_app/features/home/domain/entities/home_entity.dart';
import 'package:flutter_app/features/home/domain/repositories/home_repository.dart';

/// Home repository provider.
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeRepositoryImpl(apiClient: apiClient);
});

/// Home dashboard provider.
final homeDashboardProvider = FutureProvider<HomeDashboardEntity>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);

  // Try cached data first for faster startup
  final cached = await repository.getCachedDashboard();
  if (cached != null) {
    // Refresh in background
    repository.getDashboard().ignore();
    return cached;
  }

  return repository.getDashboard();
});

/// Daily verse provider.
final dailyVerseProvider = Provider<DailyVerseEntity?>((ref) {
  final dashboardAsync = ref.watch(homeDashboardProvider);
  return dashboardAsync.maybeWhen(
    data: (dashboard) => dashboard.dailyVerse,
    orElse: () => null,
  );
});

/// User progress provider.
final userProgressProvider = Provider<UserProgressEntity?>((ref) {
  final dashboardAsync = ref.watch(homeDashboardProvider);
  return dashboardAsync.maybeWhen(
    data: (dashboard) => dashboard.userProgress,
    orElse: () => null,
  );
});

/// Featured content provider.
final featuredContentProvider = Provider<List<FeaturedContentEntity>>((ref) {
  final dashboardAsync = ref.watch(homeDashboardProvider);
  return dashboardAsync.maybeWhen(
    data: (dashboard) => dashboard.featuredContent,
    orElse: () => [],
  );
});

/// Quick stats provider.
final quickStatsProvider = Provider<List<QuickStatEntity>>((ref) {
  final dashboardAsync = ref.watch(homeDashboardProvider);
  return dashboardAsync.maybeWhen(
    data: (dashboard) => dashboard.quickStats,
    orElse: () => [],
  );
});

/// Daily hadith for home inspiration (GET /hadith/daily).
final dailyHadithProvider = FutureProvider<DailyHadithDto?>((ref) {
  return fetchDailyHadith(ref);
});

/// Refresh home dashboard.
final refreshHomeDashboardProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    ref.invalidate(homeDashboardProvider);
  };
});
