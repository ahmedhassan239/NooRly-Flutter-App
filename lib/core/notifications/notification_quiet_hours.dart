/// Quiet hours check utility.
///
/// Returns true when the given time falls within the user's quiet hours.
/// Prayer notifications are always exempt.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';

class NotificationQuietHours {
  static bool isQuietTime(
    NotificationPreferencesEntity prefs,
    DateTime at, {
    bool isPrayer = false,
  }) {
    // Prayer bypasses quiet hours
    if (isPrayer) return false;
    if (!prefs.quietHoursEnabled) return false;

    final start = prefs.effectiveQuietStart;
    final end   = prefs.effectiveQuietEnd;

    final checkMinutes = at.hour * 60 + at.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes   = end.hour * 60 + end.minute;

    // Overnight range: e.g. 23:00 → 05:00
    if (startMinutes > endMinutes) {
      return checkMinutes >= startMinutes || checkMinutes < endMinutes;
    }

    // Same-day range
    return checkMinutes >= startMinutes && checkMinutes < endMinutes;
  }

  static bool isQuietNow(
    NotificationPreferencesEntity prefs, {
    bool isPrayer = false,
  }) {
    return isQuietTime(prefs, DateTime.now(), isPrayer: isPrayer);
  }
}
