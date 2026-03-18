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

  /// Whether the service (and underlying plugin) is ready to schedule notifications.
  bool get isInitialized => _initialized;

  /// The last error that prevented initialization, or `null` on success.
  /// Delegates to [LocalNotificationScheduler.lastInitError].
  String? get lastInitError =>
      LocalNotificationScheduler.instance.lastInitError;

  /// Stored payload from a cold-start tap (before router is ready).
  NotificationPayload? _pendingTapPayload;

  /// Initialize the notification service.
  /// Call once in main() before runApp.
  Future<void> initialize() async {
    if (kIsWeb) return;
    if (_initialized) return;

    // Always-on log — visible in release via `adb logcat | grep flutter`.
    print('[NotificationService] initialize() starting…');

    _initialized = await LocalNotificationScheduler.instance.initialize(
      onTap: (payload) => _onNotificationTap(payload),
    );

    // Always-on: both success and failure must be visible in release builds.
    if (_initialized) {
      print('[NotificationService] ✅ initialized successfully');
    } else {
      final err = LocalNotificationScheduler.instance.lastInitError ?? 'unknown';
      print('[NotificationService] ❌ initialization FAILED — lastInitError: $err');
    }
  }

  /// Force a full re-initialization attempt (useful from the debug UI).
  ///
  /// Resets internal state, requests the OS notification permission,
  /// then calls [LocalNotificationScheduler.forceReinitialize].
  Future<bool> reinitialize() async {
    if (kIsWeb) return false;
    _initialized = false;
    print('[NotificationService] reinitialize() requested');

    await requestPermission();

    _initialized = await LocalNotificationScheduler.instance.forceReinitialize(
      onTap: (payload) => _onNotificationTap(payload),
    );
    final err = LocalNotificationScheduler.instance.lastInitError;
    if (_initialized) {
      print('[NotificationService] ✅ reinitialize() succeeded');
    } else {
      print('[NotificationService] ❌ reinitialize() FAILED — $err');
    }
    return _initialized;
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

  /// Check whether exact alarm scheduling is permitted (Android 12+ only).
  ///
  /// Returns true on Android < 12 and on non-Android platforms.
  /// If false, the user must open Settings → Special app access → Alarms & Reminders.
  Future<bool> canScheduleExactAlarms() async {
    if (kIsWeb) return false;
    return LocalNotificationScheduler.instance.canScheduleExactAlarms();
  }

  /// Opens the system Alarms & Reminders settings page (Android 12+ only).
  Future<void> requestExactAlarmsPermission() async {
    if (kIsWeb) return;
    await LocalNotificationScheduler.instance.requestExactAlarmsPermission();
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
      debugPrint('[NotificationService] ── rescheduleAll() called ──');
    }

    // Cancel everything first
    await LocalNotificationScheduler.instance.cancelAll();

    // Resolve schedule mode ONCE — avoids N platform channel calls (one per notification).
    final scheduleMode = await LocalNotificationScheduler.instance.resolveScheduleMode();

    // ── Prayer reminders ──────────────────────────────────────────────────
    if (prefs.prayerEnabled && prayerInputs != null && prayerInputs.isNotEmpty) {
      if (kDebugMode) debugPrint('[NotificationService] scheduling prayer reminders (${prayerInputs.length} inputs)');
      await PrayerReminderScheduler.instance.schedule(
        prayerInputs: prayerInputs,
        prefs: prefs,
        scheduleMode: scheduleMode,
      );
    } else if (kDebugMode) {
      if (!prefs.prayerEnabled) {
        debugPrint('[NotificationService] SKIP prayer reminders — prayerEnabled=false');
      } else {
        debugPrint('[NotificationService] SKIP prayer reminders — no prayer inputs available');
      }
    }

    // ── Adhkar reminders ──────────────────────────────────────────────────
    if (kDebugMode) debugPrint('[NotificationService] scheduling adhkar reminders');
    await DhikrReminderScheduler.instance.schedule(prefs: prefs, scheduleMode: scheduleMode);

    // ── Lesson reminders ──────────────────────────────────────────────────
    if (lessonInput != null) {
      if (kDebugMode) debugPrint('[NotificationService] scheduling lesson reminders (day=${lessonInput.dayNumber}, completed=${lessonInput.isCompleted})');
      await LessonReminderScheduler.instance.schedule(
        input: lessonInput,
        prefs: prefs,
        scheduleMode: scheduleMode,
      );
    } else if (prefs.lessonEnabled) {
      if (kDebugMode) debugPrint('[NotificationService] scheduling lesson morning-only (no lesson input)');
      await LessonReminderScheduler.instance.scheduleMorningOnly(prefs: prefs, scheduleMode: scheduleMode);
    } else if (kDebugMode) {
      debugPrint('[NotificationService] SKIP lesson reminders — lessonEnabled=false');
    }

    // ── Occasion reminders ────────────────────────────────────────────────
    if (prefs.specialOccasionsEnabled) {
      if (kDebugMode) debugPrint('[NotificationService] scheduling occasion reminders (Friday Jumu\'ah)');
      await OccasionScheduler.instance.schedule(prefs: prefs, scheduleMode: scheduleMode);
    } else if (kDebugMode) {
      debugPrint('[NotificationService] SKIP occasion reminders — specialOccasionsEnabled=false');
    }

    if (kDebugMode) {
      debugPrint('[NotificationService] ── rescheduleAll() done ──');
    }
  }

  /// Reschedule only non-prayer notifications (adhkar, lesson, occasions).
  ///
  /// Use this on app startup when prayer times are not yet available.
  Future<void> rescheduleNonPrayer(NotificationPreferencesEntity prefs) async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();

    if (kDebugMode) debugPrint('[NotificationService] rescheduling non-prayer notifications');

    // Resolve once — reused for all schedulers in this session.
    final scheduleMode = await LocalNotificationScheduler.instance.resolveScheduleMode();

    await DhikrReminderScheduler.instance.schedule(prefs: prefs, scheduleMode: scheduleMode);

    if (prefs.lessonEnabled) {
      await LessonReminderScheduler.instance.scheduleMorningOnly(prefs: prefs, scheduleMode: scheduleMode);
    }

    if (prefs.specialOccasionsEnabled) {
      await OccasionScheduler.instance.schedule(prefs: prefs, scheduleMode: scheduleMode);
    }
  }

  /// Schedule a test notification that fires in [delaySeconds] seconds.
  Future<void> scheduleTestNotification({int delaySeconds = 10}) async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();
    await LocalNotificationScheduler.instance.showTestNotification(
      delaySeconds: delaySeconds,
    );
  }

  /// Returns debug info: permission, init status, all pending notifications.
  ///
  /// Pending list is only fetched when the scheduler is initialized. If the
  /// plugin throws (e.g. Gson TypeToken on Android release), [pending_error]
  /// is set and [pending] / [pending_count] are safe defaults.
  Future<Map<String, dynamic>> debugStatus() async {
    if (kIsWeb) return {'platform': 'web'};
    final enabled = await areNotificationsEnabled();
    final canExact = await canScheduleExactAlarms();
    final initError = LocalNotificationScheduler.instance.lastInitError;
    final schedulerInit = LocalNotificationScheduler.instance.isInitialized;

    List<Map<String, dynamic>> pendingList = [];
    String? pendingError;

    if (schedulerInit) {
      try {
        final pending =
            await LocalNotificationScheduler.instance.getPendingNotifications();
        pendingList = pending
            .map((n) => {
                  'id': n.id,
                  'title': n.title,
                  'body': n.body,
                  'payload': n.payload,
                })
            .toList();
      } catch (e, st) {
        pendingError = e.toString();
        print('[NotificationService] debugStatus getPendingNotifications failed: $e');
        print(st.toString());
      }
    }

    return {
      'initialized': _initialized,
      'scheduler_initialized': schedulerInit,
      'last_init_error': initError,
      'notifications_enabled': enabled,
      'can_schedule_exact_alarms': canExact,
      'pending_count': pendingList.length,
      'pending': pendingList,
      if (pendingError != null) 'pending_error': pendingError,
    };
  }

  /// Cancel all scheduled local notifications.
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await LocalNotificationScheduler.instance.cancelAll();
  }
}
