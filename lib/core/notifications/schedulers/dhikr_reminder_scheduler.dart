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
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import '../local_notification_scheduler.dart';
import '../notification_id_registry.dart';
import '../notification_payload_parser.dart';

class DhikrReminderScheduler {
  DhikrReminderScheduler._();
  static final DhikrReminderScheduler instance = DhikrReminderScheduler._();

  static const _randomDhikrTitlesEn = [
    '💚 Spiritual Reminder',
    '💚 Remember Allah',
    '💚 A Moment of Reflection',
  ];
  static const _randomDhikrBodiesEn = [
    'Glory is to Allah and praise is to Him\nSubhan Allahi wa bihamdihi',
    'There is no power except with Allah\nLa hawla wala quwwata illa billah',
    'Allah is the Greatest\nAllahu Akbar',
  ];

  static const _randomDhikrTitlesAr = [
    '💚 تذكير روحي',
    '💚 اذكر الله',
    '💚 لحظة تأمل',
  ];
  static const _randomDhikrBodiesAr = [
    'سُبْحَانَ اللهِ وَبِحَمْدِهِ\nSubhan Allahi wa bihamdihi',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ\nLa hawla wala quwwata illa billah',
    'اللهُ أَكْبَر\nAllahu Akbar',
  ];

  Future<void> schedule({
    required NotificationPreferencesEntity prefs,
    DateTime? fajrTime,
    DateTime? asrTime,
  }) async {
    if (kIsWeb) return;

    // Morning adhkar
    if (prefs.morningAdhkarEnabled) {
      final morningHour = fajrTime != null
          ? fajrTime.add(const Duration(minutes: 30)).hour
          : 6;
      await _scheduleMorningAdhkar(prefs: prefs, hour: morningHour);
    } else {
      await LocalNotificationScheduler.instance.cancel(NotificationIds.morningAdhkar);
    }

    // Evening adhkar
    if (prefs.eveningAdhkarEnabled) {
      final eveningHour = asrTime != null
          ? asrTime.add(const Duration(minutes: 30)).hour
          : 16;
      await _scheduleEveningAdhkar(prefs: prefs, hour: eveningHour);
    } else {
      await LocalNotificationScheduler.instance.cancel(NotificationIds.eveningAdhkar);
    }

    // Sleep adhkar
    if (prefs.sleepAdhkarEnabled) {
      await _scheduleSleepAdhkar(prefs: prefs);
    } else {
      await LocalNotificationScheduler.instance.cancel(NotificationIds.sleepAdhkar);
    }

    // Random dhikr
    final dhikrSlotIds = List.generate(10, (i) => NotificationIds.randomDhikrSlot(i));
    if (prefs.randomDhikrEnabled) {
      await _scheduleRandomDhikr(prefs: prefs);
    } else {
      await LocalNotificationScheduler.instance.cancelIds(dhikrSlotIds);
    }
  }

  Future<void> _scheduleMorningAdhkar({
    required NotificationPreferencesEntity prefs,
    required int hour,
  }) async {
    final isArabic = prefs.languageMode == NotificationLanguageMode.arabic;
    await LocalNotificationScheduler.instance.scheduleDailyAt(
      id: NotificationIds.morningAdhkar,
      title: isArabic ? '☀️ أذكار الصباح' : '☀️ Morning Adhkar',
      body: isArabic
          ? 'لا تنسَ أذكار الصباح اليوم\nاضغط للقراءة الآن'
          : "Don't forget your morning remembrances\nTap to read now",
      hour: hour,
      minute: 0,
      channelId: LocalNotificationScheduler.channelReminders,
      payload: NotificationPayload.encode(
        type: 'dhikr',
        subType: 'morning_adhkar',
        route: '/adhkar',
      ),
    );
  }

  Future<void> _scheduleEveningAdhkar({
    required NotificationPreferencesEntity prefs,
    required int hour,
  }) async {
    final isArabic = prefs.languageMode == NotificationLanguageMode.arabic;
    await LocalNotificationScheduler.instance.scheduleDailyAt(
      id: NotificationIds.eveningAdhkar,
      title: isArabic ? '🌙 أذكار المساء' : '🌙 Evening Adhkar',
      body: isArabic
          ? 'حان وقت أذكار المساء\nاضغط للقراءة الآن'
          : "It's time for evening remembrances\nTap to read now",
      hour: hour,
      minute: 0,
      channelId: LocalNotificationScheduler.channelReminders,
      payload: NotificationPayload.encode(
        type: 'dhikr',
        subType: 'evening_adhkar',
        route: '/adhkar',
      ),
    );
  }

  Future<void> _scheduleSleepAdhkar({
    required NotificationPreferencesEntity prefs,
  }) async {
    final t = prefs.effectiveSleepAdhkarTime;
    final isArabic = prefs.languageMode == NotificationLanguageMode.arabic;
    await LocalNotificationScheduler.instance.scheduleDailyAt(
      id: NotificationIds.sleepAdhkar,
      title: isArabic ? '😴 أذكار النوم' : '😴 Sleep Adhkar',
      body: isArabic
          ? 'لا تنم قبل قراءة أذكار النوم\nاضغط للقراءة الآن'
          : "Don't sleep before reading sleep remembrances\nTap to read now",
      hour: t.hour,
      minute: t.minute,
      channelId: LocalNotificationScheduler.channelLow,
      payload: NotificationPayload.encode(
        type: 'dhikr',
        subType: 'sleep_adhkar',
        route: '/adhkar',
      ),
    );
  }

  Future<void> _scheduleRandomDhikr({
    required NotificationPreferencesEntity prefs,
  }) async {
    final count    = prefs.randomDhikrFrequency.clamp(1, 10);
    final isArabic = prefs.languageMode == NotificationLanguageMode.arabic;
    final rng      = Random();

    // Allowed window: 8 AM – 9 PM (quiet hours excluded)
    const windowStart = 8;
    const windowEnd   = 21;
    final windowHours = List.generate(windowEnd - windowStart, (i) => windowStart + i);

    // Pick `count` random hours without collision
    final selectedHours = (windowHours..shuffle(rng)).take(count).toList();

    for (var i = 0; i < selectedHours.length; i++) {
      final hour   = selectedHours[i];
      final idx    = rng.nextInt(_randomDhikrTitlesEn.length);
      final title  = isArabic ? _randomDhikrTitlesAr[idx] : _randomDhikrTitlesEn[idx];
      final body   = isArabic ? _randomDhikrBodiesAr[idx] : _randomDhikrBodiesEn[idx];

      await LocalNotificationScheduler.instance.scheduleDailyAt(
        id: NotificationIds.randomDhikrSlot(i),
        title: title,
        body: body,
        hour: hour,
        minute: rng.nextInt(60),
        channelId: LocalNotificationScheduler.channelLow,
        payload: NotificationPayload.encode(
          type: 'dhikr',
          subType: 'random_dhikr',
          route: '/adhkar',
        ),
      );
    }
  }
}
