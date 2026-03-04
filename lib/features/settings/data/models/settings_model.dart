/// Settings models for API serialization.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/features/settings/domain/entities/settings_entity.dart';

/// Settings model.
class SettingsModel extends SettingsEntity {
  const SettingsModel({
    super.language,
    super.themeMode,
    super.notificationsEnabled,
    super.prayerNotifications,
    super.lessonReminders,
    super.dailyVerseNotification,
    super.soundEnabled,
    super.vibrationEnabled,
    super.fontSize,
    super.arabicFontSize,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      language: json['language'] as String? ?? 'en',
      themeMode: _parseThemeMode(json['theme_mode'] as String?),
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      prayerNotifications: json['prayer_notifications'] as bool? ?? true,
      lessonReminders: json['lesson_reminders'] as bool? ?? true,
      dailyVerseNotification: json['daily_verse_notification'] as bool? ?? true,
      soundEnabled: json['sound_enabled'] as bool? ?? true,
      vibrationEnabled: json['vibration_enabled'] as bool? ?? true,
      fontSize: _parseFontSize(json['font_size'] as String?),
      arabicFontSize: _parseArabicFontSize(json['arabic_font_size'] as String?),
    );
  }

  static ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static FontSize _parseFontSize(String? value) {
    switch (value) {
      case 'small':
        return FontSize.small;
      case 'large':
        return FontSize.large;
      case 'extra_large':
        return FontSize.extraLarge;
      default:
        return FontSize.medium;
    }
  }

  static ArabicFontSize _parseArabicFontSize(String? value) {
    switch (value) {
      case 'small':
        return ArabicFontSize.small;
      case 'large':
        return ArabicFontSize.large;
      case 'extra_large':
        return ArabicFontSize.extraLarge;
      default:
        return ArabicFontSize.medium;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme_mode': themeMode.name,
      'notifications_enabled': notificationsEnabled,
      'prayer_notifications': prayerNotifications,
      'lesson_reminders': lessonReminders,
      'daily_verse_notification': dailyVerseNotification,
      'sound_enabled': soundEnabled,
      'vibration_enabled': vibrationEnabled,
      'font_size': fontSize.name,
      'arabic_font_size': arabicFontSize.name,
    };
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
      language: language,
      themeMode: themeMode,
      notificationsEnabled: notificationsEnabled,
      prayerNotifications: prayerNotifications,
      lessonReminders: lessonReminders,
      dailyVerseNotification: dailyVerseNotification,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      fontSize: fontSize,
      arabicFontSize: arabicFontSize,
    );
  }
}

/// Notification settings model.
class NotificationSettingsModel extends NotificationSettingsEntity {
  const NotificationSettingsModel({
    super.enabled,
    super.prayerTimes,
    super.lessonReminders,
    super.dailyVerse,
    super.weeklyProgress,
    super.sound,
    super.vibration,
    super.quietHoursEnabled,
    super.quietHoursStart,
    super.quietHoursEnd,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      enabled: json['enabled'] as bool? ?? true,
      prayerTimes: json['prayer_times'] as bool? ?? true,
      lessonReminders: json['lesson_reminders'] as bool? ?? true,
      dailyVerse: json['daily_verse'] as bool? ?? true,
      weeklyProgress: json['weekly_progress'] as bool? ?? true,
      sound: json['sound'] as bool? ?? true,
      vibration: json['vibration'] as bool? ?? true,
      quietHoursEnabled: json['quiet_hours_enabled'] as bool? ?? false,
      quietHoursStart: _parseTimeOfDay(json['quiet_hours_start'] as String?),
      quietHoursEnd: _parseTimeOfDay(json['quiet_hours_end'] as String?),
    );
  }

  static TimeOfDay? _parseTimeOfDay(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'prayer_times': prayerTimes,
      'lesson_reminders': lessonReminders,
      'daily_verse': dailyVerse,
      'weekly_progress': weeklyProgress,
      'sound': sound,
      'vibration': vibration,
      'quiet_hours_enabled': quietHoursEnabled,
      'quiet_hours_start': quietHoursStart != null
          ? '${quietHoursStart!.hour.toString().padLeft(2, '0')}:${quietHoursStart!.minute.toString().padLeft(2, '0')}'
          : null,
      'quiet_hours_end': quietHoursEnd != null
          ? '${quietHoursEnd!.hour.toString().padLeft(2, '0')}:${quietHoursEnd!.minute.toString().padLeft(2, '0')}'
          : null,
    };
  }
}
