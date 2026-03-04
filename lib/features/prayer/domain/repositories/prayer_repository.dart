/// Prayer repository interface.
library;

import 'package:flutter_app/features/prayer/domain/entities/prayer_entity.dart';

/// Prayer times repository interface.
abstract class PrayerRepository {
  /// Get prayer times for a location and date.
  Future<PrayerTimesEntity> getPrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
  });

  /// Get prayer notification settings.
  Future<PrayerNotificationSettings> getNotificationSettings();

  /// Update prayer notification settings.
  Future<void> updateNotificationSettings(PrayerNotificationSettings settings);

  /// Get cached prayer times.
  Future<PrayerTimesEntity?> getCachedPrayerTimes();

  /// Clear cache.
  Future<void> clearCache();
}
