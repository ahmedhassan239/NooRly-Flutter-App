/// Low-level flutter_local_notifications wrapper.
///
/// All scheduling goes through this class.
/// On web: all methods are no-ops (kIsWeb guard).
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  // --- Channel IDs ---
  static const String channelPrayers   = 'noorly_prayers';
  static const String channelReminders = 'noorly_reminders';
  static const String channelLow       = 'noorly_low';

  /// Initialize the plugin and timezone data.
  Future<bool> initialize({void Function(NotificationPayload payload)? onTap}) async {
    if (kIsWeb) return false;
    if (_initialized) return true;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

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

    await _createAndroidChannels();
    _initialized = result ?? false;
    return _initialized;
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

  /// Schedule a notification at an exact local datetime.
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String channelId,
    String? payload,
    bool repeating = false,
    RepeatInterval? repeatInterval,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) return;

    final tz.TZDateTime tzTime = tz.TZDateTime.from(scheduledAt, tz.local);

    final notifDetails = _buildDetails(channelId);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      notifDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
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
  }) async {
    if (kIsWeb) return;
    if (!_initialized) return;

    final now    = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _buildDetails(channelId),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
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
  }) async {
    if (kIsWeb) return;
    if (!_initialized) return;

    final now       = tz.TZDateTime.now(tz.local);
    var scheduled   = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    // Advance to the next target weekday
    while (scheduled.weekday != dayOfWeek.value) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _buildDetails(channelId),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: payload,
    );
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
        importance: _channelImportance(channelId),
        priority: channelId == channelPrayers ? Priority.max : Priority.defaultPriority,
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
    _                => 'General Reminders',
  };

  Importance _channelImportance(String channelId) => switch (channelId) {
    channelPrayers   => Importance.max,
    channelReminders => Importance.defaultImportance,
    _                => Importance.low,
  };
}
