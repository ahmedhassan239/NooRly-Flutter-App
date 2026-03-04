/// Prayer times repository using AlAdhan API (address-based).
library;

import 'package:dio/dio.dart';
import 'package:flutter_app/features/prayer/data/prayer_api.dart';
import 'package:flutter_app/features/prayer/data/prayer_models.dart';

/// Repository for fetching prayer times from AlAdhan.
class PrayerRepository {
  PrayerRepository({Dio? dio}) : _dio = dio;

  final Dio? _dio;

  /// Fetch timings for [date] at [address].
  /// Returns map of prayer name -> "HH:mm" (normalized; Fajr, Dhuhr, Asr, Maghrib, Isha only).
  /// Uses method=5 (Egypt) and school=0 (Shafi) by default for Cairo-compatible times.
  Future<Map<String, String>> getTimingsForDate({
    required String address,
    required DateTime date,
    int method = defaultMethod,
    int school = defaultSchool,
  }) async {
    final dateStr = formatDateDDMMYYYY(date);
    final res = await getTimingsByAddress(
      dateDDMMYYYY: dateStr,
      address: address,
      method: method,
      school: school,
      dio: _dio,
    );
    if (res == null || res.timings.isEmpty) return {};
    return extractPrayerTimings(res.timings);
  }

  /// Next prayer is computed locally from timings (todayPrayerListProvider); this is optional.
  Future<AlAdhanNextPrayerResponse?> getNextPrayer({
    required String address,
    required DateTime date,
    int method = defaultMethod,
    int school = defaultSchool,
  }) async {
    final dateStr = formatDateDDMMYYYY(date);
    return getNextPrayerByAddress(
      dateDDMMYYYY: dateStr,
      address: address,
      method: method,
      school: school,
      dio: _dio,
    );
  }
}
