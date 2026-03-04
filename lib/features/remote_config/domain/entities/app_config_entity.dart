/// App configuration entity for remote config.
library;

import 'package:flutter/foundation.dart';

/// App configuration from remote server.
/// Supports both legacy (home_sections, featured_banners) and backend App Settings
/// (settings map: features_enabled, default_locale, maintenance_mode, etc.).
@immutable
class AppConfigEntity {
  const AppConfigEntity({
    this.homeSections = const [],
    this.featuredBanners = const [],
    this.enabledModules = const {},
    this.appVersion,
    this.minAppVersion,
    this.maintenanceMode = false,
    this.maintenanceMessage,
    this.forceUpdate = false,
    this.updateUrl,
    // Backend App Settings (remote config) keys
    this.dailyContentRefreshHour = 0,
    this.featuredDuasCount = 5,
    this.featuredHadithCount = 5,
    this.featuresEnabled = const [],
    this.defaultLocale = 'en',
    this.supportedLocales = const ['en'],
    this.appName,
    this.maintenanceMessageMap,
    this.homeSectionsOrder = const [],
    this.showDailyVerse = true,
    this.showDailyHadith = true,
    this.showJourneyProgress = true,
    this.notificationsEnabled = true,
    this.prayerNotificationsDefault = true,
    this.defaultPrayerMethod = 2,
    this.defaultMadhab = 0,
  });

  /// Ordered list of home sections to display.
  final List<HomeSectionConfig> homeSections;

  /// Featured banners for home screen.
  final List<BannerConfig> featuredBanners;

  /// Enabled/disabled modules per locale.
  /// Key: module name, Value: list of enabled locales (empty = all).
  final Map<String, List<String>> enabledModules;

  /// Current app version from server.
  final String? appVersion;

  /// Minimum required app version.
  final String? minAppVersion;

  /// Whether app is in maintenance mode.
  final bool maintenanceMode;

  /// Maintenance message to display (plain string).
  final String? maintenanceMessage;

  /// Maintenance message per locale (from JSON). Used when backend sends { "en": "...", "ar": "..." }.
  final Map<String, String>? maintenanceMessageMap;

  /// Whether to force update.
  final bool forceUpdate;

  /// URL to update the app.
  final String? updateUrl;

  // --- Backend App Settings (remote config) ---

  /// Hour of day (0–23) for daily content refresh.
  final int dailyContentRefreshHour;

  /// Number of featured duas to show.
  final int featuredDuasCount;

  /// Number of featured hadith to show.
  final int featuredHadithCount;

  /// Feature slugs enabled (e.g. lessons, duas, hadith, quran, adhkar, prayer_times).
  final List<String> featuresEnabled;

  /// Default locale (e.g. en, ar).
  final String defaultLocale;

  /// Supported locale codes.
  final List<String> supportedLocales;

  /// App display name.
  final String? appName;

  /// Ordered list of home section ids (from home_sections_order).
  final List<String> homeSectionsOrder;

  /// Show daily verse section on home.
  final bool showDailyVerse;

  /// Show daily hadith section on home.
  final bool showDailyHadith;

  /// Show journey progress on home.
  final bool showJourneyProgress;

  /// Master switch for notifications.
  final bool notificationsEnabled;

  /// Default for prayer reminders (remote default).
  final bool prayerNotificationsDefault;

  /// Default prayer calculation method (backend integer id).
  final int defaultPrayerMethod;

  /// Default madhab (backend integer id).
  final int defaultMadhab;

  /// Whether a feature slug is enabled.
  bool isFeatureEnabled(String slug) =>
      featuresEnabled.any((s) => s.toLowerCase() == slug.toLowerCase());

  /// Check if a module is enabled for a locale.
  bool isModuleEnabled(String module, String locale) {
    if (!enabledModules.containsKey(module)) return true;
    final locales = enabledModules[module]!;
    if (locales.isEmpty) return true;
    return locales.contains(locale);
  }

  /// Get visible home sections.
  List<HomeSectionConfig> get visibleSections =>
      homeSections.where((s) => s.visible).toList();

  /// Get active banners.
  List<BannerConfig> get activeBanners =>
      featuredBanners.where((b) => b.isActive).toList();

  /// Resolve maintenance message for a locale (from map or plain string).
  String? getMaintenanceMessage(String locale) {
    if (maintenanceMessageMap != null) {
      final msg = maintenanceMessageMap![locale] ?? maintenanceMessageMap!['en'];
      if (msg != null && msg.isNotEmpty) return msg;
    }
    return maintenanceMessage;
  }

  @override
  String toString() =>
      'AppConfigEntity(sections: ${homeSections.length}, features: $featuresEnabled, maintenance: $maintenanceMode)';
}

/// Home section configuration.
@immutable
class HomeSectionConfig {
  const HomeSectionConfig({
    required this.id,
    required this.type,
    this.title,
    this.titleAr,
    this.order = 0,
    this.visible = true,
    this.data,
  });

  /// Section identifier.
  final String id;

  /// Section type (e.g., 'daily_verse', 'progress', 'quick_actions', 'featured').
  final String type;

  /// Section title (English).
  final String? title;

  /// Section title (Arabic).
  final String? titleAr;

  /// Display order.
  final int order;

  /// Whether section is visible.
  final bool visible;

  /// Additional section data.
  final Map<String, dynamic>? data;

  /// Get localized title.
  String getTitle(String locale) {
    if (locale == 'ar' && titleAr != null) return titleAr!;
    return title ?? id;
  }
}

/// Banner configuration.
@immutable
class BannerConfig {
  const BannerConfig({
    required this.id,
    required this.imageUrl,
    this.title,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.actionUrl,
    this.actionType,
    this.startDate,
    this.endDate,
    this.priority = 0,
  });

  /// Banner identifier.
  final String id;

  /// Banner image URL.
  final String imageUrl;

  /// Banner title (English).
  final String? title;

  /// Banner title (Arabic).
  final String? titleAr;

  /// Banner subtitle (English).
  final String? subtitle;

  /// Banner subtitle (Arabic).
  final String? subtitleAr;

  /// Action URL when banner is tapped.
  final String? actionUrl;

  /// Action type (e.g., 'deeplink', 'webview', 'external').
  final String? actionType;

  /// Start date for banner visibility.
  final DateTime? startDate;

  /// End date for banner visibility.
  final DateTime? endDate;

  /// Display priority (higher = more prominent).
  final int priority;

  /// Check if banner is currently active.
  bool get isActive {
    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    return true;
  }

  /// Get localized title.
  String? getTitle(String locale) {
    if (locale == 'ar' && titleAr != null) return titleAr;
    return title;
  }

  /// Get localized subtitle.
  String? getSubtitle(String locale) {
    if (locale == 'ar' && subtitleAr != null) return subtitleAr;
    return subtitle;
  }
}
