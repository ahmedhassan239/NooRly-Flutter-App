import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/app/router.dart';
import 'package:flutter_app/app/theme_provider.dart';
import 'package:flutter_app/core/deep_link/deep_link_handler.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/design_system/app_theme.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Apply saved locale to ApiClient immediately on startup so the very
      // first request already carries the correct Accept-Language header.
      final savedLocale = ref.read(localeControllerProvider);
      ref.read(apiClientProvider).setLocale(savedLocale);

      ref.read(authProvider.notifier).initialize();
      _handleInitialDeepLink();
      _listenToDeepLinks();
    });
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

    // Keep ApiClient locale in sync whenever the user switches language.
    ref.listen<Locale>(localeControllerProvider, (_, next) {
      ref.read(apiClientProvider).setLocale(next);
    });

    return OverlaySupport.global(
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
    );
  }
}
