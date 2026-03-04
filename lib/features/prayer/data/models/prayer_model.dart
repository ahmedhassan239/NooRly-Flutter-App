/// Prayer times models for API serialization.
library;

import 'package:flutter_app/features/prayer/domain/entities/prayer_entity.dart';

/// Prayer times model.
class PrayerTimesModel extends PrayerTimesEntity {
  const PrayerTimesModel({
    required super.date,
    required super.fajr,
    required super.sunrise,
    required super.dhuhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
    super.location,
    super.timezone,
    super.hijriDate,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    final date = json['date'] != null
        ? DateTime.parse(json['date'] as String)
        : DateTime.now();

    return PrayerTimesModel(
      date: date,
      fajr: _parseTime(json['fajr'] ?? json['Fajr'], date),
      sunrise: _parseTime(json['sunrise'] ?? json['Sunrise'], date),
      dhuhr: _parseTime(json['dhuhr'] ?? json['Dhuhr'], date),
      asr: _parseTime(json['asr'] ?? json['Asr'], date),
      maghrib: _parseTime(json['maghrib'] ?? json['Maghrib'], date),
      isha: _parseTime(json['isha'] ?? json['Isha'], date),
      location: json['location'] as String?,
      timezone: json['timezone'] as String?,
      hijriDate: json['hijri_date'] as String? ?? json['hijri'] as String?,
    );
  }

  /// Parse time string to DateTime.
  static DateTime _parseTime(dynamic timeValue, DateTime date) {
    if (timeValue == null) return date;

    if (timeValue is String) {
      // Handle "HH:mm" format
      if (timeValue.contains(':')) {
        final parts = timeValue.split(':');
        if (parts.length >= 2) {
          final hour = int.tryParse(parts[0]) ?? 0;
          final minute = int.tryParse(parts[1].replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
          return DateTime(date.year, date.month, date.day, hour, minute);
        }
      }
      // Handle ISO format
      return DateTime.tryParse(timeValue) ?? date;
    }

    return date;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'fajr': _formatTime(fajr),
      'sunrise': _formatTime(sunrise),
      'dhuhr': _formatTime(dhuhr),
      'asr': _formatTime(asr),
      'maghrib': _formatTime(maghrib),
      'isha': _formatTime(isha),
      'location': location,
      'timezone': timezone,
      'hijri_date': hijriDate,
    };
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// Prayer notification settings model.
class PrayerNotificationSettingsModel extends PrayerNotificationSettings {
  const PrayerNotificationSettingsModel({
    super.fajrEnabled,
    super.sunriseEnabled,
    super.dhuhrEnabled,
    super.asrEnabled,
    super.maghribEnabled,
    super.ishaEnabled,
    super.minutesBefore,
    super.soundEnabled,
    super.vibrationEnabled,
  });

  factory PrayerNotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return PrayerNotificationSettingsModel(
      fajrEnabled: json['fajr_enabled'] as bool? ?? true,
      sunriseEnabled: json['sunrise_enabled'] as bool? ?? false,
      dhuhrEnabled: json['dhuhr_enabled'] as bool? ?? true,
      asrEnabled: json['asr_enabled'] as bool? ?? true,
      maghribEnabled: json['maghrib_enabled'] as bool? ?? true,
      ishaEnabled: json['isha_enabled'] as bool? ?? true,
      minutesBefore: json['minutes_before'] as int? ?? 0,
      soundEnabled: json['sound_enabled'] as bool? ?? true,
      vibrationEnabled: json['vibration_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fajr_enabled': fajrEnabled,
      'sunrise_enabled': sunriseEnabled,
      'dhuhr_enabled': dhuhrEnabled,
      'asr_enabled': asrEnabled,
      'maghrib_enabled': maghribEnabled,
      'isha_enabled': ishaEnabled,
      'minutes_before': minutesBefore,
      'sound_enabled': soundEnabled,
      'vibration_enabled': vibrationEnabled,
    };
  }
}
