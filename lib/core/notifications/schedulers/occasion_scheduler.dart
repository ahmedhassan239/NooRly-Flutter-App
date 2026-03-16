/// Special occasion scheduler.
///
/// Currently schedules:
///   - Friday reminder (every Friday at 8 AM)
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import '../local_notification_scheduler.dart';
import '../notification_id_registry.dart';
import '../notification_payload_parser.dart';

class OccasionScheduler {
  OccasionScheduler._();
  static final OccasionScheduler instance = OccasionScheduler._();

  Future<void> schedule({required NotificationPreferencesEntity prefs}) async {
    if (kIsWeb) return;
    if (!prefs.specialOccasionsEnabled) {
      await LocalNotificationScheduler.instance.cancel(NotificationIds.fridayReminder);
      return;
    }
    await _scheduleFriday(prefs: prefs);
  }

  Future<void> _scheduleFriday({required NotificationPreferencesEntity prefs}) async {
    final isArabic = prefs.languageMode == NotificationLanguageMode.arabic;

    await LocalNotificationScheduler.instance.scheduleWeeklyAt(
      id: NotificationIds.fridayReminder,
      title: isArabic ? '🕌 الجمعة المباركة' : '🕌 Blessed Friday',
      body: isArabic
          ? 'لا تنسَ صلاة الجمعة اليوم\nاقرأ سورة الكهف 📖'
          : "Don't forget Jumu'ah prayer today\nRead Surah Al-Kahf 📖",
      dayOfWeek: Day.friday,
      hour: 8,
      minute: 0,
      channelId: LocalNotificationScheduler.channelReminders,
      payload: NotificationPayload.encode(
        type: 'occasion',
        subType: 'friday',
        route: '/home',
      ),
    );

    if (kDebugMode) {
      debugPrint('[OccasionScheduler] Friday reminder scheduled for every Friday at 08:00');
    }
  }
}
