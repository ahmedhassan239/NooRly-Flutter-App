/// Settings entities.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// User settings entity.
@immutable
class SettingsEntity {
  const SettingsEntity({
    this.language = 'en',
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.prayerNotifications = true,
    this.lessonReminders = true,
    this.dailyVerseNotification = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.fontSize = FontSize.medium,
    this.arabicFontSize = ArabicFontSize.medium,
  });

  /// App language ('en', 'ar').
  final String language;

  /// Theme mode.
  final ThemeMode themeMode;

  /// Whether notifications are enabled.
  final bool notificationsEnabled;

  /// Whether prayer notifications are enabled.
  final bool prayerNotifications;

  /// Whether lesson reminders are enabled.
  final bool lessonReminders;

  /// Whether daily verse notification is enabled.
  final bool dailyVerseNotification;

  /// Whether sound is enabled.
  final bool soundEnabled;

  /// Whether vibration is enabled.
  final bool vibrationEnabled;

  /// Font size for content.
  final FontSize fontSize;

  /// Font size for Arabic text.
  final ArabicFontSize arabicFontSize;

  SettingsEntity copyWith({
    String? language,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? prayerNotifications,
    bool? lessonReminders,
    bool? dailyVerseNotification,
    bool? soundEnabled,
    bool? vibrationEnabled,
    FontSize? fontSize,
    ArabicFontSize? arabicFontSize,
  }) {
    return SettingsEntity(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      prayerNotifications: prayerNotifications ?? this.prayerNotifications,
      lessonReminders: lessonReminders ?? this.lessonReminders,
      dailyVerseNotification: dailyVerseNotification ?? this.dailyVerseNotification,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      fontSize: fontSize ?? this.fontSize,
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
    );
  }
}

/// Font size options.
enum FontSize {
  small,
  medium,
  large,
  extraLarge,
}

/// Arabic font size options.
enum ArabicFontSize {
  small,
  medium,
  large,
  extraLarge,
}

/// Notification settings entity.
@immutable
class NotificationSettingsEntity {
  const NotificationSettingsEntity({
    this.enabled = true,
    this.prayerTimes = true,
    this.lessonReminders = true,
    this.dailyVerse = true,
    this.weeklyProgress = true,
    this.sound = true,
    this.vibration = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  final bool enabled;
  final bool prayerTimes;
  final bool lessonReminders;
  final bool dailyVerse;
  final bool weeklyProgress;
  final bool sound;
  final bool vibration;
  final bool quietHoursEnabled;
  final TimeOfDay? quietHoursStart;
  final TimeOfDay? quietHoursEnd;

  NotificationSettingsEntity copyWith({
    bool? enabled,
    bool? prayerTimes,
    bool? lessonReminders,
    bool? dailyVerse,
    bool? weeklyProgress,
    bool? sound,
    bool? vibration,
    bool? quietHoursEnabled,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
  }) {
    return NotificationSettingsEntity(
      enabled: enabled ?? this.enabled,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      lessonReminders: lessonReminders ?? this.lessonReminders,
      dailyVerse: dailyVerse ?? this.dailyVerse,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }
}
