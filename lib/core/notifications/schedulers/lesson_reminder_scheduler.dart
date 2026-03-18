/// Lesson reminder scheduler.
///
/// Schedules:
///   - Morning lesson reminder (user-configurable time, default 9 AM)
///   - Evening incomplete reminder (6 PM, only if lesson not completed)
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import '../local_notification_scheduler.dart';
import '../notification_content_localizer.dart';
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
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    if (kIsWeb) return;

    if (kDebugMode) {
      debugPrint('[LessonScheduler] ── schedule() called ──');
      debugPrint('[LessonScheduler] day=${input.dayNumber}  completed=${input.isCompleted}  lessonEnabled=${prefs.lessonEnabled}');
    }

    if (!prefs.lessonEnabled) {
      await LocalNotificationScheduler.instance
          .cancelIds([NotificationIds.lessonMorning, NotificationIds.lessonEvening]);
      if (kDebugMode) debugPrint('[LessonScheduler] SKIP all — lessonEnabled=false');
      return;
    }

    await _scheduleMorning(input: input, prefs: prefs, scheduleMode: scheduleMode, localeCode: localeCode);

    if (!input.isCompleted && prefs.lessonEveningReminderEnabled) {
      if (kDebugMode) debugPrint('[LessonScheduler] ✓ evening reminder → 18:00 (lesson not completed)');
      await _scheduleEvening(input: input, prefs: prefs, scheduleMode: scheduleMode, localeCode: localeCode);
    } else {
      await LocalNotificationScheduler.instance.cancel(NotificationIds.lessonEvening);
      if (kDebugMode) {
        final reason = input.isCompleted
            ? 'lesson already completed'
            : 'lessonEveningReminderEnabled=false';
        debugPrint('[LessonScheduler] SKIP evening reminder — $reason');
      }
    }

    if (kDebugMode) debugPrint('[LessonScheduler] ── schedule() done ──');
  }

  Future<void> scheduleMorningOnly({
    required NotificationPreferencesEntity prefs,
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    if (kIsWeb) return;
    if (!prefs.lessonEnabled) return;

    final effectiveTime = prefs.effectiveLessonTime;
    final localizer = NotificationContentLocalizer(localeCode == 'ar' ? 'ar' : 'en');

    if (kDebugMode) {
      debugPrint('[LessonScheduler] ── scheduleMorningOnly() called ──');
      debugPrint('[LessonScheduler] ✓ morning lesson (generic) → ${effectiveTime.hour}:${effectiveTime.minute.toString().padLeft(2, "0")}');
    }

    await LocalNotificationScheduler.instance.scheduleDailyAt(
      id: NotificationIds.lessonMorning,
      title: localizer.lessonMorningTitle,
      body: localizer.lessonMorningBody,
      hour: effectiveTime.hour,
      minute: effectiveTime.minute,
      channelId: LocalNotificationScheduler.channelReminders,
      payload: NotificationPayload.encode(
        type: 'lesson',
        subType: 'lesson_morning',
        route: '/home',
      ),
      scheduleMode: scheduleMode,
    );
  }

  Future<void> _scheduleMorning({
    required LessonScheduleInput input,
    required NotificationPreferencesEntity prefs,
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    final effectiveTime = prefs.effectiveLessonTime;
    final localizer = NotificationContentLocalizer(localeCode == 'ar' ? 'ar' : 'en');

    final title = localizer.lessonMorningTitle;
    final body  = localizer.lessonMorningBodyWithDay(
      input.dayNumber,
      input.durationMinutes,
      input.lessonTitleEn,
      input.lessonTitleAr,
    );

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
      scheduleMode: scheduleMode,
    );

    if (kDebugMode) {
      debugPrint('[LessonScheduler] ✓ morning lesson (day=${input.dayNumber}) → ${effectiveTime.hour}:${effectiveTime.minute.toString().padLeft(2, "0")}');
    }
  }

  Future<void> _scheduleEvening({
    required LessonScheduleInput input,
    required NotificationPreferencesEntity prefs,
    AndroidScheduleMode? scheduleMode,
    String localeCode = 'en',
  }) async {
    final localizer = NotificationContentLocalizer(localeCode == 'ar' ? 'ar' : 'en');

    final title = localizer.lessonEveningTitle;
    final body  = localizer.lessonEveningBody(
      input.dayNumber,
      input.lessonTitleEn,
      input.lessonTitleAr,
    );

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
      scheduleMode: scheduleMode,
    );
  }
}
