import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/app/router.dart';
import 'package:flutter_app/app/theme_provider.dart';
import 'package:flutter_app/core/notifications/notification_router.dart';
import 'package:flutter_app/core/notifications/notification_service.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/notifications/pending_admin_campaign_sync.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/adhkar/providers/adhkar_by_category_id_provider.dart';
import 'package:flutter_app/features/duas/providers/duas_providers.dart' as duas_providers;
import 'package:flutter_app/features/profile/providers/profile_providers.dart';
import 'package:flutter_app/features/remote_config/providers/remote_config_provider.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_app/design_system/app_theme.dart';
import 'package:flutter_app/design_system/widgets/app_pattern_background.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/home/providers/home_providers.dart' as home_providers;
import 'package:flutter_app/features/journey/providers/journey_providers.dart' as journey_providers;
import 'package:flutter_app/features/lessons/providers/lessons_providers.dart' as lessons_providers;
import 'package:flutter_app/features/notifications/providers/notification_preferences_providers.dart';
import 'package:flutter_app/features/settings/providers/settings_providers.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart'
    as library_providers;
import 'package:flutter_app/core/content/providers/content_providers.dart'
    as content_providers;
import 'package:flutter_app/core/content/providers/content_scope_providers.dart'
    as content_scope_providers;
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  ProviderSubscription<Locale>? _localeSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localeSubscription = ref.listenManual<Locale>(
      localeControllerProvider,
      _onLocaleChanged,
      fireImmediately: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Apply saved locale to ApiClient immediately on startup so the very
      // first request already carries the correct Accept-Language header.
      final savedLocale = ref.read(localeControllerProvider);
      ref.read(apiClientProvider).setLocale(savedLocale);

      ref.read(authProvider.notifier).initialize();

      // Wire NotificationRouter to the GoRouter so notification taps can navigate.
      if (!kIsWeb) {
        final router = ref.read(routerProvider);
        NotificationRouter.instance.init(router);
        final api = ref.read(apiClientProvider);
        PendingAdminCampaignBridge.instance.attachClient(api);
        // Flush any notification tap that happened during cold start.
        NotificationService.instance.flushPendingTap();

        // Reschedule non-prayer notifications (adhkar, lesson, Friday) using
        // cached preferences so they work immediately on every app launch.
        _rescheduleNonPrayerNotifications();
      }
    });
  }

  @override
  void dispose() {
    _localeSubscription?.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onLocaleChanged(Locale? previous, Locale next) {
    ref.read(apiClientProvider).setLocale(next);
    if (kDebugMode) {
      final prevCode = previous?.languageCode ?? 'none';
      debugPrint('[App] Locale in memory: $prevCode -> ${next.languageCode}');
    }

    if (previous == null || previous.languageCode == next.languageCode) return;

    unawaited(_applyRuntimeLanguageChange());
    if (!kIsWeb) {
      _rescheduleNonPrayerNotifications();
    }
  }

  /// Clears non-locale-keyed Hive payloads, then invalidates providers so UI refetches
  /// with the updated [Accept-Language] header (see [LocaleInterceptor]).
  Future<void> _applyRuntimeLanguageChange() async {
    await CacheManager.clearLocaleSensitiveApiCache();
    if (!mounted) return;
    _invalidateLocaleSensitiveProviders();
  }

  void _invalidateLocaleSensitiveProviders() {
    if (kDebugMode) {
      debugPrint('[App] Invalidating locale-sensitive providers for immediate refetch');
    }

    ref
      ..invalidate(home_providers.homeDashboardProvider)
      ..invalidate(home_providers.dailyInspirationProvider)
      ..invalidate(journey_providers.journeyProvider)
      ..invalidate(journey_providers.todayLessonProvider)
      ..invalidate(journey_providers.journeySummaryProvider)
      ..invalidate(lessons_providers.lessonByIdProvider)
      ..invalidate(content_scope_providers.contentScopesProvider)
      ..invalidate(content_providers.allDuasProvider)
      ..invalidate(content_providers.duasCategoriesProvider)
      ..invalidate(content_providers.duasByCategoryProvider)
      ..invalidate(content_providers.duaDetailProvider)
      ..invalidate(content_providers.savedDuasProvider)
      ..invalidate(content_providers.searchDuasProvider)
      ..invalidate(content_providers.allHadithProvider)
      ..invalidate(content_providers.hadithCategoriesProvider)
      ..invalidate(content_providers.hadithByCategoryProvider)
      ..invalidate(content_providers.hadithDetailProvider)
      ..invalidate(content_providers.savedHadithProvider)
      ..invalidate(content_providers.searchHadithProvider)
      ..invalidate(content_providers.allVersesProvider)
      ..invalidate(content_providers.versesCategoriesProvider)
      ..invalidate(content_providers.versesByCategoryProvider)
      ..invalidate(content_providers.verseDetailProvider)
      ..invalidate(content_providers.savedVersesProvider)
      ..invalidate(content_providers.searchVersesProvider)
      ..invalidate(content_providers.allAdhkarProvider)
      ..invalidate(content_providers.adhkarCategoriesProvider)
      ..invalidate(content_providers.adhkarByCategoryProvider)
      ..invalidate(content_providers.dhikrDetailProvider)
      ..invalidate(content_providers.savedAdhkarProvider)
      ..invalidate(library_providers.libraryTabsProvider)
      ..invalidate(library_providers.libraryCategoriesProvider)
      ..invalidate(library_providers.libraryAdhkarCategoriesProvider)
      ..invalidate(library_providers.libraryCollectionsProvider)
      ..invalidate(library_providers.libraryCollectionDetailsProvider)
      ..invalidate(library_providers.hadithCollectionsAllProvider)
      ..invalidate(library_providers.hadithCategoriesProvider)
      ..invalidate(library_providers.hadithCollectionsByCategoryProvider)
      ..invalidate(library_providers.hadithCollectionDetailsProvider)
      ..invalidate(duas_providers.duaCategoriesFromApiProvider)
      ..invalidate(adhkarByCategoryIdProvider)
      ..invalidate(savedAllListProvider)
      ..invalidate(savedHadithListProvider)
      ..invalidate(savedVerseListProvider)
      ..invalidate(savedAdhkarListProvider)
      ..invalidate(savedDuaListProvider)
      ..invalidate(savedLessonListProvider)
      ..invalidate(savedHadithIdsProvider)
      ..invalidate(savedVerseIdsProvider)
      ..invalidate(savedAdhkarIdsProvider)
      ..invalidate(savedDuaIdsProvider)
      ..invalidate(savedLessonIdsProvider)
      ..invalidate(appConfigProvider)
      ..invalidate(profileProvider);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !kIsWeb) {
      final auth = ref.read(authProvider);
      if (auth.isAuthenticated) {
        final client = ref.read(apiClientProvider);
        unawaited(pullAndShowAdminCampaignNotifications(client));
      }
    }
  }

  void _syncAdminCampaignsIfAuthenticated() {
    if (kIsWeb) return;
    final auth = ref.read(authProvider);
    if (!auth.isAuthenticated) return;
    final client = ref.read(apiClientProvider);
    unawaited(pullAndShowAdminCampaignNotifications(client));
  }

  Future<void> _rescheduleNonPrayerNotifications() async {
    try {
      final repo = ref.read(notificationPreferencesRepositoryProvider);
      final prefs = await repo.getLocalPreferences();
      final appLocale = ref.read(localeControllerProvider).languageCode;
      await NotificationService.instance.rescheduleNonPrayer(
        prefs,
        appLocale: appLocale,
      );
      if (kDebugMode) {
        debugPrint('[App] Startup: non-prayer notifications rescheduled (locale=$appLocale)');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[App] Startup reschedule error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeControllerProvider);
    final textScale = ref.watch(textScaleFactorProvider);

    ref.listen(authProvider, (prev, next) {
      if (next.isAuthenticated && (prev == null || !prev.isAuthenticated)) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _syncAdminCampaignsIfAuthenticated());
      }
      if (!next.isAuthenticated) {
        PendingAdminCampaignBridge.instance.attachClient(null);
      } else {
        PendingAdminCampaignBridge.instance.attachClient(ref.read(apiClientProvider));
      }
    });

    if (kDebugMode) {
      debugPrint('[App] build: applying textScale=$textScale (root)');
    }

    // Apply font scale at the root so it wraps the entire app. Wrapping outside
    // MaterialApp ensures every route inherits this textScaler; the builder
    // approach can be overridden by the router in some cases.
    final views = WidgetsBinding.instance.platformDispatcher.views;
    final view = views.isNotEmpty ? views.first : null;
    final baseData = view != null
        ? MediaQueryData.fromView(view)
        : const MediaQueryData();
    final mediaData = baseData.copyWith(
      textScaler: TextScaler.linear(textScale),
    );

    return MediaQuery(
      data: mediaData,
      child: OverlaySupport.global(
        child: MaterialApp.router(
          title: 'Noor Journey',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: ref.watch(routerProvider),
          locale: locale,
          builder: (context, child) =>
              AppPatternBackground(child: child),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
