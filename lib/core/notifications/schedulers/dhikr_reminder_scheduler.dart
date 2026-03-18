/// Dhikr / adhkar reminder scheduler.
///
/// Schedules:
///   - Morning adhkar (after Fajr + 30 min, default 6 AM if no prayer time)
///   - Evening adhkar (after Asr + 30 min, default 4 PM)
///   - Sleep adhkar (user-configurable, default 10 PM)
///   - Random dhikr (up to N per day at random hours within allowed window)
library;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import '../local_notification_scheduler.dart';
import '../notification_content_localizer.dart';
import '../notification_id_registry.dart';
import '../notification_payload_parser.dart';

class DhikrReminderScheduler {
  DhikrReminderScheduler._();
  static final DhikrReminderScheduler instance = DhikrReminderScheduler._();

  Future<void> schedule({
    required NotificationPreferencesEntity prefs,
    DateTime? fajrTime,
    DateTime? asrTime,
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    if (kIsWeb) return;

    if (kDebugMode) debugPrint('[DhikrScheduler] ── schedule() called ──');

    // Morning adhkar
    if (prefs.morningAdhkarEnabled) {
      final morningHour = fajrTime != null
          ? fajrTime.add(const Duration(minutes: 30)).hour
          : 6;
      if (kDebugMode) debugPrint('[DhikrScheduler] ✓ morning adhkar → hour=$morningHour (${fajrTime != null ? "fajr+30min" : "default 6 AM"})');
      await _scheduleMorningAdhkar(prefs: prefs, hour: morningHour, scheduleMode: scheduleMode, localeCode: localeCode);
    } else {
      await LocalNotificationScheduler.instance.cancel(NotificationIds.morningAdhkar);
      if (kDebugMode) debugPrint('[DhikrScheduler] SKIP morning adhkar — disabled');
    }

    // Evening adhkar
    if (prefs.eveningAdhkarEnabled) {
      final eveningHour = asrTime != null
          ? asrTime.add(const Duration(minutes: 30)).hour
          : 16;
      if (kDebugMode) debugPrint('[DhikrScheduler] ✓ evening adhkar → hour=$eveningHour (${asrTime != null ? "asr+30min" : "default 4 PM"})');
      await _scheduleEveningAdhkar(prefs: prefs, hour: eveningHour, scheduleMode: scheduleMode, localeCode: localeCode);
    } else {
      await LocalNotificationScheduler.instance.cancel(NotificationIds.eveningAdhkar);
      if (kDebugMode) debugPrint('[DhikrScheduler] SKIP evening adhkar — disabled');
    }

    // Sleep adhkar
    if (prefs.sleepAdhkarEnabled) {
      final t = prefs.effectiveSleepAdhkarTime;
      if (kDebugMode) debugPrint('[DhikrScheduler] ✓ sleep adhkar → ${t.hour}:${t.minute.toString().padLeft(2, "0")}');
      await _scheduleSleepAdhkar(prefs: prefs, scheduleMode: scheduleMode, localeCode: localeCode);
    } else {
      await LocalNotificationScheduler.instance.cancel(NotificationIds.sleepAdhkar);
      if (kDebugMode) debugPrint('[DhikrScheduler] SKIP sleep adhkar — disabled');
    }

    // Random dhikr
    final dhikrSlotIds = List.generate(10, (i) => NotificationIds.randomDhikrSlot(i));
    if (prefs.randomDhikrEnabled) {
      if (kDebugMode) debugPrint('[DhikrScheduler] ✓ random dhikr → frequency=${prefs.randomDhikrFrequency}');
      await _scheduleRandomDhikr(prefs: prefs, scheduleMode: scheduleMode, localeCode: localeCode);
    } else {
      await LocalNotificationScheduler.instance.cancelIds(dhikrSlotIds);
      if (kDebugMode) debugPrint('[DhikrScheduler] SKIP random dhikr — disabled');
    }

    if (kDebugMode) debugPrint('[DhikrScheduler] ── schedule() done ──');
  }

  Future<void> _scheduleMorningAdhkar({
    required NotificationPreferencesEntity prefs,
    required int hour,
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    final localizer = NotificationContentLocalizer(localeCode == 'ar' ? 'ar' : 'en');
    await LocalNotificationScheduler.instance.scheduleDailyAt(
      id: NotificationIds.morningAdhkar,
      title: localizer.morningAdhkarTitle,
      body: localizer.morningAdhkarBody,
      hour: hour,
      minute: 0,
      channelId: LocalNotificationScheduler.channelReminders,
      payload: NotificationPayload.encode(
        type: 'dhikr',
        subType: 'morning_adhkar',
        route: '/adhkar',
      ),
      scheduleMode: scheduleMode,
    );
  }

  Future<void> _scheduleEveningAdhkar({
    required NotificationPreferencesEntity prefs,
    required int hour,
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    final localizer = NotificationContentLocalizer(localeCode == 'ar' ? 'ar' : 'en');
    await LocalNotificationScheduler.instance.scheduleDailyAt(
      id: NotificationIds.eveningAdhkar,
      title: localizer.eveningAdhkarTitle,
      body: localizer.eveningAdhkarBody,
      hour: hour,
      minute: 0,
      channelId: LocalNotificationScheduler.channelReminders,
      payload: NotificationPayload.encode(
        type: 'dhikr',
        subType: 'evening_adhkar',
        route: '/adhkar',
      ),
      scheduleMode: scheduleMode,
    );
  }

  Future<void> _scheduleSleepAdhkar({
    required NotificationPreferencesEntity prefs,
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    final t = prefs.effectiveSleepAdhkarTime;
    final localizer = NotificationContentLocalizer(localeCode == 'ar' ? 'ar' : 'en');
    await LocalNotificationScheduler.instance.scheduleDailyAt(
      id: NotificationIds.sleepAdhkar,
      title: localizer.sleepAdhkarTitle,
      body: localizer.sleepAdhkarBody,
      hour: t.hour,
      minute: t.minute,
      channelId: LocalNotificationScheduler.channelLow,
      payload: NotificationPayload.encode(
        type: 'dhikr',
        subType: 'sleep_adhkar',
        route: '/adhkar',
      ),
      scheduleMode: scheduleMode,
    );
  }

  Future<void> _scheduleRandomDhikr({
    required NotificationPreferencesEntity prefs,
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    final count   = prefs.randomDhikrFrequency.clamp(1, 10);
    final localizer = NotificationContentLocalizer(localeCode == 'ar' ? 'ar' : 'en');
    final rng     = Random();

    // Allowed window: 8 AM – 9 PM (quiet hours excluded)
    const windowStart = 8;
    const windowEnd   = 21;
    final windowHours = List.generate(windowEnd - windowStart, (i) => windowStart + i);

    // Pick `count` random hours without collision
    final selectedHours = (windowHours..shuffle(rng)).take(count).toList();

    for (var i = 0; i < selectedHours.length; i++) {
      final hour   = selectedHours[i];
      final minute = rng.nextInt(60);
      final idx    = rng.nextInt(3); // localizer has 3 random dhikr variants
      final title  = localizer.randomDhikrTitle(idx);
      final body   = localizer.randomDhikrBody(idx);

      await LocalNotificationScheduler.instance.scheduleDailyAt(
        id: NotificationIds.randomDhikrSlot(i),
        title: title,
        body: body,
        hour: hour,
        minute: minute,
        channelId: LocalNotificationScheduler.channelLow,
        payload: NotificationPayload.encode(
          type: 'dhikr',
          subType: 'random_dhikr',
          route: '/adhkar',
        ),
        scheduleMode: scheduleMode,
      );

      if (kDebugMode) {
        debugPrint('[DhikrScheduler]   random dhikr slot $i (id=${NotificationIds.randomDhikrSlot(i)}) → $hour:${minute.toString().padLeft(2, "0")}');
      }
    }
  }
}
