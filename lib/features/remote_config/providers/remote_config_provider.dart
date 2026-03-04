/// Remote config providers.
///
/// appConfigProvider: cache-first, then refresh in background. Derived providers
/// for maintenance, features, locales, home sections, and settings UI.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/remote_config/data/repositories/remote_config_repository_impl.dart';
import 'package:flutter_app/features/remote_config/domain/entities/app_config_entity.dart';
import 'package:flutter_app/features/remote_config/domain/repositories/remote_config_repository.dart';

/// Remote config repository provider.
final remoteConfigRepositoryProvider = Provider<RemoteConfigRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RemoteConfigRepositoryImpl(apiClient: apiClient);
});

/// App config provider - cache-first, then refresh in background.
/// TTL is handled by cache; on failure keeps cached data.
final appConfigProvider = FutureProvider<AppConfigEntity>((ref) async {
  final repository = ref.watch(remoteConfigRepositoryProvider);

  final cached = await repository.getCachedConfig();
  if (cached != null) {
    if (kDebugMode) {
      print('[RemoteConfig] appConfigProvider: serving cached config, refreshing in background');
    }
    repository.getAppConfig().then((fresh) {
      if (kDebugMode) {
        print('[RemoteConfig] appConfigProvider: background refresh done, features => ${fresh.featuresEnabled}');
      }
    }).catchError((_) {});
    return cached;
  }

  return repository.getAppConfig();
});

/// Home sections provider (ordered by home_sections_order when available).
final homeSectionsProvider = Provider<List<HomeSectionConfig>>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) {
      final order = config.homeSectionsOrder;
      final sections = config.visibleSections;
      if (order.isEmpty) return sections;
      final orderMap = {for (var i = 0; i < order.length; i++) order[i].toLowerCase(): i};
      final sorted = List<HomeSectionConfig>.from(sections)
        ..sort((a, b) {
          final ai = orderMap[ a.id.toLowerCase()] ?? order.length;
          final bi = orderMap[b.id.toLowerCase()] ?? order.length;
          return ai.compareTo(bi);
        });
      return sorted;
    },
    orElse: () => _defaultHomeSections,
  );
});

/// Featured banners provider.
final featuredBannersProvider = Provider<List<BannerConfig>>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.activeBanners,
    orElse: () => [],
  );
});

/// Maintenance mode provider.
final maintenanceModeProvider = Provider<bool>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.maintenanceMode,
    orElse: () => false,
  );
});

/// Maintenance message (localized). Use current locale in UI.
final maintenanceMessageProvider = Provider<String?>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.maintenanceMessage ?? config.getMaintenanceMessage('en'),
    orElse: () => null,
  );
});

/// Enabled feature slugs (lessons, duas, hadith, quran, adhkar, prayer_times).
final enabledFeaturesProvider = Provider<List<String>>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.featuresEnabled,
    orElse: () => ['lessons', 'duas', 'hadith', 'quran', 'adhkar', 'prayer_times'],
  );
});

/// Whether a feature is enabled (e.g. 'prayer_times', 'duas').
final isFeatureEnabledProvider = Provider.family<bool, String>((ref, slug) {
  final list = ref.watch(enabledFeaturesProvider);
  return list.any((s) => s.toLowerCase() == slug.toLowerCase());
});

/// Library tab is visible if any of duas, hadith, quran, adhkar is enabled.
final isLibraryFeatureEnabledProvider = Provider<bool>((ref) {
  for (final slug in ['duas', 'hadith', 'quran', 'adhkar']) {
    if (ref.watch(isFeatureEnabledProvider(slug))) return true;
  }
  return false;
});

/// Supported locales (e.g. ['en', 'ar']).
final supportedLocalesProvider = Provider<List<String>>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.supportedLocales,
    orElse: () => ['en'],
  );
});

/// Default locale from remote config.
final defaultLocaleConfigProvider = Provider<String>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.defaultLocale,
    orElse: () => 'en',
  );
});

/// Home sections order (list of section ids).
final homeSectionsOrderProvider = Provider<List<String>>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.homeSectionsOrder,
    orElse: () => [],
  );
});

/// Show daily verse on home.
final showDailyVerseProvider = Provider<bool>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.showDailyVerse,
    orElse: () => true,
  );
});

/// Show daily hadith on home.
final showDailyHadithProvider = Provider<bool>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.showDailyHadith,
    orElse: () => true,
  );
});

/// Show journey progress on home.
final showJourneyProgressProvider = Provider<bool>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.showJourneyProgress,
    orElse: () => true,
  );
});

/// Notifications master switch from remote config.
final notificationsEnabledConfigProvider = Provider<bool>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.notificationsEnabled,
    orElse: () => true,
  );
});

/// Prayer notifications default from remote config.
final prayerNotificationsDefaultProvider = Provider<bool>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.prayerNotificationsDefault,
    orElse: () => true,
  );
});

/// Default prayer method (backend id).
final defaultPrayerMethodConfigProvider = Provider<int>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.defaultPrayerMethod,
    orElse: () => 2,
  );
});

/// Default madhab (backend id).
final defaultMadhabConfigProvider = Provider<int>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.defaultMadhab,
    orElse: () => 0,
  );
});

/// App name from remote config.
final appNameConfigProvider = Provider<String>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.appName ?? 'NooRly',
    orElse: () => 'NooRly',
  );
});

/// App version from remote config.
final appVersionConfigProvider = Provider<String>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.appVersion ?? '1.0.0',
    orElse: () => '1.0.0',
  );
});

/// Featured duas count for home.
final featuredDuasCountProvider = Provider<int>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.featuredDuasCount,
    orElse: () => 5,
  );
});

/// Featured hadith count for home.
final featuredHadithCountProvider = Provider<int>((ref) {
  final configAsync = ref.watch(appConfigProvider);
  return configAsync.maybeWhen(
    data: (config) => config.featuredHadithCount,
    orElse: () => 5,
  );
});

/// Default home sections (fallback).
const _defaultHomeSections = [
  HomeSectionConfig(
    id: 'daily_verse',
    type: 'daily_verse',
    title: 'Daily Verse',
    titleAr: 'آية اليوم',
    order: 0,
  ),
  HomeSectionConfig(
    id: 'progress',
    type: 'progress',
    title: 'Your Progress',
    titleAr: 'تقدمك',
    order: 1,
  ),
  HomeSectionConfig(
    id: 'quick_actions',
    type: 'quick_actions',
    title: 'Quick Actions',
    titleAr: 'إجراءات سريعة',
    order: 2,
  ),
  HomeSectionConfig(
    id: 'featured',
    type: 'featured',
    title: 'Featured',
    titleAr: 'مميز',
    order: 3,
  ),
];
