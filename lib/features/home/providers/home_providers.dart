/// Home dashboard providers.
library;

import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/home/data/daily_inspiration_api.dart';
import 'package:flutter_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_app/features/home/domain/entities/home_entity.dart';
import 'package:flutter_app/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// Daily inspiration for home (GET /api/v1/daily-inspiration).
/// One random item from library: ayah, hadith, dhikr, or dua.
/// Uses local cache when mode is per_day (same item for the calendar day).
final dailyInspirationProvider = FutureProvider<DailyInspirationDto?>(getDailyInspiration);

/// Refresh home dashboard.
final refreshHomeDashboardProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    ref.invalidate(homeDashboardProvider);
  };
});
