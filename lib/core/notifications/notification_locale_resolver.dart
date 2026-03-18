/// Resolves the effective notification language from user preference and app locale.
library;

import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';

/// Supported notification language codes (matches app supported locales).
const List<String> supportedNotificationLocales = ['ar', 'en'];

/// Resolves the locale to use for notification title/body.
///
/// Priority:
/// 1. [NotificationLanguageMode.arabic] → always `ar`
/// 2. [NotificationLanguageMode.english] → always `en`
/// 3. [NotificationLanguageMode.appLocale] → [appLocaleCode] (current app language)
/// 4. [NotificationLanguageMode.both] → same as app locale (one notification in app language).
///    We do not schedule two notifications (AR + EN); we use the current app language only.
///
/// [appLocaleCode] should be the current app locale (e.g. from [Locale.languageCode]).
/// If [appLocaleCode] is not supported, falls back to `en`.
String resolveNotificationLocale(
  NotificationLanguageMode mode,
  String appLocaleCode,
) {
  switch (mode) {
    case NotificationLanguageMode.arabic:
      return 'ar';
    case NotificationLanguageMode.english:
      return 'en';
    case NotificationLanguageMode.appLocale:
    case NotificationLanguageMode.both:
      final code = appLocaleCode.toLowerCase();
      if (code == 'ar') return 'ar';
      return 'en';
  }
}
