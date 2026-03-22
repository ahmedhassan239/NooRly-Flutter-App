import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/app/router.dart';
import 'package:flutter_app/app/theme_provider.dart';
import 'package:flutter_app/core/deep_link/deep_link_handler.dart';
import 'package:flutter_app/core/notifications/notification_router.dart';
import 'package:flutter_app/core/notifications/notification_service.dart';
import 'package:flutter_app/core/notifications/pending_admin_campaign_sync.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/design_system/app_theme.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/notifications/providers/notification_preferences_providers.dart';
import 'package:flutter_app/features/settings/providers/settings_providers.dart';
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
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Apply saved locale to ApiClient immediately on startup so the very
      // first request already carries the correct Accept-Language header.
      final savedLocale = ref.read(localeControllerProvider);
      ref.read(apiClientProvider).setLocale(savedLocale);

      ref.read(authProvider.notifier).initialize();
      _handleInitialDeepLink();
      _listenToDeepLinks();

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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

  Future<void> _handleInitialDeepLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri == null) return;
      final path = parseResetPasswordPath(uri);
      if (path != null && mounted) {
        ref.read(routerProvider).go(path);
      }
    } catch (_) {}
  }

  void _listenToDeepLinks() {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri == null || !mounted) return;
      final path = parseResetPasswordPath(uri);
      if (path != null) {
        ref.read(routerProvider).go(path);
      }
    });
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

    // Keep ApiClient locale in sync and reschedule notifications when language changes.
    ref.listen<Locale>(localeControllerProvider, (prev, next) {
      ref.read(apiClientProvider).setLocale(next);
      if (!kIsWeb &&
          prev != null &&
          next.languageCode != prev.languageCode) {
        if (kDebugMode) {
          debugPrint('[App] Locale changed ${prev.languageCode} → ${next.languageCode}, rescheduling non-prayer notifications');
        }
        _rescheduleNonPrayerNotifications();
      }
    });

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
