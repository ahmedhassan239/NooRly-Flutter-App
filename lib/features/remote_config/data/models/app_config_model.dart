/// App configuration model for API serialization.
///
/// Backend GET /app-config returns { status, message, data } where
/// data = { settings: { key: value, ... }, home_sections: [ ... ], locale, server_time }.
library;

import 'package:flutter_app/features/remote_config/domain/entities/app_config_entity.dart';

/// App configuration model.
class AppConfigModel extends AppConfigEntity {
  const AppConfigModel({
    super.homeSections,
    super.featuredBanners,
    super.enabledModules,
    super.appVersion,
    super.minAppVersion,
    super.maintenanceMode,
    super.maintenanceMessage,
    super.forceUpdate,
    super.updateUrl,
    super.dailyContentRefreshHour,
    super.featuredDuasCount,
    super.featuredHadithCount,
    super.featuresEnabled,
    super.defaultLocale,
    super.supportedLocales,
    super.appName,
    super.maintenanceMessageMap,
    super.homeSectionsOrder,
    super.showDailyVerse,
    super.showDailyHadith,
    super.showJourneyProgress,
    super.notificationsEnabled,
    super.prayerNotificationsDefault,
    super.defaultPrayerMethod,
    super.defaultMadhab,
  });

  /// Parse from API response data (data.settings + data.home_sections).
  /// Handles wrapper safely: if [json] has no [settings], falls back to legacy top-level keys.
  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('settings') || json.containsKey('home_sections')) {
      return AppConfigModel.fromAppConfigData(json);
    }
    return _fromLegacyJson(json);
  }

  /// Parse backend app-config data: { settings: { ... }, home_sections: [ ... ] }.
  factory AppConfigModel.fromAppConfigData(Map<String, dynamic> data) {
    final settings = (data['settings'] as Map<String, dynamic>?) ?? {};
    final homeSectionsRaw = data['home_sections'] as List<dynamic>?;
    final homeSections = homeSectionsRaw
            ?.map((e) => HomeSectionModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return AppConfigModel(
      homeSections: homeSections,
      featuredBanners: const [],
      enabledModules: const {},
      appVersion: _str(settings, 'app_version'),
      minAppVersion: _str(settings, 'min_app_version'),
      maintenanceMode: _bool(settings, 'maintenance_mode', false),
      maintenanceMessage: _str(settings, 'maintenance_message'),
      maintenanceMessageMap: _maintenanceMessageMap(settings['maintenance_message']),
      forceUpdate: _bool(settings, 'force_update', false),
      updateUrl: _str(settings, 'update_url'),
      dailyContentRefreshHour: _int(settings, 'daily_content_refresh_hour', 0),
      featuredDuasCount: _int(settings, 'featured_duas_count', 5),
      featuredHadithCount: _int(settings, 'featured_hadith_count', 5),
      featuresEnabled: _stringList(settings, 'features_enabled'),
      defaultLocale: _str(settings, 'default_locale') ?? 'en',
      supportedLocales: _stringList(settings, 'supported_locales').isNotEmpty
          ? _stringList(settings, 'supported_locales')
          : ['en'],
      appName: _str(settings, 'app_name'),
      homeSectionsOrder: _stringList(settings, 'home_sections_order'),
      showDailyVerse: _bool(settings, 'show_daily_verse', true),
      showDailyHadith: _bool(settings, 'show_daily_hadith', true),
      showJourneyProgress: _bool(settings, 'show_journey_progress', true),
      notificationsEnabled: _bool(settings, 'notifications_enabled', true),
      prayerNotificationsDefault: _bool(settings, 'prayer_notifications_default', true),
      defaultPrayerMethod: _int(settings, 'default_prayer_method', 2),
      defaultMadhab: _int(settings, 'default_madhab', 0),
    );
  }

  static AppConfigModel _fromLegacyJson(Map<String, dynamic> json) {
    return AppConfigModel(
      homeSections: (json['home_sections'] as List<dynamic>?)
              ?.map((e) => HomeSectionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      featuredBanners: (json['featured_banners'] as List<dynamic>?)
              ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      enabledModules: (json['enabled_modules'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>?)?.cast<String>() ?? [],
            ),
          ) ??
          {},
      appVersion: json['app_version'] as String?,
      minAppVersion: json['min_app_version'] as String?,
      maintenanceMode: json['maintenance_mode'] as bool? ?? false,
      maintenanceMessage: json['maintenance_message'] as String?,
      forceUpdate: json['force_update'] as bool? ?? false,
      updateUrl: json['update_url'] as String?,
    );
  }

  static String? _str(Map<String, dynamic> m, String key) {
    final v = m[key];
    if (v == null) return null;
    return v is String ? v : v.toString();
  }

  static bool _bool(Map<String, dynamic> m, String key, bool def) {
    final v = m[key];
    if (v == null) return def;
    if (v is bool) return v;
    if (v is int) return v != 0;
    if (v is String) return v.toLowerCase() == 'true' || v == '1';
    return def;
  }

  static int _int(Map<String, dynamic> m, String key, int def) {
    final v = m[key];
    if (v == null) return def;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? def;
    return def;
  }

  static List<String> _stringList(Map<String, dynamic> m, String key) {
    final v = m[key];
    if (v == null) return [];
    if (v is List) return v.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    if (v is String) return v.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    return [];
  }

  static Map<String, String>? _maintenanceMessageMap(dynamic v) {
    if (v == null) return null;
    if (v is Map) {
      return v.map((key, val) => MapEntry(key.toString(), val?.toString() ?? ''));
    }
    return null;
  }

  /// Convert to JSON (same shape as API data for cache).
  Map<String, dynamic> toJson() {
    return {
      'settings': {
        'app_version': appVersion,
        'min_app_version': minAppVersion,
        'maintenance_mode': maintenanceMode,
        'maintenance_message': maintenanceMessage,
        'force_update': forceUpdate,
        'update_url': updateUrl,
        'daily_content_refresh_hour': dailyContentRefreshHour,
        'featured_duas_count': featuredDuasCount,
        'featured_hadith_count': featuredHadithCount,
        'features_enabled': featuresEnabled,
        'default_locale': defaultLocale,
        'supported_locales': supportedLocales,
        'app_name': appName,
        'home_sections_order': homeSectionsOrder,
        'show_daily_verse': showDailyVerse,
        'show_daily_hadith': showDailyHadith,
        'show_journey_progress': showJourneyProgress,
        'notifications_enabled': notificationsEnabled,
        'prayer_notifications_default': prayerNotificationsDefault,
        'default_prayer_method': defaultPrayerMethod,
        'default_madhab': defaultMadhab,
      },
      'home_sections': homeSections
          .map((e) => (e as HomeSectionModel).toJson())
          .toList(),
    };
  }

  /// Convert to entity.
  AppConfigEntity toEntity() {
    return AppConfigEntity(
      homeSections: homeSections,
      featuredBanners: featuredBanners,
      enabledModules: enabledModules,
      appVersion: appVersion,
      minAppVersion: minAppVersion,
      maintenanceMode: maintenanceMode,
      maintenanceMessage: maintenanceMessage,
      maintenanceMessageMap: maintenanceMessageMap,
      forceUpdate: forceUpdate,
      updateUrl: updateUrl,
      dailyContentRefreshHour: dailyContentRefreshHour,
      featuredDuasCount: featuredDuasCount,
      featuredHadithCount: featuredHadithCount,
      featuresEnabled: featuresEnabled,
      defaultLocale: defaultLocale,
      supportedLocales: supportedLocales,
      appName: appName,
      homeSectionsOrder: homeSectionsOrder,
      showDailyVerse: showDailyVerse,
      showDailyHadith: showDailyHadith,
      showJourneyProgress: showJourneyProgress,
      notificationsEnabled: notificationsEnabled,
      prayerNotificationsDefault: prayerNotificationsDefault,
      defaultPrayerMethod: defaultPrayerMethod,
      defaultMadhab: defaultMadhab,
    );
  }
}

