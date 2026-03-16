import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:flutter_app/features/duas/presentation/pages/duas_hub_page.dart';
import 'package:flutter_app/features/duas/presentation/pages/saved_duas_page.dart';
import 'package:flutter_app/features/duas/presentation/screens/dua_category_details_screen.dart';
import 'package:flutter_app/features/hadith/presentation/pages/category_hadith_page.dart';
import 'package:flutter_app/features/hadith/presentation/pages/hadith_collection_page.dart';
import 'package:flutter_app/features/hadith/presentation/pages/hadith_detail_page.dart';
import 'package:flutter_app/features/hadith/presentation/pages/saved_hadith_page.dart';
import 'package:flutter_app/features/adhkar/presentation/pages/adhkar_detail_page.dart';
import 'package:flutter_app/features/adhkar/presentation/pages/category_adhkar_page.dart';
import 'package:flutter_app/features/adhkar/presentation/pages/adhkar_hub_page.dart';
import 'package:flutter_app/features/adhkar/presentation/pages/saved_adhkar_page.dart';
import 'package:flutter_app/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_app/features/auth/presentation/pages/register_email_page.dart';
import 'package:flutter_app/features/auth/presentation/pages/email_otp_screen.dart';
import 'package:flutter_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flutter_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:flutter_app/features/auth/presentation/pages/debug_auth_screen.dart';
import 'package:flutter_app/features/debug/presentation/pages/debug_network_screen.dart';
import 'package:flutter_app/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:flutter_app/features/home/presentation/pages/ramadan_guide_page.dart';
import 'package:flutter_app/features/need_help/need_help_page.dart';
import 'package:flutter_app/features/verses/presentation/pages/category_verses_page.dart';
import 'package:flutter_app/features/verses/presentation/pages/verse_collection_page.dart';
import 'package:flutter_app/features/verses/presentation/pages/verse_detail_page.dart';
import 'package:flutter_app/features/verses/presentation/pages/saved_verses_page.dart';
import 'package:flutter_app/features/verses/presentation/pages/verses_hub_page.dart';
import 'package:flutter_app/features/journey/presentation/pages/journey_page.dart';
import 'package:flutter_app/features/journey/presentation/pages/journey_saved_page.dart';
import 'package:flutter_app/features/lessons/presentation/screens/lesson_details_screen.dart';
import 'package:flutter_app/features/library/presentation/screens/collection_details_screen.dart';
import 'package:flutter_app/features/library/presentation/screens/collections_screen.dart';
import 'package:flutter_app/features/library/presentation/screens/hadith_collection_details_screen.dart';
import 'package:flutter_app/features/library/presentation/screens/hadith_collections_screen.dart';
import 'package:flutter_app/features/library/presentation/screens/library_screen.dart';
import 'package:flutter_app/features/library/presentation/screens/library_shell_screen.dart';
import 'package:flutter_app/features/adhkar/presentation/widgets/adhkar_tab_content.dart';
import 'package:flutter_app/features/duas/presentation/widgets/duas_tab_content.dart';
import 'package:flutter_app/features/library/presentation/widgets/hadith_tab_view.dart';
import 'package:flutter_app/features/verses/presentation/widgets/verses_tab_content.dart';
import 'package:flutter_app/features/not_found/presentation/pages/not_found_page.dart';
import 'package:flutter_app/features/onboarding/presentation/pages/about_you_page.dart';
import 'package:flutter_app/features/onboarding/presentation/pages/current_knowledge_page.dart';
import 'package:flutter_app/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:flutter_app/features/onboarding/presentation/pages/what_brings_you_page.dart';
import 'package:flutter_app/features/onboarding/presentation/pages/your_preferences_page.dart';
import 'package:flutter_app/features/onboarding/presentation/pages/your_starting_plan_page.dart';
import 'package:flutter_app/features/prayer/presentation/pages/prayer_times_page.dart';
import 'package:flutter_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:flutter_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_app/features/saved/presentation/pages/saved_items_page.dart';
import 'package:flutter_app/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_app/features/remote_config/presentation/pages/feature_disabled_page.dart';
import 'package:flutter_app/features/remote_config/presentation/pages/maintenance_page.dart';
import 'package:flutter_app/features/remote_config/providers/remote_config_provider.dart';
import 'package:go_router/go_router.dart';

