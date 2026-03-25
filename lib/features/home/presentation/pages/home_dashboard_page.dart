import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/widgets/bottom_nav.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/home/data/daily_inspiration_api.dart';
import 'package:flutter_app/features/home/presentation/widgets/daily_inspiration_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/home_layout.dart';
import 'package:flutter_app/features/home/presentation/widgets/journey_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/need_help_card.dart';
import 'package:flutter_app/features/need_help/need_help_page.dart';
import 'package:flutter_app/features/home/presentation/widgets/prayer_next_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/ramadan_banner_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/today_focus_card.dart';
import 'package:flutter_app/features/home/providers/home_providers.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';
import 'package:flutter_app/features/journey/providers/journey_providers.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/core/notifications/notification_service.dart';
import 'package:flutter_app/core/notifications/schedulers/prayer_reminder_scheduler.dart';
import 'package:flutter_app/features/notifications/providers/notification_preferences_providers.dart';
import 'package:flutter_app/features/prayer/data/prayer_models.dart';
import 'package:flutter_app/features/prayer/providers/prayer_providers.dart';
import 'package:flutter_app/features/profile/providers/profile_providers.dart';
import 'package:flutter_app/app/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeDashboardPage extends ConsumerStatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  ConsumerState<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends ConsumerState<HomeDashboardPage> {
  static bool _debugChecklistPrinted = false;
  // Tracks whether we've already scheduled prayer notifications this session
  // so we don't spam-reschedule on every rebuild.
  bool _prayerNotificationsScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(locationNotifierProvider.notifier).loadFromCacheIfNeeded();
    });
  }

  /// Called once when prayer times first resolve to a non-empty list.
  Future<void> _schedulePrayerNotificationsOnce(List<PrayerCardData> prayerList) async {
    if (_prayerNotificationsScheduled || kIsWeb) return;
    _prayerNotificationsScheduled = true;

    try {
      final repo = ref.read(notificationPreferencesRepositoryProvider);
      final prefs = await repo.getLocalPreferences();
      if (!prefs.prayerEnabled) return;

      final inputs = prayerList
          .where((p) => p.timeAsDateTime != null)
          .map((p) => PrayerScheduleInput(
                name: _normalizeName(p.name),
                time: p.timeAsDateTime!,
              ))
          .where((i) => i.name.isNotEmpty)
          .toList();

      if (inputs.isEmpty) return;

      final appLocale = ref.read(localeControllerProvider).languageCode;
      await NotificationService.instance.rescheduleAll(
        prefs,
        prayerInputs: inputs,
        appLocale: appLocale,
      );

      if (kDebugMode) {
        debugPrint('[HomeDashboard] Scheduled ${inputs.length} prayer notifications');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[HomeDashboard] Prayer notification error: $e');
      _prayerNotificationsScheduled = false; // allow retry next time
    }
  }

  String _normalizeName(String name) {
    final l = name.toLowerCase().trim();
    if (l.contains('fajr') || l.contains('فجر')) return 'fajr';
    if (l.contains('dhuhr') || l.contains('ظهر') || l.contains('zuhr')) return 'dhuhr';
    if (l.contains('asr') || l.contains('عصر')) return 'asr';
    if (l.contains('maghrib') || l.contains('مغرب')) return 'maghrib';
    if (l.contains('isha') || l.contains('عشاء')) return 'isha';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('[HomeDashboardPage] build');
    }
    if (kDebugMode && !_debugChecklistPrinted) {
      _debugChecklistPrinted = true;
      _printDebugChecklistAndSearchResults();
    }

    final colorScheme = Theme.of(context).colorScheme;

    // Schedule prayer notifications once, as soon as prayer times load.
    if (!kIsWeb) {
      ref.listen<AsyncValue<List<PrayerCardData>>>(todayPrayerListProvider, (_, next) {
        next.whenData((list) {
          if (list.isNotEmpty) _schedulePrayerNotificationsOnce(list);
        });
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final l10n = AppLocalizations.of(context)!;
        final leave = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.homeExitTitle),
            content: Text(l10n.homeExitContent),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.actionCancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.homeExitConfirm),
              ),
            ],
          ),
        );
        if ((leave ?? false) && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: HomeScaffold(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: HomeLayoutColumn(
                    onRefresh: () async {
                      ref.invalidate(todayLessonProvider);
                      ref.invalidate(journeyProvider);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: HomeLayout.sectionSpacing),
                        _buildPrayerSection(),
                        const SizedBox(height: HomeLayout.sectionSpacing),
                        _buildJourneySection(),
                        const SizedBox(height: HomeLayout.sectionSpacing),
                        _buildTodayFocusSection(),
                        const SizedBox(height: HomeLayout.sectionSpacing),
                        _buildRamadanSection(),
                        const SizedBox(height: HomeLayout.sectionSpacing),
                        _buildNeedHelpSection(),
                        const SizedBox(height: HomeLayout.sectionSpacing),
                        _buildDailyInspirationSection(),
                      ],
                    ),
                  ),
                ),
                _buildBottomNav(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final header = ref.watch(homeHeaderDisplayProvider);
    final name = header.displayName.trim().isEmpty
        ? l10n.homeFriendFallback
        : header.displayName;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'F';
    final avatarUrl = ref.watch(currentUserProvider)?.avatarUrl?.trim();
    final avatarCacheNonce = ref.watch(avatarImageCacheNonceProvider);
    final displayAvatarUrl =
        avatarImageNetworkUrl(avatarUrl, avatarCacheNonce);
    final hasAvatar =
        displayAvatarUrl != null && displayAvatarUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.primaryContainer,
            child: hasAvatar
                ? ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.network(
                        displayAvatarUrl,
                        key: ValueKey(displayAvatarUrl),
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (_, __, ___) => Text(
                          initial,
                          style: AppTypography.h3(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  )
                : Text(
                    initial,
                    style: AppTypography.h3(color: colorScheme.onPrimaryContainer),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeGreeting,
                  style: AppTypography.bodySm(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: AppTypography.h2(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.homeEncouragement,
                  style: AppTypography.caption(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () =>
                    ref.read(themeModeProvider.notifier).toggleTheme(),
                icon: Icon(
                  ref.watch(themeModeProvider) == ThemeMode.dark
                      ? LucideIcons.sun
                      : LucideIcons.moon,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  shape: const CircleBorder(),
                ),
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(LucideIcons.settings),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  shape: const CircleBorder(),
                ),
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRamadanSection() {
    if (kDebugMode) debugPrint('[HomeDashboardPage] _buildRamadanSection');
    return RamadanBannerCard(
      onDismiss: () {}, // Card always visible; dismiss is no-op
      onCta: () {
        if (kDebugMode) debugPrint('NAVIGATE /ramadan');
        context.push('/ramadan');
      },
    );
  }

  Widget _buildNeedHelpSection() {
    if (kDebugMode) debugPrint('[HomeDashboardPage] _buildNeedHelpSection');
    return NeedHelpCard(
      onTap: () => context.push(NeedHelpPage.routeName),
    );
  }

  Widget _buildPrayerSection() {
    if (kDebugMode) debugPrint('[HomeDashboardPage] _buildPrayerSection');
    final prayerListAsync = ref.watch(todayPrayerListProvider);

    return prayerListAsync.when(
      data: (List<PrayerCardData> list) {
        if (list.isEmpty) {
          return const PrayerNextCard(placeholder: true);
        }
        final next = list.firstWhere(
          (p) => p.status == PrayerStatus.next,
          orElse: () => list.first,
        );
        return PrayerNextCard(nextPrayer: next);
      },
      loading: () => const PrayerNextCard(placeholder: true),
      error: (_, __) => const PrayerNextCard(placeholder: true),
    );
  }

  Widget _buildJourneySection() {
    if (kDebugMode) debugPrint('[HomeDashboardPage] _buildJourneySection');
    final auth = ref.watch(authProvider);
    final todayLessonAsync = ref.watch(todayLessonProvider);

    if (!auth.isAuthenticated) {
      return const JourneyCard(isGuest: true);
    }

    return todayLessonAsync.when(
      data: (LessonEntity? lesson) {
        if (lesson == null) {
          return JourneyCard(
            isEmpty: true,
            onRetry: () => ref.invalidate(todayLessonProvider),
          );
        }
        return JourneyCard(lesson: lesson);
      },
      loading: () => const JourneyCard(isLoading: true),
      error: (Object err, _) {
        final l10n = AppLocalizations.of(context)!;
        final isSessionExpired = err is UnauthorizedException;
        return JourneyCard(
          errorMessage: isSessionExpired
              ? l10n.journeyErrorSession
              : l10n.journeyErrorLoad,
          onRetry: () => ref.invalidate(todayLessonProvider),
          onSignIn: isSessionExpired ? () => context.go('/') : null,
        );
      },
    );
  }

  Widget _buildTodayFocusSection() {
    if (kDebugMode) debugPrint('[HomeDashboardPage] _buildTodayFocusSection');
    final todayLessonAsync = ref.watch(todayLessonProvider);
    final prayerListAsync = ref.watch(todayPrayerListProvider);
    final hasLesson = todayLessonAsync.valueOrNull != null;
    final hasNextPrayer = prayerListAsync.valueOrNull?.any(
          (p) => p.status == PrayerStatus.next,
        ) ??
        false;

    VoidCallback? onContinueLesson;
    if (hasLesson) {
      final lesson = todayLessonAsync.valueOrNull;
      if (lesson != null) {
        onContinueLesson = () => context.push('/lessons/${lesson.id}');
      }
    }

    return TodayFocusCard(
      onContinueLesson: onContinueLesson,
      onPrepareForPrayer: hasNextPrayer ? () => context.go('/prayer-times') : null,
    );
  }

  Widget _buildDailyInspirationSection() {
    final dailyInspirationAsync = ref.watch(dailyInspirationProvider);

    return dailyInspirationAsync.when(
      data: (DailyInspirationDto? inspiration) {
        return DailyInspirationCard(
          inspiration: inspiration,
          onRetry: () => ref.invalidate(dailyInspirationProvider),
        );
      },
      loading: () => DailyInspirationCard(
        inspiration: null,
        onRetry: () => ref.invalidate(dailyInspirationProvider),
      ),
      error: (_, __) => DailyInspirationCard(
        inspiration: null,
        onRetry: () => ref.invalidate(dailyInspirationProvider),
      ),
    );
  }

  Widget _buildBottomNav() {
    return const BottomNav();
  }

  void _printDebugChecklistAndSearchResults() {
    debugPrint('');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('HOME AUDIT – DIFF (screenshot vs current)');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('  PRESENT: Header (avatar, greeting, name, subtitle, moon icon)');
    debugPrint('  PRESENT: Next Prayer card (dotted, prayer icon, time, chevron)');
    debugPrint('  PRESENT: Your Journey card (dotted, pill, title, clock + min read, CTA)');
    debugPrint("  PRESENT: Today's Focus card (dotted, rows with icons)");
    debugPrint('  PRESENT: Ramadan banner (beige, crescent, CTA, X dismiss)');
    debugPrint('  PRESENT: Need Help Now? card (white, green icon, chevron)');
    debugPrint('  PRESENT: Daily Inspiration header (heart + title, See All)');
    debugPrint('  PRESENT: Daily Inspiration card (Hadith chip, Arabic, 3 buttons)');
    debugPrint('  MISSING: (none – all sections implemented)');
    debugPrint('  Home files: home_dashboard_page.dart, home_layout.dart,');
    debugPrint('    prayer_next_card, journey_card, today_focus_card,');
    debugPrint('    ramadan_banner_card, need_help_card, daily_inspiration_card,');
    debugPrint('    dotted_card_background, home_card');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('');
    debugPrint('CHECKLIST:');
    debugPrint('  [ ] Home renders (no blank/white screen)');
    debugPrint('  [ ] UI matches screenshot (spacing/fonts/colors)');
    debugPrint('  [ ] First 3 cards have dotted pattern inside them (clipped)');
    debugPrint('  [ ] Ramadan card matches screenshot');
    debugPrint('  [ ] Need Help card matches screenshot');
    debugPrint('  [ ] Daily Inspiration header + card matches screenshot');
    debugPrint('  [ ] Existing functionality still works');
    debugPrint('  [ ] No console exceptions');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('');
    debugPrint('SEARCH RESULTS:');
    debugPrint('  Keywords: HomeDashboardPage, HomeScaffold, HomeLayoutColumn,');
    debugPrint('    DottedCard, PatternedCard, RamadanBannerCard, NeedHelpCard,');
    debugPrint('    DailyInspirationCard, home/dashboard, prayer-times, journey');
    debugPrint('  Files changed: home_dashboard_page.dart, home_layout.dart,');
    debugPrint('    ramadan_banner_card.dart (new), need_help_card.dart (new),');
    debugPrint('    journey_card.dart, today_focus_card.dart, daily_inspiration_card.dart,');
    debugPrint('    home_card.dart');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('');
  }
}
