/// Notification preferences entity — the full user preference model.
library;

import 'package:flutter/material.dart';

enum PrayerTimingMode { before, at, after }

enum NotificationLanguageMode { appLocale, arabic, english, both }

class NotificationPreferencesEntity {
  const NotificationPreferencesEntity({
    this.prayerEnabled = true,
    this.fajrEnabled = true,
    this.dhuhrEnabled = true,
    this.asrEnabled = true,
    this.maghribEnabled = true,
    this.ishaEnabled = true,
    this.prayerTimingMode = PrayerTimingMode.at,
    this.prayerOffsetMinutes = 0,
    this.lessonEnabled = true,
    this.lessonTime,
    this.lessonEveningReminderEnabled = true,
    this.streakReminderEnabled = true,
    this.morningAdhkarEnabled = true,
    this.eveningAdhkarEnabled = true,
    this.sleepAdhkarEnabled = true,
    this.sleepAdhkarTime,
    this.randomDhikrEnabled = false,
    this.randomDhikrFrequency = 2,
    this.milestoneEnabled = true,
    this.specialOccasionsEnabled = true,
    this.supportRemindersEnabled = true,
    this.quietHoursEnabled = true,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.notificationSound,
    this.vibrationEnabled = true,
    this.languageMode = NotificationLanguageMode.appLocale,
  });

  final bool prayerEnabled;
  final bool fajrEnabled;
  final bool dhuhrEnabled;
  final bool asrEnabled;
  final bool maghribEnabled;
  final bool ishaEnabled;
  final PrayerTimingMode prayerTimingMode;
  final int prayerOffsetMinutes;

  final bool lessonEnabled;
  final TimeOfDay? lessonTime;
  final bool lessonEveningReminderEnabled;
  final bool streakReminderEnabled;

  final bool morningAdhkarEnabled;
  final bool eveningAdhkarEnabled;
  final bool sleepAdhkarEnabled;
  final TimeOfDay? sleepAdhkarTime;
  final bool randomDhikrEnabled;
  final int randomDhikrFrequency;

  final bool milestoneEnabled;
  final bool specialOccasionsEnabled;
  final bool supportRemindersEnabled;

  final bool quietHoursEnabled;
  final TimeOfDay? quietHoursStart;
  final TimeOfDay? quietHoursEnd;

  final String? notificationSound;
  final bool vibrationEnabled;
  final NotificationLanguageMode languageMode;

  /// Default lesson time: 9:00 AM
  TimeOfDay get effectiveLessonTime => lessonTime ?? const TimeOfDay(hour: 9, minute: 0);

  /// Default sleep adhkar time: 10:00 PM
  TimeOfDay get effectiveSleepAdhkarTime => sleepAdhkarTime ?? const TimeOfDay(hour: 22, minute: 0);

  /// Default quiet start: 11:00 PM
  TimeOfDay get effectiveQuietStart => quietHoursStart ?? const TimeOfDay(hour: 23, minute: 0);

  /// Default quiet end: 5:00 AM
  TimeOfDay get effectiveQuietEnd => quietHoursEnd ?? const TimeOfDay(hour: 5, minute: 0);

  static TimeOfDay? _parseTime(String? hhmm) {
    if (hhmm == null || hhmm.isEmpty) return null;
    final parts = hhmm.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(hour: int.tryParse(parts[0]) ?? 0, minute: int.tryParse(parts[1]) ?? 0);
  }