// ============================================================================
// Route Names (for type-safe navigation)
// ============================================================================
abstract class AppRoutes {
  // Onboarding (new flow)
  static const String welcome = 'welcome';
  static const String onboardingAboutYou = 'onboarding-about-you';
  static const String onboardingKnowledge = 'onboarding-knowledge';
  static const String onboardingGoals = 'onboarding-goals';
  static const String onboardingPreferences = 'onboarding-preferences';
  static const String onboardingPlan = 'onboarding-plan';
  // Legacy (kept for redirect compatibility, unused)
  static const String shahadaDate = 'shahada-date';
  static const String learningGoals = 'learning-goals';
  static const String journeySummary = 'journey-summary';

  // Main
  static const String home = 'home';
  static const String journey = 'journey';
  static const String journeySaved = 'journey-saved';
  static const String lessonDetail = 'lesson-detail';
  static const String prayerTimes = 'prayer-times';
  static const String profile = 'profile';
  static const String settings = 'settings';
  static const String editProfile = 'edit-profile';
  static const String ramadan = 'ramadan';
  static const String support = 'support';
  static const String needHelp = 'need-help';

  // Duas
  static const String duasHub = 'duas-hub';
  static const String duaDetail = 'dua-detail';
  static const String duasCategory = 'duas-category';
  static const String duasSaved = 'duas-saved';

  // Hadith
  static const String hadithHub = 'hadith-hub';
  static const String hadithCategory = 'hadith-category';
  static const String hadithSaved = 'hadith-saved';

  // Verses
  static const String versesHub = 'verses-hub';
  static const String versesCategory = 'verses-category';
  static const String versesSaved = 'verses-saved';

  // Adhkar
  static const String adhkarHub = 'adhkar-hub';
  static const String adhkarCategory = 'adhkar-category';
  static const String adhkarSaved = 'adhkar-saved';

  // Saved (unified: All / Duas / Adhkar / Verses / Hadith)
  static const String saved = 'saved';

  // Library (unified tabs from API)
  static const String library = 'library';
  static const String libraryCategory = 'library-category';
  static const String libraryCollection = 'library-collection';

  // Error
  static const String notFound = 'not-found';
}

// ============================================================================
// Placeholder Page (for routes not yet implemented)
// ============================================================================
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(l10n.comingSoon),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: Text(l10n.goHome),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Router Observer (for debugging)
// ============================================================================
class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('[Router] PUSH: ${route.settings.name} (from: ${previousRoute?.settings.name})');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('[Router] POP: ${route.settings.name} (to: ${previousRoute?.settings.name})');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (kDebugMode) {
      print('[Router] REPLACE: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
    }
  }
}

