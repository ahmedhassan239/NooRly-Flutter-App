/// Prayer repository implementation.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/prayer/data/models/prayer_model.dart';
import 'package:flutter_app/features/prayer/domain/entities/prayer_entity.dart';
import 'package:flutter_app/features/prayer/domain/repositories/prayer_repository.dart';

/// Implementation of [PrayerRepository].
class PrayerRepositoryImpl implements PrayerRepository {
  PrayerRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<PrayerTimesEntity> getPrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        PrayerEndpoints.times,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          if (date != null) 'date': date.toIso8601String().split('T').first,
        },
      );

      if (!response.status || response.data == null) {
        final cached = await getCachedPrayerTimes();
        if (cached != null) return cached;
        throw UnknownException(message: response.message);
      }

      final prayerTimes = PrayerTimesModel.fromJson(response.data!);

      // Cache the prayer times
      await CacheManager.put(
        box: CacheBoxes.content,
        key: CacheKeys.prayerTimes,
        data: prayerTimes.toJson(),
        expiry: CacheDurations.prayerTimes,
      );

      return prayerTimes;
    } on ApiException {
      final cached = await getCachedPrayerTimes();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('[Prayer] Error fetching prayer times: $e');
      }
      final cached = await getCachedPrayerTimes();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<PrayerNotificationSettings> getNotificationSettings() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        PrayerEndpoints.settings,
      );

      if (!response.status || response.data == null) {
        return const PrayerNotificationSettings();
      }

      return PrayerNotificationSettingsModel.fromJson(response.data!);
    } catch (e) {
      if (kDebugMode) {
        print('[Prayer] Error fetching notification settings: $e');
      }
      return const PrayerNotificationSettings();
    }
  }

  @override
  Future<void> updateNotificationSettings(
    PrayerNotificationSettings settings,
  ) async {
    final model = PrayerNotificationSettingsModel(
      fajrEnabled: settings.fajrEnabled,
      sunriseEnabled: settings.sunriseEnabled,
      dhuhrEnabled: settings.dhuhrEnabled,
      asrEnabled: settings.asrEnabled,
      maghribEnabled: settings.maghribEnabled,
      ishaEnabled: settings.ishaEnabled,
      minutesBefore: settings.minutesBefore,
      soundEnabled: settings.soundEnabled,
      vibrationEnabled: settings.vibrationEnabled,
    );

    final response = await _apiClient.put<void>(
      PrayerEndpoints.settings,
      data: model.toJson(),
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }
  }

  @override
  Future<PrayerTimesEntity?> getCachedPrayerTimes() async {
    try {
      final cached = await CacheManager.get<Map<String, dynamic>>(
        box: CacheBoxes.content,
        key: CacheKeys.prayerTimes,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (cached == null) return null;

      return PrayerTimesModel.fromJson(cached);
    } catch (e) {
      if (kDebugMode) {
        print('[Prayer] Error reading cached prayer times: $e');
      }
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await CacheManager.delete(
      box: CacheBoxes.content,
      key: CacheKeys.prayerTimes,
    );
  }
}