/// Home section model.
class HomeSectionModel extends HomeSectionConfig {
  const HomeSectionModel({
    required super.id,
    required super.type,
    super.title,
    super.titleAr,
    super.order,
    super.visible,
    super.data,
  });

  factory HomeSectionModel.fromJson(Map<String, dynamic> json) {
    return HomeSectionModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      order: json['order'] as int? ?? 0,
      visible: json['visible'] as bool? ?? true,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'title_ar': titleAr,
      'order': order,
      'visible': visible,
      'data': data,
    };
  }
}

/// Banner model.
class BannerModel extends BannerConfig {
  const BannerModel({
    required super.id,
    required super.imageUrl,
    super.title,
    super.titleAr,
    super.subtitle,
    super.subtitleAr,
    super.actionUrl,
    super.actionType,
    super.startDate,
    super.endDate,
    super.priority,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['image'] as String? ?? '',
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      subtitle: json['subtitle'] as String?,
      subtitleAr: json['subtitle_ar'] as String?,
      actionUrl: json['action_url'] as String?,
      actionType: json['action_type'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'] as String)
          : null,
      priority: json['priority'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'title': title,
      'title_ar': titleAr,
      'subtitle': subtitle,
      'subtitle_ar': subtitleAr,
      'action_url': actionUrl,
      'action_type': actionType,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'priority': priority,
    };
  }
}
