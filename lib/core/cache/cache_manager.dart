/// Cache manager using Hive for local storage.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Cache box names.
abstract class CacheBoxes {
  static const String appConfig = 'app_config';
  static const String content = 'content';
  static const String user = 'user';
}

/// Cache keys.
abstract class CacheKeys {
  static const String remoteConfig = 'remote_config';
  static const String homeData = 'home_data';
  static const String duasList = 'duas_list';
  static const String hadithList = 'hadith_list';
  static const String versesList = 'verses_list';
  static const String adhkarList = 'adhkar_list';
  static const String categories = 'categories';
  static const String savedItems = 'saved_items';
  static const String userProfile = 'user_profile';
  static const String prayerTimes = 'prayer_times';
  static const String journey = 'journey';
  static const String lessons = 'lessons';
  /// Current/active lesson for home (GET /lessons/today).
  static const String currentLesson = 'current_lesson';
}

/// Cache manager for local storage using Hive.
class CacheManager {
  CacheManager._();

  static bool _initialized = false;

  /// Initialize Hive.
  static Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();
    _initialized = true;

    if (kDebugMode) {
      print('[Cache] Hive initialized');
    }
  }

  /// Get or open a box.
  static Future<Box<String>> _getBox(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<String>(name);
    }
    return Hive.openBox<String>(name);
  }

  /// Store data in cache.
  static Future<void> put({
    required String box,
    required String key,
    required dynamic data,
    Duration? expiry,
  }) async {
    final cacheBox = await _getBox(box);

    final cacheEntry = CacheEntry(
      data: data,
      timestamp: DateTime.now(),
      expiry: expiry,
    );

    await cacheBox.put(key, jsonEncode(cacheEntry.toJson()));

    if (kDebugMode) {
      print('[Cache] Stored $key in $box');
    }
  }

  /// Get data from cache.
  static Future<T?> get<T>({
    required String box,
    required String key,
    T Function(dynamic json)? fromJson,
  }) async {
    final cacheBox = await _getBox(box);
    final raw = cacheBox.get(key);

    if (raw == null) return null;

    try {
      final entry = CacheEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>);

      // Check if expired
      if (entry.isExpired) {
        await cacheBox.delete(key);
        if (kDebugMode) {
          print('[Cache] $key expired, deleted from $box');
        }
        return null;
      }

      if (fromJson != null) {
        return fromJson(entry.data);
      }

      return entry.data as T?;
    } catch (e) {
      if (kDebugMode) {
        print('[Cache] Error reading $key from $box: $e');
      }
      return null;
    }
  }

  /// Check if cache entry exists and is valid.
  static Future<bool> has({
    required String box,
    required String key,
  }) async {
    final cacheBox = await _getBox(box);
    final raw = cacheBox.get(key);

    if (raw == null) return false;

    try {
      final entry = CacheEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      return !entry.isExpired;
    } catch (_) {
      return false;
    }
  }

  /// Removes API-backed cache entries that are not keyed by locale.
  ///
  /// Call when the app language changes so the next fetch uses [Accept-Language]
  /// and does not immediately re-serve stale text from another language.
  static Future<void> clearLocaleSensitiveApiCache() async {
    const contentKeys = <String>[
      CacheKeys.homeData,
      CacheKeys.duasList,
      CacheKeys.hadithList,
      CacheKeys.versesList,
      CacheKeys.adhkarList,
      CacheKeys.categories,
      CacheKeys.savedItems,
      CacheKeys.remoteConfig,
      CacheKeys.prayerTimes,
      CacheKeys.lessons,
    ];
    for (final key in contentKeys) {
      try {
        await delete(box: CacheBoxes.content, key: key);
      } catch (e) {
        if (kDebugMode) {
          print('[Cache] clearLocaleSensitiveApiCache: skip $key — $e');
        }
      }
    }
    try {
      await delete(box: CacheBoxes.user, key: CacheKeys.userProfile);
    } catch (e) {
      if (kDebugMode) {
        print('[Cache] clearLocaleSensitiveApiCache: skip userProfile — $e');
      }
    }
  }

  /// Delete a cache entry.
  static Future<void> delete({
    required String box,
    required String key,
  }) async {
    final cacheBox = await _getBox(box);
    await cacheBox.delete(key);

    if (kDebugMode) {
      print('[Cache] Deleted $key from $box');
    }
  }

  /// Clear all entries in a box.
  static Future<void> clearBox(String box) async {
    final cacheBox = await _getBox(box);
    await cacheBox.clear();

    if (kDebugMode) {
      print('[Cache] Cleared box $box');
    }
  }

  /// Clear all cache.
  static Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    _initialized = false;
    await initialize();

    if (kDebugMode) {
      print('[Cache] Cleared all cache');
    }
  }

  /// Get cache size in bytes (approximate).
  static Future<int> getCacheSize() async {
    int size = 0;

    for (final boxName in [CacheBoxes.appConfig, CacheBoxes.content, CacheBoxes.user]) {
      try {
        final box = await _getBox(boxName);
        for (final key in box.keys) {
          final value = box.get(key);
          if (value != null) {
            size += value.length;
          }
        }
      } catch (_) {
        // Box might not exist
      }
    }

    return size;
  }
}

/// Cache entry with timestamp and optional expiry.
class CacheEntry {
  const CacheEntry({
    required this.data,
    required this.timestamp,
    this.expiry,
  });

  factory CacheEntry.fromJson(Map<String, dynamic> json) {
    return CacheEntry(
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp'] as String),
      expiry: json['expiry'] != null
          ? Duration(milliseconds: json['expiry'] as int)
          : null,
    );
  }

  final dynamic data;
  final DateTime timestamp;
  final Duration? expiry;

  /// Check if entry is expired.
  bool get isExpired {
    if (expiry == null) return false;
    return DateTime.now().isAfter(timestamp.add(expiry!));
  }

  /// Get age of cache entry.
  Duration get age => DateTime.now().difference(timestamp);

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'expiry': expiry?.inMilliseconds,
    };
  }
}

/// Cache durations for different data types.
abstract class CacheDurations {
  /// Remote config - cache for 1 hour.
  static const Duration remoteConfig = Duration(hours: 1);

  /// Home data - cache for 30 minutes.
  static const Duration homeData = Duration(minutes: 30);

  /// Content lists - cache for 24 hours.
  static const Duration contentList = Duration(hours: 24);

  /// Content details - cache for 7 days.
  static const Duration contentDetail = Duration(days: 7);

  /// User profile - cache for 1 hour.
  static const Duration userProfile = Duration(hours: 1);

  /// Prayer times - cache for 24 hours.
  static const Duration prayerTimes = Duration(hours: 24);

  /// Categories - cache for 7 days.
  static const Duration categories = Duration(days: 7);
}
