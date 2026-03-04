/// Prayer feature providers: location, address, timings, and UI state.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/features/prayer/data/location_service.dart';
import 'package:flutter_app/features/prayer/data/prayer_models.dart';
import 'package:flutter_app/features/prayer/data/prayer_repository.dart';
import 'package:flutter_app/features/prayer/providers/location_notifier.dart';

/// AlAdhan prayer repository.
final prayerRepositoryProvider = Provider<PrayerRepository>((ref) => PrayerRepository());

/// Location service for cache.
final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

/// Location state: cache-first; permission requested only when user taps "Use current location".
/// State is loading -> then data(LocationResult?) from cache or data(null). No auto permission.
final locationNotifierProvider =
    StateNotifierProvider<LocationNotifier, AsyncValue<LocationResult?>>((ref) {
  return LocationNotifier(ref.watch(locationServiceProvider));
});

/// Expose location state for UI (same as notifier state).
final locationResultProvider = Provider<AsyncValue<LocationResult?>>((ref) {
  return ref.watch(locationNotifierProvider);
});

/// Manual address when location is denied or failed. User can type and submit.
final manualAddressProvider = StateProvider<String?>((ref) => null);

/// Effective address: manual first, then from location (cache or last fetch). Null if neither available.
final effectiveAddressProvider = Provider<String?>((ref) {
  final manual = ref.watch(manualAddressProvider);
  if (manual != null && manual.trim().isNotEmpty) return manual.trim();
  final locationAsync = ref.watch(locationNotifierProvider);
  return locationAsync.valueOrNull?.address;
});

/// Today's date (local) for consistent date used in timings.
final todayDateProvider = Provider<DateTime>((ref) {
  final now = ref.watch(currentTimeProvider);
  return DateTime(now.year, now.month, now.day);
});

/// Current time; updates every minute for "remaining" and status.
final currentTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Timer that refreshes currentTimeProvider every minute. Watch this provider
/// from the prayer page so the timer runs while the page is visible.
final currentTimeTickerProvider = Provider<void>((ref) {
  final timer = Timer.periodic(const Duration(minutes: 1), (_) {
    ref.read(currentTimeProvider.notifier).state = DateTime.now();
  });
  ref.onDispose(() => timer.cancel());
});

/// Timings for today: map of prayer name -> "HH:mm".
final prayerTimingsTodayProvider = FutureProvider<Map<String, String>>((ref) async {
  ref.watch(currentTimeTickerProvider);
  final address = ref.watch(effectiveAddressProvider);
  if (address == null || address.isEmpty) return {};
  final repo = ref.watch(prayerRepositoryProvider);
  final today = ref.watch(todayDateProvider);
  return repo.getTimingsForDate(address: address, date: today);
});

/// Timings for tomorrow (used when now is after Isha).
final prayerTimingsTomorrowProvider = FutureProvider<Map<String, String>>((ref) async {
  final address = ref.watch(effectiveAddressProvider);
  if (address == null || address.isEmpty) return {};
  final repo = ref.watch(prayerRepositoryProvider);
  final today = ref.watch(todayDateProvider);
  final tomorrow = today.add(const Duration(days: 1));
  return repo.getTimingsForDate(address: address, date: tomorrow);
});

/// Today's prayer list with status and remaining. After Isha, next = tomorrow Fajr.
final todayPrayerListProvider = Provider<AsyncValue<List<PrayerCardData>>>((ref) {
  ref.watch(currentTimeTickerProvider);
  final now = ref.watch(currentTimeProvider);
  final todayAsync = ref.watch(prayerTimingsTodayProvider);
  final tomorrowAsync = ref.watch(prayerTimingsTomorrowProvider);

  return todayAsync.when(
    data: (todayMap) {
      if (todayMap.isEmpty) {
        return const AsyncValue.data([]);
      }
      final tomorrowMap = tomorrowAsync.valueOrNull ?? {};
      final baseDate = DateTime(now.year, now.month, now.day);
      final list = <PrayerCardData>[];
      int nextIndex = -1;
      for (var i = 0; i < prayerNamesOrder.length; i++) {
        final name = prayerNamesOrder[i];
        final timeStr = todayMap[name];
        if (timeStr == null) continue;
        final timeDt = parsePrayerTimeToDateTime(timeStr, baseDate);
        PrayerStatus status;
        if (timeDt.isBefore(now)) {
          status = PrayerStatus.done;
        } else {
          if (nextIndex < 0) nextIndex = i;
          status = nextIndex == i ? PrayerStatus.next : PrayerStatus.upcoming;
        }
        String? remaining;
        if (status == PrayerStatus.next) {
          remaining = formatRemaining(timeDt.difference(now));
        }
        list.add(PrayerCardData(
          name: name,
          time: timeStr,
          status: status,
          remaining: remaining,
          timeAsDateTime: timeDt,
        ));
      }
      // If all today's prayers are past, next = tomorrow Fajr
      if (nextIndex < 0 && tomorrowMap.isNotEmpty) {
        final fajrStr = tomorrowMap['Fajr'];
        if (fajrStr != null) {
          final tomorrowDate = baseDate.add(const Duration(days: 1));
          final fajrDt = parsePrayerTimeToDateTime(fajrStr, tomorrowDate);
          final remaining = formatRemaining(fajrDt.difference(now));
          list.add(PrayerCardData(
            name: 'Fajr',
            time: fajrStr,
            status: PrayerStatus.next,
            remaining: remaining,
            timeAsDateTime: fajrDt,
          ));
        }
      }
      return AsyncValue.data(list);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

/// Daily progress from today's list.
final dailyProgressProvider = Provider<AsyncValue<DailyProgressData>>((ref) {
  final listAsync = ref.watch(todayPrayerListProvider);
  return listAsync.when(
    data: (List<PrayerCardData> list) {
      final completed = list.where((p) => p.status == PrayerStatus.done).length;
      final nextOrUpcoming = list.where((p) => p.status == PrayerStatus.next || p.status == PrayerStatus.upcoming).length;
      return AsyncValue.data(DailyProgressData(
        completed: completed,
        missed: 0,
        remaining: nextOrUpcoming,
        total: 5,
      ));
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

/// Refresh location (reload from cache; for "Use current location" use notifier.requestLocation()).
final refreshLocationProvider = Provider<void Function()>((ref) => () async {
      await ref.read(locationNotifierProvider.notifier).loadFromCacheIfNeeded();
    });

/// Refresh prayer timings.
final refreshPrayerTimingsProvider = Provider<void Function()>((ref) => () {
      ref
        ..invalidate(prayerTimingsTodayProvider)
        ..invalidate(prayerTimingsTomorrowProvider);
    });
