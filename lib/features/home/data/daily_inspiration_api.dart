/// Daily inspiration for home (GET /api/v1/daily-inspiration).
/// One random item from library: ayah, hadith, dhikr, or dua.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Valid types from the library API. Content must be one of these.
const Set<String> kDailyInspirationValidTypes = {'ayah', 'hadith', 'dhikr', 'dua'};

/// Unified daily inspiration item from the API.
/// Type is one of: ayah, hadith, dhikr, dua.
class DailyInspirationDto {
  /// Content type: ayah, hadith, dhikr, dua
  final String type;

  /// Record id from the database
  final int id;

  /// Arabic text
  final String arabic;

  /// Translation (locale-based)
  final String translation;

  /// Display title (e.g. "Hadith", "Quran", "Dua", "Dhikr")
  final String? title;

  /// Source (hadith/dua/dhikr). Null for ayah.
  final String? source;

  /// Surah reference (ayah only), e.g. "Al-Baqarah 255"
  final String? surah;

  /// Ayah number (ayah only)
  final int? ayahNumber;

  const DailyInspirationDto({
    required this.type,
    required this.id,
    required this.arabic,
    required this.translation,
    this.title,
    this.source,
    this.surah,
    this.ayahNumber,
  });

  factory DailyInspirationDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final rawId = data['id'];
    final id = rawId is num ? rawId.toInt() : int.tryParse(rawId?.toString() ?? '0') ?? 0;
    final rawType = data['type'] as String?;
    final type = (rawType ?? '').toLowerCase().trim();
    return DailyInspirationDto(
      type: type.isEmpty ? 'unknown' : type,
      id: id,
      arabic: (data['arabic'] as String?) ?? '',
      translation: (data['translation'] as String?) ?? '',
      title: data['title'] as String?,
      source: data['source'] as String?,
      surah: data['surah'] as String?,
      ayahNumber: data['ayah_number'] is num
          ? (data['ayah_number'] as num).toInt()
          : data['ayah_number'] as int?,
    );
  }

  /// SaveButton type: verse for ayah, adhkar for dhikr
  String get saveButtonType {
    switch (type) {
      case 'ayah':
        return 'verse';
      case 'dhikr':
        return 'adhkar';
      default:
        return type;
    }
  }

  /// Reference line for display (source or surah)
  String get reference => source ?? surah ?? '';

  /// True if this DTO is from the library API and has required content.
  bool get isValid =>
      kDailyInspirationValidTypes.contains(type) &&
      id > 0 &&
      (arabic.isNotEmpty || translation.isNotEmpty);
}

/// Fetches daily inspiration from API (GET /api/v1/daily-inspiration).
/// Returns null on error or if payload is invalid (wrong type / missing content).
Future<DailyInspirationDto?> fetchDailyInspiration(Ref ref) async {
  try {
    final client = ref.read(apiClientProvider);
    final response = await client.get<Map<String, dynamic>>(
      HomeEndpoints.dailyInspiration,
    );
    if (!response.status || response.data == null) {
      if (kDebugMode) debugPrint('[DailyInspiration] API status=false or data=null');
      return null;
    }
    final data = response.data!;
    if (data.isEmpty) {
      if (kDebugMode) debugPrint('[DailyInspiration] API data empty');
      return null;
    }
    final dto = DailyInspirationDto.fromJson(data);
    if (!dto.isValid) {
      if (kDebugMode) {
        debugPrint(
          '[DailyInspiration] Invalid payload: type=${dto.type} id=${dto.id} '
          '(valid types: ${kDailyInspirationValidTypes.join(", ")})',
        );
      }
      return null;
    }
    if (kDebugMode) {
      debugPrint(
        '[DailyInspiration] type=${dto.type} id=${dto.id} '
        'reference=${dto.reference} source=${dto.source ?? "n/a"}',
      );
    }
    return dto;
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('[DailyInspiration] fetch error: $e');
      debugPrint(st.toString());
    }
    return null;
  }
}

