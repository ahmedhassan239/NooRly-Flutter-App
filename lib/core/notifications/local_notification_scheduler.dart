/// Low-level flutter_local_notifications wrapper.
///
/// All scheduling goes through this class.
/// On web: all methods are no-ops (kIsWeb guard).
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_content_localizer.dart';
import 'notification_payload_parser.dart';

// Re-export Day for use in OccasionScheduler without importing flutter_local_notifications directly
export 'package:flutter_local_notifications/flutter_local_notifications.dart' show Day;

/// Callback invoked when user taps a notification.
typedef OnNotificationTap = void Function(NotificationPayload payload);

class LocalNotificationScheduler {
  LocalNotificationScheduler._();
  static final LocalNotificationScheduler instance = LocalNotificationScheduler._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// The last error message that caused initialization to fail.
  /// `null` when initialization succeeded or has not been attempted.
  String? _lastInitError;

  /// Whether the plugin is ready to schedule notifications.
  bool get isInitialized => _initialized;

  /// The error message from the most recent failed [initialize] call.
  /// Exposed so the debug UI can surface the exact failure reason.
  String? get lastInitError => _lastInitError;

  // --- Channel IDs ---
  static const String channelPrayers   = 'noorly_prayers';
  static const String channelReminders = 'noorly_reminders';
  static const String channelLow       = 'noorly_low';
  static const String channelAdminCampaigns = 'noorly_admin_campaigns';

  /// Initialize the plugin and timezone data.
  ///
  /// Returns `true` on success, `false` on any failure.
  /// Never throws — all plugin errors are caught and logged so notification
  /// failure can NEVER prevent the app from starting.
  Future<bool> initialize({void Function(NotificationPayload payload)? onTap}) async {
    if (kIsWeb) return false;
    if (_initialized) return true;

    // Clear any error from a previous failed attempt.
    _lastInitError = null;

    // All print() calls here are intentionally un-gated so they are visible
    // in release builds via `adb logcat | grep flutter`. This is the only
    // reliable way to diagnose plugin failures on a real device.
    print('[LocalNotificationScheduler] ── initialize() started ──');

    // ── Step 1: Timezone setup ────────────────────────────────────────────
    try {
      tz.initializeTimeZones();
      print('[LocalNotificationScheduler] step 1/3: timezone DB initialised');
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
      print('[LocalNotificationScheduler] step 1/3: device timezone = ${tzInfo.identifier}');
    } catch (e, st) {
      // Non-fatal — scheduling falls back to UTC times.
      print('[LocalNotificationScheduler] step 1/3: ⚠️ timezone error (UTC fallback): $e');
      print(st.toString());
    }

    // ── Step 2: Plugin initialization ─────────────────────────────────────
    // Icon 'ic_notification' → res/drawable/ic_notification.xml
    // Material Design bell, single-line path, white on transparent, API ≥ 21.
    // Do NOT use '@mipmap/ic_launcher': on API 26+ it resolves to an adaptive
    // icon XML which flutter_local_notifications rejects with invalid_icon.
    const androidSettings = AndroidInitializationSettings('ic_notification');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    print('[LocalNotificationScheduler] step 2/3: calling plugin.initialize() '
        'with icon=ic_notification…');

    bool pluginReady = false;
    try {
      final result = await _plugin.initialize(
        const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
        onDidReceiveNotificationResponse: (details) {
          final payload = NotificationPayload.tryParse(details.payload);
          if (payload != null && onTap != null) {
            onTap(payload);
          }
        },
      );
      pluginReady = result ?? false;
      if (pluginReady) {
        print('[LocalNotificationScheduler] step 2/3: ✅ plugin.initialize() = true');
      } else {
        final msg = 'plugin.initialize() returned false (result=$result). '
            'Possible causes: icon resource not found in drawable/, '
            'plugin already detached, or WidgetsBinding not yet initialised.';
        print('[LocalNotificationScheduler] step 2/3: ❌ $msg');
        _lastInitError = msg;
        _initialized = false;
        return false;
      }
    } catch (e, st) {
      // PlatformException(invalid_icon, …) is the most common failure.
      final msg = 'plugin.initialize() threw: $e';
      print('[LocalNotificationScheduler] step 2/3: ❌ $msg');
      print(st.toString());
      _lastInitError = msg;
      _initialized = false;
      return false;
    }

    // ── Step 3: Android channel creation ──────────────────────────────────
    try {
      await _createAndroidChannels();
      print('[LocalNotificationScheduler] step 3/3: ✅ Android channels created');
    } catch (e, st) {
      // Non-fatal: notifications work but may not be categorised.
      print('[LocalNotificationScheduler] step 3/3: ⚠️ channel creation failed: $e');
      print(st.toString());
      // Don't set _lastInitError — channels failing is non-fatal.
    }

    _initialized = true;
    print('[LocalNotificationScheduler] ── initialize() DONE — _initialized=true ──');
    return true;
  }

