/// Prayer times entities.
library;

import 'package:flutter/foundation.dart';

/// Prayer times for a day.
@immutable
class PrayerTimesEntity {
  const PrayerTimesEntity({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    this.location,
    this.timezone,
    this.hijriDate,
  });

  /// Date for these prayer times.
  final DateTime date;

  /// Fajr prayer time.
  final DateTime fajr;

  /// Sunrise time.
  final DateTime sunrise;

  /// Dhuhr prayer time.
  final DateTime dhuhr;

  /// Asr prayer time.
  final DateTime asr;

  /// Maghrib prayer time.
  final DateTime maghrib;

  /// Isha prayer time.
  final DateTime isha;

  /// Location name.
  final String? location;

  /// Timezone.
  final String? timezone;

  /// Hijri date string.
  final String? hijriDate;

  /// Get all prayers as a list.
  List<PrayerTimeEntry> get prayers => [
        PrayerTimeEntry(name: 'Fajr', nameAr: 'الفجر', time: fajr),
        PrayerTimeEntry(name: 'Sunrise', nameAr: 'الشروق', time: sunrise),
        PrayerTimeEntry(name: 'Dhuhr', nameAr: 'الظهر', time: dhuhr),
        PrayerTimeEntry(name: 'Asr', nameAr: 'العصر', time: asr),
        PrayerTimeEntry(name: 'Maghrib', nameAr: 'المغرب', time: maghrib),
        PrayerTimeEntry(name: 'Isha', nameAr: 'العشاء', time: isha),
      ];

  /// Get next prayer.
  PrayerTimeEntry? getNextPrayer() {
    final now = DateTime.now();
    for (final prayer in prayers) {
      if (prayer.time.isAfter(now)) {
        return prayer;
      }
    }
    return null; // All prayers passed for today
  }

  /// Get current prayer (most recent that has passed).
  PrayerTimeEntry? getCurrentPrayer() {
    final now = DateTime.now();
    PrayerTimeEntry? current;
    for (final prayer in prayers) {
      if (prayer.time.isBefore(now)) {
        current = prayer;
      } else {
        break;
      }
    }
    return current;
  }

  /// Get time until next prayer.
  Duration? getTimeUntilNextPrayer() {
    final next = getNextPrayer();
    if (next == null) return null;
    return next.time.difference(DateTime.now());
  }
}

/// Single prayer time entry.
@immutable
class PrayerTimeEntry {
  const PrayerTimeEntry({
    required this.name,
    required this.nameAr,
    required this.time,
    this.isNotificationEnabled = true,
  });

  /// Prayer name (English).
  final String name;

  /// Prayer name (Arabic).
  final String nameAr;

  /// Prayer time.
  final DateTime time;

  /// Whether notification is enabled for this prayer.
  final bool isNotificationEnabled;

  /// Get localized name.
  String getName(String locale) {
    if (locale == 'ar') return nameAr;
    return name;
  }

  /// Get formatted time string.
  String get formattedTime {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Check if this prayer has passed.
  bool get hasPassed => DateTime.now().isAfter(time);
}

/// Prayer notification settings.
@immutable
class PrayerNotificationSettings {
  const PrayerNotificationSettings({
    this.fajrEnabled = true,
    this.sunriseEnabled = false,
    this.dhuhrEnabled = true,
    this.asrEnabled = true,
    this.maghribEnabled = true,
    this.ishaEnabled = true,
    this.minutesBefore = 0,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  final bool fajrEnabled;
  final bool sunriseEnabled;
  final bool dhuhrEnabled;
  final bool asrEnabled;
  final bool maghribEnabled;
  final bool ishaEnabled;
  final int minutesBefore;
  final bool soundEnabled;
  final bool vibrationEnabled;

  /// Check if notification is enabled for a prayer.
  bool isEnabledFor(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return fajrEnabled;
      case 'sunrise':
        return sunriseEnabled;
      case 'dhuhr':
        return dhuhrEnabled;
      case 'asr':
        return asrEnabled;
      case 'maghrib':
        return maghribEnabled;
      case 'isha':
        return ishaEnabled;
      default:
        return false;
    }
  }

  PrayerNotificationSettings copyWith({
    bool? fajrEnabled,
    bool? sunriseEnabled,
    bool? dhuhrEnabled,
    bool? asrEnabled,
    bool? maghribEnabled,
    bool? ishaEnabled,
    int? minutesBefore,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return PrayerNotificationSettings(
      fajrEnabled: fajrEnabled ?? this.fajrEnabled,
      sunriseEnabled: sunriseEnabled ?? this.sunriseEnabled,
      dhuhrEnabled: dhuhrEnabled ?? this.dhuhrEnabled,
      asrEnabled: asrEnabled ?? this.asrEnabled,
      maghribEnabled: maghribEnabled ?? this.maghribEnabled,
      ishaEnabled: ishaEnabled ?? this.ishaEnabled,
      minutesBefore: minutesBefore ?? this.minutesBefore,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}
