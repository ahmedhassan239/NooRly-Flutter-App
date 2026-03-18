/// Special occasion scheduler.
///
/// Currently schedules:
///   - Friday reminder (every Friday at 8 AM)
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import '../local_notification_scheduler.dart';
import '../notification_content_localizer.dart';
import '../notification_id_registry.dart';
import '../notification_payload_parser.dart';

class OccasionScheduler {
  OccasionScheduler._();
  static final OccasionScheduler instance = OccasionScheduler._();

  Future<void> schedule({
    required NotificationPreferencesEntity prefs,
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    if (kIsWeb) return;
    if (!prefs.specialOccasionsEnabled) {
      await LocalNotificationScheduler.instance.cancel(NotificationIds.fridayReminder);
      return;
    }
    await _scheduleFriday(prefs: prefs, scheduleMode: scheduleMode, localeCode: localeCode);
  }

  Future<void> _scheduleFriday({
    required NotificationPreferencesEntity prefs,
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    final localizer = NotificationContentLocalizer(localeCode == 'ar' ? 'ar' : 'en');

    await LocalNotificationScheduler.instance.scheduleWeeklyAt(
      id: NotificationIds.fridayReminder,
      title: localizer.fridayTitle,
      body: localizer.fridayBody,
      dayOfWeek: Day.friday,
      hour: 8,
      minute: 0,
      channelId: LocalNotificationScheduler.channelReminders,
      payload: NotificationPayload.encode(
        type: 'occasion',
        subType: 'friday',
        route: '/home',
      ),
      scheduleMode: scheduleMode,
    );

    if (kDebugMode) {
      debugPrint('[OccasionScheduler] Friday reminder scheduled for every Friday at 08:00');
    }
  }
}