// ============================================================================
// GoRouter Configuration
// ============================================================================
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Builds app routes (shared by static router and provider).
List<RouteBase> get _appRoutes => [
    // ========================================================================
    // Onboarding Routes (new 6-step flow)
    // ========================================================================
    GoRoute(
      path: '/',
      name: AppRoutes.welcome,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/onboarding/about-you',
      name: AppRoutes.onboardingAboutYou,
      builder: (context, state) => const AboutYouPage(),
    ),
    GoRoute(
      path: '/onboarding/knowledge',
      name: AppRoutes.onboardingKnowledge,
      builder: (context, state) => const CurrentKnowledgePage(),
    ),
    GoRoute(
      path: '/onboarding/goals',
      name: AppRoutes.onboardingGoals,
      builder: (context, state) => const WhatBringsYouPage(),
    ),
    GoRoute(
      path: '/onboarding/preferences',
      name: AppRoutes.onboardingPreferences,
      builder: (context, state) => const YourPreferencesPage(),
    ),
    GoRoute(
      path: '/onboarding/plan',
      name: AppRoutes.onboardingPlan,
      builder: (context, state) => const YourStartingPlanPage(),
    ),

    // ========================================================================
    // Maintenance (when backend maintenance_mode = true)
    // ========================================================================
    GoRoute(
      path: '/maintenance',
      name: 'maintenance',
      builder: (context, state) => const MaintenancePage(),
    ),
    GoRoute(
      path: '/feature-disabled',
      name: 'feature-disabled',
      builder: (context, state) {
        final feature = state.uri.queryParameters['feature'] ?? 'feature';
        final name = feature == 'prayer_times' ? 'Prayer times' : feature == 'library' ? 'Library' : feature == 'journey' ? 'Journey' : feature;
        return FeatureDisabledPage(featureName: name);
      },
    ),

    // ========================================================================
    // Auth Routes (/login, /register, /home - canonical; /auth/* kept for compatibility)
    // ========================================================================
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/reset-password',
      name: 'reset-password',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        final token = state.uri.queryParameters['token'] ?? '';
        return ResetPasswordPage(initialEmail: email.isEmpty ? null : email, initialToken: token.isEmpty ? null : token);
      },
    ),
    GoRoute(
      path: '/auth/register',
      name: 'auth-register',
      builder: (context, state) => const RegisterPage(),
      routes: [
        GoRoute(
          path: 'email',
          name: 'register-email',
          builder: (context, state) => const RegisterEmailPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/auth/login',
      name: 'auth-login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/auth/debug',
      name: 'debug-auth',
      builder: (context, state) => const DebugAuthScreen(),
      routes: [
        GoRoute(
          path: 'network',
          name: 'debug-network',
          builder: (context, state) => const DebugNetworkScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/auth/verify-email',
      name: 'verify-email',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return EmailOtpScreen(email: email);
      },
    ),

    // ========================================================================
    // Main App Routes
    // ========================================================================
    GoRoute(
      path: '/home',
      name: AppRoutes.home,
      builder: (context, state) => const HomeDashboardPage(),
    ),
    GoRoute(
      path: '/journey',
      name: AppRoutes.journey,
      builder: (context, state) => const JourneyPage(),
    ),
    GoRoute(
      path: '/journey/saved',
      name: AppRoutes.journeySaved,
      builder: (context, state) => const JourneySavedPage(),
    ),
    GoRoute(
      path: '/lessons/:id',
      name: AppRoutes.lessonDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '1';
        return LessonDetailsScreen(lessonId: id);
      },
    ),
    GoRoute(
      path: '/lesson/:dayNumber',
      name: 'lesson-by-day',
      builder: (context, state) {
        final dayNumber = state.pathParameters['dayNumber'] ?? '1';
        return LessonDetailsScreen(lessonId: 'day:$dayNumber');
      },
    ),
    GoRoute(
      path: '/prayer-times',
      name: AppRoutes.prayerTimes,
      builder: (context, state) => const PrayerTimesPage(),
    ),
    GoRoute(
      path: '/profile',
      name: AppRoutes.profile,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/saved',
      name: AppRoutes.saved,
      builder: (context, state) => const SavedItemsPage(),
    ),
    GoRoute(
      path: '/settings',
      name: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/edit-profile',
      name: AppRoutes.editProfile,
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/ramadan',
      name: AppRoutes.ramadan,
      builder: (context, state) => const RamadanGuidePage(),
    ),
    GoRoute(
      path: '/support',
      name: AppRoutes.support,
      builder: (context, state) =>
          PlaceholderPage(title: AppLocalizations.of(context)!.needHelp),
    ),
    GoRoute(
      path: '/need-help',
      name: AppRoutes.needHelp,
      builder: (context, state) => const NeedHelpPage(),
    ),
    GoRoute(
      path: '/help/:category/:topic',
      name: 'help-topic',
      builder: (context, state) {
        final path = state.uri.path;
        final title = helpPlaceholderTitle(path);
        return HelpPlaceholderScreen(title: title);
      },
    ),

    // ========================================================================
    // Library: StatefulShellRoute.indexedStack (4 tabs; state preserved)
    // /duas, /adhkar, /hadith, /verses — tab tap uses goBranch(index)
    // ========================================================================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return LibraryShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/duas',
              name: AppRoutes.duasHub,
              builder: (context, state) => const DuasTabContent(),
              routes: [
                GoRoute(
                  path: 'category/:categoryId',
                  name: AppRoutes.duasCategory,
                  builder: (context, state) {
                    final categoryId =
                        state.pathParameters['categoryId'] ?? 'unknown';
                    return DuaCategoryDetailsScreen(categoryId: categoryId);
                  },
                ),
                GoRoute(
                  path: 'saved',
                  name: AppRoutes.duasSaved,
                  builder: (context, state) =>
                      const SavedDuasPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/adhkar',
              name: AppRoutes.adhkarHub,
              builder: (context, state) => const AdhkarTabContent(),
              routes: [
                GoRoute(
                  path: 'category/:categoryId',
                  name: AppRoutes.adhkarCategory,
                  builder: (context, state) {
                    final categoryId =
                        state.pathParameters['categoryId'] ?? 'unknown';
                    return CategoryAdhkarPage(categoryId: categoryId);
                  },
                ),
                GoRoute(
                  path: 'saved',
                  name: AppRoutes.adhkarSaved,
                  builder: (context, state) => const SavedAdhkarPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/hadith',
              name: AppRoutes.hadithHub,
              builder: (context, state) => const HadithTabView(),
              routes: [
                GoRoute(
                  path: 'category/:categoryId',
                  name: AppRoutes.hadithCategory,
                  builder: (context, state) {
                    final categoryId =
                        state.pathParameters['categoryId'] ?? 'unknown';
                    return CategoryHadithPage(categoryId: categoryId);
                  },
                ),
                GoRoute(
                  path: 'collection/:collectionId',
                  name: 'hadith-collection',
                  builder: (context, state) {
                    final collectionId =
                        state.pathParameters['collectionId'] ?? '0';
                    return HadithCollectionPage(collectionId: collectionId);
                  },
                ),
                GoRoute(
                  path: 'saved',
                  name: AppRoutes.hadithSaved,
                  builder: (context, state) =>
                      const SavedHadithPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/verses',
              name: AppRoutes.versesHub,
              builder: (context, state) => const VersesTabContent(),
              routes: [
                GoRoute(
                  path: 'category/:categoryId',
                  name: AppRoutes.versesCategory,
                  builder: (context, state) {
                    final categoryId =
                        state.pathParameters['categoryId'] ?? 'unknown';
                    return CategoryVersesPage(categoryId: categoryId);
                  },
                ),
                GoRoute(
                  path: 'collection/:collectionId',
                  name: 'verse-collection',
                  builder: (context, state) {
                    final collectionId =
                        state.pathParameters['collectionId'] ?? '0';
                    return VerseCollectionPage(collectionId: collectionId);
                  },
                ),
                GoRoute(
                  path: 'saved',
                  name: AppRoutes.versesSaved,
                  builder: (context, state) =>
                      const SavedVersesPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/dua/:duaId',
      name: AppRoutes.duaDetail,
      builder: (context, state) {
        final duaId = state.pathParameters['duaId'] ?? 'unknown';
        return PlaceholderPage(title: 'Dua: $duaId');
      },
    ),
    GoRoute(
      path: '/hadith/:hadithId',
      name: 'hadith-detail',
      builder: (context, state) {
        final hadithId = state.pathParameters['hadithId'] ?? 'unknown';
        return HadithDetailPage(hadithId: hadithId);
      },
    ),
    GoRoute(
      path: '/adhkar/:adhkarId',
      name: 'adhkar-detail',
      builder: (context, state) {
        final adhkarId = state.pathParameters['adhkarId'] ?? 'unknown';
        return AdhkarDetailPage(adhkarId: adhkarId);
      },
    ),
    GoRoute(
      path: '/verses/:verseId',
      name: 'verse-detail',
      builder: (context, state) {
        final verseId = state.pathParameters['verseId'] ?? 'unknown';
        return VerseDetailPage(verseId: verseId);
      },
    ),

    // ========================================================================
    // Library (/library redirects via _redirect to /duas; /library/* for scope routes)
    // ========================================================================
    GoRoute(
      path: '/library/:scopeKey/category/:categoryId',
      name: AppRoutes.libraryCategory,
      builder: (context, state) {
        final scopeKey = state.pathParameters['scopeKey'] ?? '';
        final categoryId =
            int.tryParse(state.pathParameters['categoryId'] ?? '0') ?? 0;
        if (scopeKey == 'hadith') {
          return HadithCollectionsScreen(categoryId: categoryId);
        }
        return CollectionsScreen(
          scopeKey: scopeKey,
          categoryId: categoryId,
        );
      },
    ),
    GoRoute(
      path: '/library/:scopeKey/collection/:collectionId',
      name: AppRoutes.libraryCollection,
      builder: (context, state) {
        final scopeKey = state.pathParameters['scopeKey'] ?? '';
        final collectionId =
            int.tryParse(state.pathParameters['collectionId'] ?? '0') ?? 0;
        if (scopeKey == 'hadith') {
          return HadithCollectionDetailsScreen(collectionId: collectionId);
        }
        return CollectionDetailsScreen(
          scopeKey: scopeKey,
          collectionId: collectionId,
        );
      },
    ),

    // ========================================================================
    // Adhkar Routes — same Library shell (header + tabs + bottom nav)
    // ========================================================================
    // ========================================================================
    // Explicit 404 Route (optional, for direct /404 access)
    // ========================================================================
    GoRoute(
      path: '/404',
      name: AppRoutes.notFound,
      builder: (context, state) => const NotFoundPage(),
    ),
  ];

/// Paths that require authenticated user (no guest). Unauthenticated/guest -> redirect to "/".
bool _isProtectedRoute(String loc) {
  return loc.startsWith('/home') ||
      loc.startsWith('/profile') ||
      loc.startsWith('/saved') ||
      loc.startsWith('/journey') ||
      loc.startsWith('/prayer-times') ||
      loc.startsWith('/duas') ||
      loc.startsWith('/hadith') ||
      loc.startsWith('/verses') ||
      loc.startsWith('/adhkar') ||
      loc.startsWith('/library') ||
      loc.startsWith('/settings') ||
      loc.startsWith('/edit-profile') ||
      loc.startsWith('/lesson') ||
      loc.startsWith('/lessons');
}

/// Auth- and onboarding-aware redirect. Returns path to redirect to, or null.
/// - Maintenance mode: allow only /maintenance, /, /login, /register, /auth/*
/// - Authenticated on "/" or login/register -> /home
/// - Unauthenticated or guest on protected route -> /
String? _redirect(Ref ref, GoRouterState state) {
  final loc = state.matchedLocation;
  final maintenance = ref.read(maintenanceModeProvider);

  if (maintenance) {
    final allowed = loc == '/maintenance' || loc == '/' ||
        loc == '/login' || loc == '/register' ||
        loc == '/forgot-password' || loc.startsWith('/reset-password') ||
        loc.startsWith('/auth/');
    if (!allowed) return '/maintenance';
    return null;
  }

  final auth = ref.read(authProvider);

  if (kDebugMode) {
    print('[Router] ${state.matchedLocation} | auth=${auth.status}');
  }

  // /library -> first tab
  if (loc == '/library') return '/duas';

  // Feature gate: redirect to placeholder if route requires a disabled feature
  if (auth.status == AuthStatus.authenticated && auth.user != null) {
    if (loc.startsWith('/prayer') && !ref.read(isFeatureEnabledProvider('prayer_times'))) {
      return '/feature-disabled?feature=prayer_times';
    }
    if ((loc.startsWith('/journey') || loc.startsWith('/lesson') || loc.startsWith('/lessons')) &&
        !ref.read(isFeatureEnabledProvider('lessons'))) {
      return '/feature-disabled?feature=journey';
    }
    if ((loc.startsWith('/library') || loc.startsWith('/duas') || loc.startsWith('/hadith') ||
            loc.startsWith('/verses') || loc.startsWith('/adhkar')) &&
        !ref.read(isLibraryFeatureEnabledProvider)) {
      return '/feature-disabled?feature=library';
    }
  }

  final isLoginOrRegister = loc == '/login' || loc == '/register' ||
      loc.startsWith('/auth/login') || loc.startsWith('/auth/register');
  final isPasswordRecovery = loc == '/forgot-password' || loc.startsWith('/reset-password');
  final isPublicRoute = loc == '/' ||
      isLoginOrRegister ||
      isPasswordRecovery ||
      loc.startsWith('/auth/') ||
      loc.startsWith('/onboarding/');

  // Still loading or initial: no redirect
  if (auth.status == AuthStatus.initial || auth.status == AuthStatus.loading) {
    return null;
  }

  // Unauthenticated: redirect protected routes to welcome "/"
  if (auth.status == AuthStatus.unauthenticated) {
    if (isPublicRoute) return null;
    return '/';
  }

  // Guest: redirect protected routes to welcome "/" (guest cannot access /home etc.)
  if (auth.status == AuthStatus.guest) {
    if (_isProtectedRoute(loc)) return '/';
    return null;
  }

  // Authenticated: redirect "/" or login/register to /home (start at home, no back to welcome/auth)
  if (auth.status == AuthStatus.authenticated && auth.user != null) {
    if (loc == '/' || isLoginOrRegister) return '/home';

    final completed = auth.onboardingCompleted;
    final onboarding = auth.onboarding;

    if (completed) {
      if (loc.startsWith('/onboarding/')) return '/home';
      return null;
    }

    if (_isProtectedRoute(loc)) {
      return '/onboarding/about-you';
    }

    return null;
  }

  return null;
}

/// Router provider with auth redirect. Refreshes when auth state changes so redirect
/// runs again (e.g. after login -> /home, after logout -> /).
/// initialLocation '/' is correct: redirect will send authenticated users to /home.
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    observers: [RouterObserver()],
    redirect: (context, state) => _redirect(ref, state),
    errorBuilder: (context, state) {
      if (kDebugMode) {
        print('[Router] ERROR - Route not found: ${state.uri}');
      }
      return NotFoundPage(attemptedPath: state.uri.toString());
    },
    routes: _appRoutes,
  );

  ref.listen<AuthState>(authProvider, (_, __) => router.refresh());
  ref.listen(appConfigProvider, (_, __) => router.refresh());
  return router;
});

/// Legacy static router for use when ProviderScope is not available (e.g. tests).
/// Prefer ref.read(routerProvider) in app.
final router = GoRouter(
  navigatorKey: GlobalKey<NavigatorState>(),
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  routes: _appRoutes,
  errorBuilder: (context, state) => NotFoundPage(attemptedPath: state.uri.toString()),
);
