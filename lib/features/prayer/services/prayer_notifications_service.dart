/// Prayer Notifications Service
///
/// Full implementation using flutter_local_notifications + the PrayerReminderScheduler.
/// On web: all methods are no-ops.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/notifications/notification_service.dart';
import 'package:flutter_app/core/notifications/schedulers/prayer_reminder_scheduler.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import 'package:flutter_app/features/prayer/data/prayer_models.dart';

class PrayerNotificationsService {
  PrayerNotificationsService._();

  static final PrayerNotificationsService _instance =
      PrayerNotificationsService._();
  static PrayerNotificationsService get instance => _instance;

  bool _initialized = false;

  /// Initialize notification permissions.
  /// Returns true if permissions are granted (or on web, always returns false).
  Future<bool> initialize() async {
    if (kIsWeb) return false;

    try {
      await NotificationService.instance.initialize();
      _initialized = true;
      return true;
    } catch (e) {
      debugPrint('[PrayerNotificationsService] Failed to initialize: $e');
      return false;
    }
  }

  /// Request notification permissions from the OS.
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    return NotificationService.instance.requestPermission();
  }

  /// Schedule prayer reminders for the given list of prayers.
  ///
  /// [prayerList] is the list of today's prayers from todayPrayerListProvider.
  /// [prefs] is the user's current notification preferences.
  Future<void> schedulePrayerReminders({
    required List<PrayerCardData> prayerList,
    NotificationPreferencesEntity? prefs,
  }) async {
    if (kIsWeb) return;

    if (!_initialized) {
      final ok = await initialize();
      if (!ok) {
        debugPrint('[PrayerNotificationsService] Not initialized; cannot schedule');
        return;
      }
    }

    final effectivePrefs = prefs ?? const NotificationPreferencesEntity();

    if (!effectivePrefs.prayerEnabled) {
      await cancelAllPrayerReminders();
      return;
    }

    try {
      // Convert PrayerCardData to PrayerScheduleInput
      final inputs = prayerList
          .where((p) => p.time != null)
          .map((p) => PrayerScheduleInput(
                name: _normalizePrayerName(p.name),
                time: _prayerTime(p),
              ))
          .where((i) => i.name.isNotEmpty)
          .toList();

      await PrayerReminderScheduler.instance.schedule(
        prayerInputs: inputs,
        prefs: effectivePrefs,
      );

      debugPrint('[PrayerNotificationsService] Scheduled ${inputs.length} prayer reminders');
    } catch (e) {
      debugPrint('[PrayerNotificationsService] Failed to schedule prayer reminders: $e');
    }
  }

  /// Cancel all prayer reminders.
  Future<void> cancelAllPrayerReminders() async {
    if (kIsWeb) return;
    try {
      await NotificationService.instance.cancelAll();
      debugPrint('[PrayerNotificationsService] All prayer reminders cancelled');
    } catch (e) {
      debugPrint('[PrayerNotificationsService] Failed to cancel reminders: $e');
    }
  }

  /// Check if notifications are enabled at the system level.
  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return false;
    return NotificationService.instance.areNotificationsEnabled();
  }

  // -----------------------------------------------------------------------
  // Helpers

  String _normalizePrayerName(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.contains('fajr') || lower.contains('فجر')) return 'fajr';
    if (lower.contains('dhuhr') || lower.contains('ظهر')) return 'dhuhr';
    if (lower.contains('asr') || lower.contains('عصر')) return 'asr';
    if (lower.contains('maghrib') || lower.contains('مغرب')) return 'maghrib';
    if (lower.contains('isha') || lower.contains('عشاء')) return 'isha';
    return '';
  }

  DateTime _prayerTime(PrayerCardData prayer) {
    // Use timeAsDateTime if available
    if (prayer.timeAsDateTime != null) return prayer.timeAsDateTime!;

    // Parse from time string e.g. "05:12 AM" or "17:30"
    final now = DateTime.now();
    try {
      final parts = prayer.time.split(RegExp(r'[: ]'));
      if (parts.length < 2) return now;
      var hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      if (parts.length >= 3) {
        final ampm = parts[2].toUpperCase();
        if (ampm == 'PM' && hour < 12) hour += 12;
        if (ampm == 'AM' && hour == 12) hour = 0;
      }
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (_) {
      return now;
    }
  }
}
