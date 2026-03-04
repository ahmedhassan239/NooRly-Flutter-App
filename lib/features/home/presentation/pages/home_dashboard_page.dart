import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/hadith/data/daily_hadith_api.dart';
import 'package:flutter_app/features/home/presentation/widgets/daily_inspiration_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/home_layout.dart';
import 'package:flutter_app/features/home/presentation/widgets/journey_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/need_help_card.dart';
import 'package:flutter_app/features/need_help/need_help_page.dart';
import 'package:flutter_app/features/home/presentation/widgets/prayer_next_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/ramadan_banner_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/today_focus_card.dart';
import 'package:flutter_app/features/home/providers/home_providers.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';
import 'package:flutter_app/features/journey/providers/journey_providers.dart';
import 'package:flutter_app/features/prayer/data/prayer_models.dart';
import 'package:flutter_app/features/prayer/providers/prayer_providers.dart';
import 'package:flutter_app/features/profile/providers/profile_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeDashboardPage extends ConsumerStatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  ConsumerState<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends ConsumerState<HomeDashboardPage> {
  int _selectedNavIndex = 0;
  static bool _debugChecklistPrinted = false;
  bool _ramadanBannerDismissed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(locationNotifierProvider.notifier).loadFromCacheIfNeeded();
    });
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final leave = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Exit app?'),
            content: const Text('Do you want to exit NooRly?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        if ((leave ?? false) && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: HomeScaffold(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: HomeLayoutColumn(
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
                        if (!_ramadanBannerDismissed) ...[
                          _buildRamadanSection(),
                          const SizedBox(height: HomeLayout.sectionSpacing),
                        ],
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
    final header = ref.watch(homeHeaderDisplayProvider);
    final name =
        header.displayName.trim().isEmpty ? 'Friend' : header.displayName;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'F';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
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
                  'Assalamu Alaikum',
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
                  "You're doing great. Every step counts.",
                  style: AppTypography.caption(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(LucideIcons.moon),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest,
              shape: const CircleBorder(),
            ),
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildRamadanSection() {
    if (kDebugMode) debugPrint('[HomeDashboardPage] _buildRamadanSection');
    return RamadanBannerCard(
      onDismiss: () => setState(() => _ramadanBannerDismissed = true),
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
          return const JourneyCard(isEmpty: true);
        }
        return JourneyCard(lesson: lesson);
      },
      loading: () => const JourneyCard(isEmpty: true),
      error: (_, __) => const JourneyCard(isEmpty: true),
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
    final dailyHadithAsync = ref.watch(dailyHadithProvider);

    return dailyHadithAsync.when(
      data: (DailyHadithDto? hadith) {
        return DailyInspirationCard(
          hadith: hadith,
          onRetry: () => ref.invalidate(dailyHadithProvider),
        );
      },
      loading: () => DailyInspirationCard(
        hadith: null,
        onRetry: () => ref.invalidate(dailyHadithProvider),
      ),
      error: (_, __) => DailyInspirationCard(
        hadith: null,
        onRetry: () => ref.invalidate(dailyHadithProvider),
      ),
    );
  }

  Widget _buildBottomNav() {
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    return Material(
      color: brightness == Brightness.dark
          ? colorScheme.surface
          : colorScheme.surface.withValues(alpha: 0.95),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colorScheme.outline.withAlpha(128)),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, LucideIcons.home, 'Home', '/home'),
                _buildNavItem(1, LucideIcons.library, 'Library', '/duas'),
                _buildNavItem(2, LucideIcons.bookOpen, 'Journey', '/journey'),
                _buildNavItem(3, LucideIcons.clock, 'Prayer', '/prayer-times'),
                _buildNavItem(4, LucideIcons.user, 'Profile', '/profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, String route) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedNavIndex = index);
        context.go(route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ).copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
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