/// Cache key for daily inspiration (date + dto json).
const String _kDailyInspirationCacheKey = 'noorly_daily_inspiration_cache';

/// Cache mode key: 'per_day' (same item all day) or 'per_launch' (new each provider load).
const String _kDailyInspirationCacheModeKey = 'noorly_daily_inspiration_cache_mode';

/// Cache mode: per_day = reuse same item for the same calendar day; per_launch = fetch each time provider runs.
enum DailyInspirationCacheMode {
  perDay,
  perLaunch,
}

extension on DailyInspirationCacheMode {
  String get key => this == DailyInspirationCacheMode.perDay ? 'per_day' : 'per_launch';
}

DailyInspirationCacheMode _cacheModeFromString(String? v) {
  if (v == 'per_launch') return DailyInspirationCacheMode.perLaunch;
  return DailyInspirationCacheMode.perDay;
}

String _todayDate() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

String _cacheKeyForLocale(String localeCode) =>
    '$_kDailyInspirationCacheKey\_${localeCode.replaceAll(RegExp(r'[^a-z]'), '')}';

/// Returns cached DTO for today if mode is per_day and cache exists and is valid; otherwise null.
/// [localeCode] is used so cache is per language (ar/en).
Future<DailyInspirationDto?> _getCachedDailyInspiration(
  SharedPreferences prefs,
  String localeCode,
) async {
  final modeKey = prefs.getString(_kDailyInspirationCacheModeKey);
  final mode = _cacheModeFromString(modeKey);
  if (mode == DailyInspirationCacheMode.perLaunch) return null;

  final key = _cacheKeyForLocale(localeCode);
  final jsonStr = prefs.getString(key);
  if (jsonStr == null || jsonStr.isEmpty) return null;

  try {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>?;
    if (map == null) return null;
    final date = map['date'] as String?;
    if (date != _todayDate()) return null;
    final dtoJson = map['dto'] as Map<String, dynamic>?;
    if (dtoJson == null) return null;
    final dto = DailyInspirationDto.fromJson(dtoJson);
    if (!dto.isValid) return null;
    if (kDebugMode) {
      debugPrint('[DailyInspiration] cache hit: type=${dto.type} id=${dto.id} date=$date locale=$localeCode');
    }
    return dto;
  } catch (_) {
    return null;
  }
}

Future<void> _setCachedDailyInspiration(
  SharedPreferences prefs,
  DailyInspirationDto dto,
  String localeCode,
) async {
  try {
    final map = {
      'date': _todayDate(),
      'dto': {
        'type': dto.type,
        'id': dto.id,
        'arabic': dto.arabic,
        'translation': dto.translation,
        'title': dto.title,
        'source': dto.source,
        'surah': dto.surah,
        'ayah_number': dto.ayahNumber,
      },
    };
    await prefs.setString(_cacheKeyForLocale(localeCode), jsonEncode(map));
  } catch (_) {}
}

/// Fetches daily inspiration with optional local cache.
/// [localeCode] (e.g. from app locale) is used for cache key so each language has its own cache.
/// When locale changes, provider refetches and API returns translation in the new language.
Future<DailyInspirationDto?> getDailyInspiration(Ref ref, {required String localeCode}) async {
  final prefs = ref.read(sharedPreferencesProvider);
  final cached = await _getCachedDailyInspiration(prefs, localeCode);
  if (cached != null) return cached;

  final dto = await fetchDailyInspiration(ref);
  if (dto != null && dto.isValid) {
    final modeKey = prefs.getString(_kDailyInspirationCacheModeKey);
    final mode = _cacheModeFromString(modeKey);
    if (mode == DailyInspirationCacheMode.perDay) {
      await _setCachedDailyInspiration(prefs, dto, localeCode);
    }
  }
  return dto;
}

/// Set cache mode (e.g. from settings). Default is per_day.
Future<void> setDailyInspirationCacheMode(SharedPreferences prefs, DailyInspirationCacheMode mode) async {
  await prefs.setString(_kDailyInspirationCacheModeKey, mode.key);
}
