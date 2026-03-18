/// Prayer reminder scheduler.
///
/// Schedules one notification per enabled prayer per day.
/// Applies the user's timing mode (before/at/after) and offset minutes.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import '../local_notification_scheduler.dart';
import '../notification_content_localizer.dart';
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
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    if (kIsWeb) return;

    final scheduler = LocalNotificationScheduler.instance;
    final now       = DateTime.now();
    int scheduled   = 0;
    int skipped     = 0;

    if (kDebugMode) {
      final offsetMinutes = _computeOffset(prefs);
      debugPrint('[PrayerScheduler] ── schedule() called ──');
      debugPrint('[PrayerScheduler] timingMode=${prefs.prayerTimingMode.name}  offset=${offsetMinutes}min');
    }

    for (final prayer in prayerInputs) {
      final id = _prayerIds[prayer.name];
      if (id == null) {
        if (kDebugMode) debugPrint('[PrayerScheduler] SKIP ${prayer.name} — unknown prayer name, id=null');
        continue;
      }
      if (!_isPrayerEnabled(prayer.name, prefs)) {
        await scheduler.cancel(id);
        skipped++;
        if (kDebugMode) debugPrint('[PrayerScheduler] SKIP ${prayer.name} — disabled in prefs');
        continue;
      }

      // Apply timing offset
      final offsetMinutes = _computeOffset(prefs);
      var scheduledTime = prayer.time.add(Duration(minutes: offsetMinutes));

      // Skip prayers that have already passed today
      final pushedToTomorrow = scheduledTime.isBefore(now);
      if (pushedToTomorrow) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      final localizer = NotificationContentLocalizer(
        localeCode == 'ar' ? 'ar' : 'en',
      );
      final title = localizer.prayerTitle(prayer.name);
      final body = localizer.prayerBody(prayer.name);

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
        scheduleMode: scheduleMode,
      );

      scheduled++;
      if (kDebugMode) {
        final suffix = pushedToTomorrow ? ' (pushed to tomorrow — already passed)' : '';
        debugPrint('[PrayerScheduler] ✓ ${prayer.name} (id=$id) → $scheduledTime$suffix');
      }
    }

    if (kDebugMode) {
      debugPrint('[PrayerScheduler] done — scheduled=$scheduled  skipped=$skipped');
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
