/// Prayer reminder scheduler.
///
/// Schedules one notification per enabled prayer per day.
/// Applies the user's timing mode (before/at/after) and offset minutes.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import '../local_notification_scheduler.dart';
import '../notification_id_registry.dart';
import '../notification_payload_parser.dart';

/// Input model for a single prayer's scheduled time.
class PrayerScheduleInput {
  const PrayerScheduleInput({
    required this.name,  // fajr, dhuhr, asr, maghrib, isha
    required this.time,
  });

  final String name;
  final DateTime time;
}

class PrayerReminderScheduler {
  PrayerReminderScheduler._();
  static final PrayerReminderScheduler instance = PrayerReminderScheduler._();

  static const _prayerIds = {
    'fajr':    NotificationIds.fajr,
    'dhuhr':   NotificationIds.dhuhr,
    'asr':     NotificationIds.asr,
    'maghrib': NotificationIds.maghrib,
    'isha':    NotificationIds.isha,
  };

  static const _prayerTitlesEn = {
    'fajr':    '🌅 It\'s Time for Fajr Prayer',
    'dhuhr':   '☀️ It\'s Time for Dhuhr Prayer',
    'asr':     '🌤️ It\'s Time for Asr Prayer',
    'maghrib': '🌆 It\'s Time for Maghrib Prayer',
    'isha':    '🌙 It\'s Time for Isha Prayer',
  };

  static const _prayerBodiesEn = {
    'fajr':    '"Prayer is better than sleep"',
    'dhuhr':   'Don\'t forget your Dhuhr prayer today',
    'asr':     'Asr time has entered, make wudu and pray',
    'maghrib': 'Maghrib Adhan is now',
    'isha':    'Pray Isha before sleep',
  };

  static const _prayerTitlesAr = {
    'fajr':    '🌅 حان وقت صلاة الفجر',
    'dhuhr':   '☀️ حان وقت صلاة الظهر',
    'asr':     '🌤️ حان وقت صلاة العصر',
    'maghrib': '🌆 حان وقت صلاة المغرب',
    'isha':    '🌙 حان وقت صلاة العشاء',
  };

  static const _prayerBodiesAr = {
    'fajr':    '"الصلاة خير من النوم"',
    'dhuhr':   'لا تنسَ صلاة الظهر اليوم',
    'asr':     'وقت العصر دخل، توضأ وصلِّ',
    'maghrib': 'أذان المغرب الآن',
    'isha':    'صلِّ العشاء قبل النوم',
  };

  /// Check if a specific prayer is enabled in prefs.
  bool _isPrayerEnabled(String name, NotificationPreferencesEntity prefs) =>
      switch (name) {
        'fajr'    => prefs.fajrEnabled,
        'dhuhr'   => prefs.dhuhrEnabled,
        'asr'     => prefs.asrEnabled,
        'maghrib' => prefs.maghribEnabled,
        'isha'    => prefs.ishaEnabled,
        _         => false,
      };

  Future<void> schedule({
    required List<PrayerScheduleInput> prayerInputs,
    required NotificationPreferencesEntity prefs,
  }) async {
    if (kIsWeb) return;

    final scheduler = LocalNotificationScheduler.instance;
    final now       = DateTime.now();

    for (final prayer in prayerInputs) {
      final id = _prayerIds[prayer.name];
      if (id == null) continue;
      if (!_isPrayerEnabled(prayer.name, prefs)) {
        await scheduler.cancel(id);
        continue;
      }

      // Apply timing offset
      final offsetMinutes = _computeOffset(prefs);
      var scheduledTime = prayer.time.add(Duration(minutes: offsetMinutes));

      // Skip prayers that have already passed today
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      final isArabic = prefs.languageMode == NotificationLanguageMode.arabic;
      final title = isArabic
          ? (_prayerTitlesAr[prayer.name] ?? '')
          : (_prayerTitlesEn[prayer.name] ?? '');
      final body = isArabic
          ? (_prayerBodiesAr[prayer.name] ?? '')
          : (_prayerBodiesEn[prayer.name] ?? '');

      final payload = NotificationPayload.encode(
        type: 'prayer',
        subType: prayer.name,
        route: '/prayer-times',
      );

      await scheduler.scheduleAt(
        id: id,
        title: title,
        body: body,
        scheduledAt: scheduledTime,
        channelId: LocalNotificationScheduler.channelPrayers,
        payload: payload,
      );

      if (kDebugMode) {
        debugPrint('[PrayerScheduler] ${prayer.name} → $scheduledTime');
      }
    }
  }

  int _computeOffset(NotificationPreferencesEntity prefs) {
    return switch (prefs.prayerTimingMode) {
      PrayerTimingMode.before => -prefs.prayerOffsetMinutes.abs(),
      PrayerTimingMode.after  => prefs.prayerOffsetMinutes.abs(),
      PrayerTimingMode.at     => 0,
    };
  }
}
