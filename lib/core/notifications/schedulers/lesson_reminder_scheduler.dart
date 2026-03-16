/// Lesson reminder scheduler.
///
/// Schedules:
///   - Morning lesson reminder (user-configurable time, default 9 AM)
///   - Evening incomplete reminder (6 PM, only if lesson not completed)
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import '../local_notification_scheduler.dart';
import '../notification_id_registry.dart';
import '../notification_payload_parser.dart';

class LessonScheduleInput {
  const LessonScheduleInput({
    required this.dayNumber,
    required this.lessonTitleEn,
    required this.lessonTitleAr,
    required this.durationMinutes,
    this.lessonId,
    this.isCompleted = false,
  });

  final int dayNumber;
  final String lessonTitleEn;
  final String lessonTitleAr;
  final int durationMinutes;
  final String? lessonId;
  final bool isCompleted;
}

class LessonReminderScheduler {
  LessonReminderScheduler._();
  static final LessonReminderScheduler instance = LessonReminderScheduler._();

  Future<void> schedule({
    required LessonScheduleInput input,
    required NotificationPreferencesEntity prefs,
  }) async {
    if (kIsWeb) return;

    if (!prefs.lessonEnabled) {
      await LocalNotificationScheduler.instance
          .cancelIds([NotificationIds.lessonMorning, NotificationIds.lessonEvening]);
      return;
    }

    await _scheduleMorning(input: input, prefs: prefs);

    if (!input.isCompleted && prefs.lessonEveningReminderEnabled) {
      await _scheduleEvening(input: input, prefs: prefs);
    } else {
      await LocalNotificationScheduler.instance.cancel(NotificationIds.lessonEvening);
    }
  }

  Future<void> scheduleMorningOnly({required NotificationPreferencesEntity prefs}) async {
    if (kIsWeb) return;
    if (!prefs.lessonEnabled) return;

    final effectiveTime = prefs.effectiveLessonTime;
    final isArabic = prefs.languageMode == NotificationLanguageMode.arabic;

    await LocalNotificationScheduler.instance.scheduleDailyAt(
      id: NotificationIds.lessonMorning,
      title: isArabic ? '📖 درس اليوم جاهز!' : '📖 Today\'s Lesson is Ready!',
      body: isArabic ? 'افتح التطبيق لتبدأ درس اليوم' : 'Open the app to start today\'s lesson',
      hour: effectiveTime.hour,
      minute: effectiveTime.minute,
      channelId: LocalNotificationScheduler.channelReminders,
      payload: NotificationPayload.encode(
        type: 'lesson',
        subType: 'lesson_morning',
        route: '/home',
      ),
    );
  }

  Future<void> _scheduleMorning({
    required LessonScheduleInput input,
    required NotificationPreferencesEntity prefs,
  }) async {
    final effectiveTime = prefs.effectiveLessonTime;
    final isArabic = prefs.languageMode == NotificationLanguageMode.arabic;

    final title = isArabic ? '📖 درس اليوم جاهز!' : '📖 Today\'s Lesson is Ready!';
    final body  = isArabic
        ? 'اليوم ${input.dayNumber}: ${input.lessonTitleAr}\n⏱️ ${input.durationMinutes} دقائق فقط'
        : 'Day ${input.dayNumber}: ${input.lessonTitleEn}\n⏱️ Just ${input.durationMinutes} minutes';

    await LocalNotificationScheduler.instance.scheduleDailyAt(
      id: NotificationIds.lessonMorning,
      title: title,
      body: body,
      hour: effectiveTime.hour,
      minute: effectiveTime.minute,
      channelId: LocalNotificationScheduler.channelReminders,
      payload: NotificationPayload.encode(
        type: 'lesson',
        subType: 'lesson_morning',
        route: '/home',
        extra: {'lesson_id': input.lessonId ?? ''},
      ),
    );

    if (kDebugMode) {
      debugPrint('[LessonScheduler] Morning lesson at ${effectiveTime.hour}:${effectiveTime.minute}');
    }
  }

  Future<void> _scheduleEvening({
    required LessonScheduleInput input,
    required NotificationPreferencesEntity prefs,
  }) async {
    final isArabic = prefs.languageMode == NotificationLanguageMode.arabic;

    final title = isArabic
        ? '⏰ لم تنهِ درس اليوم بعد'
        : '⏰ You Haven\'t Completed Today\'s Lesson Yet';
    final body  = isArabic
        ? 'لا يزال لديك وقت!\nاليوم ${input.dayNumber}: ${input.lessonTitleAr}'
        : 'You still have time!\nDay ${input.dayNumber}: ${input.lessonTitleEn}';

    await LocalNotificationScheduler.instance.scheduleDailyAt(
      id: NotificationIds.lessonEvening,
      title: title,
      body: body,
      hour: 18,
      minute: 0,
      channelId: LocalNotificationScheduler.channelReminders,
      payload: NotificationPayload.encode(
        type: 'lesson',
        subType: 'lesson_evening',
        route: '/home',
        extra: {'lesson_id': input.lessonId ?? ''},
      ),
    );
  }
}
