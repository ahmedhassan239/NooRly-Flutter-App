/// Central notification service singleton.
///
/// Coordinates initialization, permission requests, and rescheduling.
/// All scheduling calls go through the individual schedulers.
/// On web: all operations are no-ops.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';

import 'local_notification_scheduler.dart';
import 'notification_payload_parser.dart';
import 'notification_router.dart';
import 'schedulers/prayer_reminder_scheduler.dart';
import 'schedulers/lesson_reminder_scheduler.dart';
import 'schedulers/dhikr_reminder_scheduler.dart';
import 'schedulers/occasion_scheduler.dart';

export 'notification_payload_parser.dart';
export 'notification_id_registry.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  bool _initialized = false;

  /// Stored payload from a cold-start tap (before router is ready).
  NotificationPayload? _pendingTapPayload;

  /// Initialize the notification service.
  /// Call once in main() before runApp.
  Future<void> initialize() async {
    if (kIsWeb) return;
    if (_initialized) return;

    _initialized = await LocalNotificationScheduler.instance.initialize(
      onTap: (payload) => _onNotificationTap(payload),
    );

    if (kDebugMode) {
      debugPrint('[NotificationService] initialized: $_initialized');
    }
  }

  void _onNotificationTap(NotificationPayload payload) {
    final router = NotificationRouter.instance;
    // If router is ready, navigate immediately; otherwise store for later
    try {
      router.handleTap(payload);
    } catch (_) {
      _pendingTapPayload = payload;
    }
  }

  /// Call once the router is ready to flush any pending cold-start tap.
  void flushPendingTap() {
    final pending = _pendingTapPayload;
    if (pending != null) {
      _pendingTapPayload = null;
      NotificationRouter.instance.handleTap(pending);
    }
  }

  /// Request notification permission from the OS.
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    return LocalNotificationScheduler.instance.requestPermission();
  }

  /// Check whether notifications are enabled at the OS level.
  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return false;
    return LocalNotificationScheduler.instance.areNotificationsEnabled();
  }

  /// Reschedule all local notifications based on updated preferences.
  ///
  /// Cancels all existing notifications first to avoid duplicates.
  /// Pass prayer times separately so the prayer scheduler can use them.
  Future<void> rescheduleAll(
    NotificationPreferencesEntity prefs, {
    List<PrayerScheduleInput>? prayerInputs,
    LessonScheduleInput? lessonInput,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();

    if (kDebugMode) {
      debugPrint('[NotificationService] rescheduling all notifications');
    }

    // Cancel everything first
    await LocalNotificationScheduler.instance.cancelAll();

    // Reschedule prayer reminders
    if (prefs.prayerEnabled && prayerInputs != null && prayerInputs.isNotEmpty) {
      await PrayerReminderScheduler.instance.schedule(
        prayerInputs: prayerInputs,
        prefs: prefs,
      );
    }

    // Reschedule adhkar reminders
    await DhikrReminderScheduler.instance.schedule(prefs: prefs);

    // Reschedule lesson reminders
    if (lessonInput != null) {
      await LessonReminderScheduler.instance.schedule(
        input: lessonInput,
        prefs: prefs,
      );
    } else if (prefs.lessonEnabled) {
      await LessonReminderScheduler.instance.scheduleMorningOnly(prefs: prefs);
    }

    // Schedule occasion reminders (Friday)
    if (prefs.specialOccasionsEnabled) {
      await OccasionScheduler.instance.schedule(prefs: prefs);
    }
  }

  /// Cancel all scheduled local notifications.
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await LocalNotificationScheduler.instance.cancelAll();
  }
}