  static String? _formatTime(TimeOfDay? t) {
    if (t == null) return null;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  factory NotificationPreferencesEntity.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesEntity(
      prayerEnabled: json['prayer_enabled'] as bool? ?? true,
      fajrEnabled: json['fajr_enabled'] as bool? ?? true,
      dhuhrEnabled: json['dhuhr_enabled'] as bool? ?? true,
      asrEnabled: json['asr_enabled'] as bool? ?? true,
      maghribEnabled: json['maghrib_enabled'] as bool? ?? true,
      ishaEnabled: json['isha_enabled'] as bool? ?? true,
      prayerTimingMode: _parsePrayerMode(json['prayer_timing_mode'] as String?),
      prayerOffsetMinutes: (json['prayer_offset_minutes'] as num?)?.toInt() ?? 0,
      lessonEnabled: json['lesson_enabled'] as bool? ?? true,
      lessonTime: _parseTime(json['lesson_time'] as String?),
      lessonEveningReminderEnabled: json['lesson_evening_reminder_enabled'] as bool? ?? true,
      streakReminderEnabled: json['streak_reminder_enabled'] as bool? ?? true,
      morningAdhkarEnabled: json['morning_adhkar_enabled'] as bool? ?? true,
      eveningAdhkarEnabled: json['evening_adhkar_enabled'] as bool? ?? true,
      sleepAdhkarEnabled: json['sleep_adhkar_enabled'] as bool? ?? true,
      sleepAdhkarTime: _parseTime(json['sleep_adhkar_time'] as String?),
      randomDhikrEnabled: json['random_dhikr_enabled'] as bool? ?? false,
      randomDhikrFrequency: (json['random_dhikr_frequency'] as num?)?.toInt() ?? 2,
      milestoneEnabled: json['milestone_enabled'] as bool? ?? true,
      specialOccasionsEnabled: json['special_occasions_enabled'] as bool? ?? true,
      supportRemindersEnabled: json['support_reminders_enabled'] as bool? ?? true,
      quietHoursEnabled: json['quiet_hours_enabled'] as bool? ?? true,
      quietHoursStart: _parseTime(json['quiet_hours_start'] as String?),
      quietHoursEnd: _parseTime(json['quiet_hours_end'] as String?),
      notificationSound: json['notification_sound'] as String?,
      vibrationEnabled: json['vibration_enabled'] as bool? ?? true,
      languageMode: _parseLanguageMode(json['language_mode'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
    'prayer_enabled': prayerEnabled,
    'fajr_enabled': fajrEnabled,
    'dhuhr_enabled': dhuhrEnabled,
    'asr_enabled': asrEnabled,
    'maghrib_enabled': maghribEnabled,
    'isha_enabled': ishaEnabled,
    'prayer_timing_mode': prayerTimingMode.name,
    'prayer_offset_minutes': prayerOffsetMinutes,
    'lesson_enabled': lessonEnabled,
    'lesson_time': _formatTime(lessonTime),
    'lesson_evening_reminder_enabled': lessonEveningReminderEnabled,
    'streak_reminder_enabled': streakReminderEnabled,
    'morning_adhkar_enabled': morningAdhkarEnabled,
    'evening_adhkar_enabled': eveningAdhkarEnabled,
    'sleep_adhkar_enabled': sleepAdhkarEnabled,
    'sleep_adhkar_time': _formatTime(sleepAdhkarTime),
    'random_dhikr_enabled': randomDhikrEnabled,
    'random_dhikr_frequency': randomDhikrFrequency,
    'milestone_enabled': milestoneEnabled,
    'special_occasions_enabled': specialOccasionsEnabled,
    'support_reminders_enabled': supportRemindersEnabled,
    'quiet_hours_enabled': quietHoursEnabled,
    'quiet_hours_start': _formatTime(quietHoursStart),
    'quiet_hours_end': _formatTime(quietHoursEnd),
    'notification_sound': notificationSound,
    'vibration_enabled': vibrationEnabled,
    'language_mode': languageMode.name,
  };

  static PrayerTimingMode _parsePrayerMode(String? s) => switch (s) {
    'before' => PrayerTimingMode.before,
    'after'  => PrayerTimingMode.after,
    _        => PrayerTimingMode.at,
  };

  static NotificationLanguageMode _parseLanguageMode(String? s) => switch (s) {
    'arabic'  => NotificationLanguageMode.arabic,
    'english' => NotificationLanguageMode.english,
    'both'    => NotificationLanguageMode.both,
    _         => NotificationLanguageMode.appLocale,
  };

  NotificationPreferencesEntity copyWith({
    bool? prayerEnabled,
    bool? fajrEnabled,
    bool? dhuhrEnabled,
    bool? asrEnabled,
    bool? maghribEnabled,
    bool? ishaEnabled,
    PrayerTimingMode? prayerTimingMode,
    int? prayerOffsetMinutes,
    bool? lessonEnabled,
    TimeOfDay? lessonTime,
    bool? lessonEveningReminderEnabled,
    bool? streakReminderEnabled,
    bool? morningAdhkarEnabled,
    bool? eveningAdhkarEnabled,
    bool? sleepAdhkarEnabled,
    TimeOfDay? sleepAdhkarTime,
    bool? randomDhikrEnabled,
    int? randomDhikrFrequency,
    bool? milestoneEnabled,
    bool? specialOccasionsEnabled,
    bool? supportRemindersEnabled,
    bool? quietHoursEnabled,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
    String? notificationSound,
    bool? vibrationEnabled,
    NotificationLanguageMode? languageMode,
  }) => NotificationPreferencesEntity(
    prayerEnabled: prayerEnabled ?? this.prayerEnabled,
    fajrEnabled: fajrEnabled ?? this.fajrEnabled,
    dhuhrEnabled: dhuhrEnabled ?? this.dhuhrEnabled,
    asrEnabled: asrEnabled ?? this.asrEnabled,
    maghribEnabled: maghribEnabled ?? this.maghribEnabled,
    ishaEnabled: ishaEnabled ?? this.ishaEnabled,
    prayerTimingMode: prayerTimingMode ?? this.prayerTimingMode,
    prayerOffsetMinutes: prayerOffsetMinutes ?? this.prayerOffsetMinutes,
    lessonEnabled: lessonEnabled ?? this.lessonEnabled,
    lessonTime: lessonTime ?? this.lessonTime,
    lessonEveningReminderEnabled: lessonEveningReminderEnabled ?? this.lessonEveningReminderEnabled,
    streakReminderEnabled: streakReminderEnabled ?? this.streakReminderEnabled,
    morningAdhkarEnabled: morningAdhkarEnabled ?? this.morningAdhkarEnabled,
    eveningAdhkarEnabled: eveningAdhkarEnabled ?? this.eveningAdhkarEnabled,
    sleepAdhkarEnabled: sleepAdhkarEnabled ?? this.sleepAdhkarEnabled,
    sleepAdhkarTime: sleepAdhkarTime ?? this.sleepAdhkarTime,
    randomDhikrEnabled: randomDhikrEnabled ?? this.randomDhikrEnabled,
    randomDhikrFrequency: randomDhikrFrequency ?? this.randomDhikrFrequency,
    milestoneEnabled: milestoneEnabled ?? this.milestoneEnabled,
    specialOccasionsEnabled: specialOccasionsEnabled ?? this.specialOccasionsEnabled,
    supportRemindersEnabled: supportRemindersEnabled ?? this.supportRemindersEnabled,
    quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
    quietHoursStart: quietHoursStart ?? this.quietHoursStart,
    quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    notificationSound: notificationSound ?? this.notificationSound,
    vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    languageMode: languageMode ?? this.languageMode,
  );
}