  /// Reset the initialized state and retry initialization.
  ///
  /// Useful from the debug UI when a previous init attempt failed.
  Future<bool> forceReinitialize({
    void Function(NotificationPayload payload)? onTap,
  }) async {
    _initialized = false;
    _lastInitError = null;
    return initialize(onTap: onTap);
  }

  Future<void> _createAndroidChannels() async {
    if (kIsWeb) return;
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        channelPrayers,
        'Prayer Reminders',
        description: 'Daily prayer time notifications',
        importance: Importance.max,
        playSound: true,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        channelReminders,
        'Lesson & Adhkar Reminders',
        description: 'Daily lesson and adhkar reminder notifications',
        importance: Importance.defaultImportance,
        playSound: true,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        channelLow,
        'General Reminders',
        description: 'Low-priority spiritual reminders',
        importance: Importance.low,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        channelAdminCampaigns,
        'Announcements',
        description: 'Messages from your team (shown when the app is open)',
        importance: Importance.high,
        playSound: true,
      ),
    );
  }

  /// Request notification permission (Android 13+, iOS).
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;

    final ios = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    return false;
  }

  /// Check if notifications are currently allowed.
  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return false;
    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }
    return false;
  }

  /// Check if exact alarm scheduling is permitted (Android 12+ / API 31+).
  ///
  /// On Android < 12, always returns true.
  /// On Android 12+, the user must grant "Alarms & Reminders" in special app access.
  /// Without this, [scheduleAt] will throw a SecurityException when the alarm fires.
  Future<bool> canScheduleExactAlarms() async {
    if (kIsWeb) return false;
    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.canScheduleExactNotifications() ?? true;
    }
    return true;
  }

  /// Opens the system "Alarms & Reminders" settings page so the user can grant
  /// the exact alarm permission (Android 12+ only).
  Future<void> requestExactAlarmsPermission() async {
    if (kIsWeb) return;
    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestExactAlarmsPermission();
  }

  /// Resolve the Android schedule mode once per session to avoid a separate
  /// platform-channel round-trip for every notification being scheduled.
  ///
  /// Pass the result into [scheduleAt], [scheduleDailyAt], [scheduleWeeklyAt].
  /// Defaults to [AndroidScheduleMode.exactAllowWhileIdle] on any error.
  Future<AndroidScheduleMode> resolveScheduleMode() async {
    try {
      final canExact = await canScheduleExactAlarms();
      if (!canExact && kDebugMode) {
        debugPrint('[LocalNotificationScheduler] ⚠️  Exact alarm permission NOT granted — '
            'using inexact mode. '
            'Go to Settings → Special app access → Alarms & Reminders to fix.');
      }
      return canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
    } catch (e) {
      if (kDebugMode) debugPrint('[LocalNotificationScheduler] resolveScheduleMode error: $e');
      return AndroidScheduleMode.exactAllowWhileIdle;
    }
  }

  /// Schedule a notification at an exact local datetime.
  ///
  /// Pass [scheduleMode] from [resolveScheduleMode] so the permission is
  /// checked ONCE per reschedule session rather than once per notification.
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String channelId,
    String? payload,
    AndroidScheduleMode? scheduleMode,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) {
      throw StateError(
        'LocalNotificationScheduler is not initialized. Cannot schedule notification id=$id.',
      );
    }

    final tz.TZDateTime tzTime = tz.TZDateTime.from(scheduledAt, tz.local);
    final notifDetails = _buildDetails(channelId);
    final mode = scheduleMode ?? await resolveScheduleMode();

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        notifDetails,
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[LocalNotificationScheduler] ❌ scheduleAt failed for id=$id: $e');
      }
      rethrow;
    }
  }

  /// Schedule a daily repeating notification (same time every day).
  Future<void> scheduleDailyAt({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String channelId,
    String? payload,
    AndroidScheduleMode? scheduleMode,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) {
      throw StateError(
        'LocalNotificationScheduler is not initialized. Cannot schedule daily notification id=$id.',
      );
    }

    final now    = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final mode = scheduleMode ?? await resolveScheduleMode();

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        _buildDetails(channelId),
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[LocalNotificationScheduler] ❌ scheduleDailyAt failed for id=$id: $e');
      }
      rethrow;
    }
  }

  /// Schedule a weekly notification (same weekday + time).
  Future<void> scheduleWeeklyAt({
    required int id,
    required String title,
    required String body,
    required Day dayOfWeek,
    required int hour,
    required int minute,
    required String channelId,
    String? payload,
    AndroidScheduleMode? scheduleMode,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) {
      throw StateError(
        'LocalNotificationScheduler is not initialized. Cannot schedule weekly notification id=$id.',
      );
    }

    final now     = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    // Advance to the next target weekday
    while (scheduled.weekday != dayOfWeek.value) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    final mode = scheduleMode ?? await resolveScheduleMode();

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        _buildDetails(channelId),
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[LocalNotificationScheduler] ❌ scheduleWeeklyAt failed for id=$id: $e');
      }
      rethrow;
    }
  }

  /// Show a notification immediately (foreground / app open). Not background push.
  Future<void> showImmediate({
    required int id,
    required String title,
    required String body,
    required String channelId,
    String? payload,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) {
      throw StateError(
        'LocalNotificationScheduler is not initialized. Cannot show notification id=$id.',
      );
    }
    try {
      await _plugin.show(
        id,
        title,
        body,
        _buildDetails(channelId),
        payload: payload,
      );
    } catch (e) {
      print('[LocalNotificationScheduler] ❌ showImmediate failed id=$id: $e');
      rethrow;
    }
  }

  /// Cancel a single notification by ID.
  Future<void> cancel(int id) async {
    if (kIsWeb) return;
    await _plugin.cancel(id);
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  /// Returns all currently pending (scheduled but not yet delivered) notifications.
  ///
  /// Must only be called after [initialize] has succeeded. On Android release builds,
  /// the plugin can throw (e.g. Gson TypeToken) if R8 stripped generic signatures;
  /// that is surfaced to callers so the UI can show the real error.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (kIsWeb) return [];
    if (!_initialized) {
      throw StateError(
        'LocalNotificationScheduler is not initialized. Cannot get pending notifications.',
      );
    }
    try {
      return await _plugin.pendingNotificationRequests();
    } catch (e, st) {
      print('[LocalNotificationScheduler] getPendingNotifications failed: $e');
      print(st.toString());
      rethrow;
    }
  }

  /// Show a test notification in [delaySeconds] seconds (default 10).
  /// [localeCode] `ar` or `en` for title/body; defaults to `en`.
  Future<void> showTestNotification({
    int delaySeconds = 10,
    String localeCode = 'en',
  }) async {
    if (kIsWeb) return;
    if (!_initialized) {
      throw StateError(
        'LocalNotificationScheduler is not initialized. Cannot schedule test notification.',
      );
    }
    const testNotificationId = 9999;
    final notificationsEnabled = await areNotificationsEnabled();
    final exactAlarmGranted = await canScheduleExactAlarms();
    List<PendingNotificationRequest> before;
    try {
      before = await getPendingNotifications();
    } catch (e) {
      rethrow; // already logged in getPendingNotifications
    }
    final scheduledAt = DateTime.now().add(Duration(seconds: delaySeconds));

    final localizer = NotificationContentLocalizer(
      localeCode == 'ar' ? 'ar' : 'en',
    );
    if (kDebugMode) {
      debugPrint('[LocalNotificationScheduler] ── test notification request ──');
      debugPrint('[LocalNotificationScheduler] localeCode           : $localeCode');
      debugPrint('[LocalNotificationScheduler] initialized           : $_initialized');
      debugPrint('[LocalNotificationScheduler] notifications enabled : $notificationsEnabled');
      debugPrint('[LocalNotificationScheduler] exact alarm granted  : $exactAlarmGranted');
      debugPrint('[LocalNotificationScheduler] pending before       : ${before.length}');
      debugPrint('[LocalNotificationScheduler] scheduledAt          : $scheduledAt');
    }

    await scheduleAt(
      id: testNotificationId,
      title: localizer.testNotificationTitle,
      body: localizer.testNotificationBody,
      scheduledAt: scheduledAt,
      channelId: channelReminders,
      payload: 'test',
    );

    List<PendingNotificationRequest> after;
    try {
      after = await getPendingNotifications();
    } catch (e) {
      rethrow;
    }
    final inserted = after.any((n) => n.id == testNotificationId);

    if (kDebugMode) {
      debugPrint('[LocalNotificationScheduler] pending after        : ${after.length}');
      debugPrint('[LocalNotificationScheduler] test pending exists  : $inserted');
      debugPrint('[LocalNotificationScheduler] Test notification in $delaySeconds s');
    }

    if (!inserted) {
      throw StateError(
        'Test notification scheduling reported success but id=$testNotificationId was not found in pending notifications.',
      );
    }
  }

  /// Cancel a list of IDs.
  Future<void> cancelIds(List<int> ids) async {
    if (kIsWeb) return;
    for (final id in ids) {
      await _plugin.cancel(id);
    }
  }

  NotificationDetails _buildDetails(String channelId) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelName(channelId),
        // Explicit icon on every notification — overrides the default so
        // there is no ambiguity even if initialization used a different icon.
        icon: 'ic_notification',
        importance: _channelImportance(channelId),
        priority: channelId == channelPrayers
            ? Priority.max
            : channelId == channelAdminCampaigns
                ? Priority.high
                : Priority.defaultPriority,
        playSound: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  String _channelName(String channelId) => switch (channelId) {
    channelPrayers   => 'Prayer Reminders',
    channelReminders => 'Lesson & Adhkar Reminders',
    channelAdminCampaigns => 'Announcements',
    _                => 'General Reminders',
  };

  Importance _channelImportance(String channelId) => switch (channelId) {
    channelPrayers   => Importance.max,
    channelReminders => Importance.defaultImportance,
    channelAdminCampaigns => Importance.high,
    _                => Importance.low,
  };
}
