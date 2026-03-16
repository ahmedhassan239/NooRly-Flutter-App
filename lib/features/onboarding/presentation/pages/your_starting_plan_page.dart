import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/features/onboarding/domain/entities/onboarding_flow_state.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_options.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/expandable_info_card.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_bottom_dots.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_primary_button.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_scaffold.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/plan_timeline_item.dart';
import 'package:flutter_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

/// Step 6: Your Starting Plan — timeline summary + Add Islam date (expandable) + Start My Journey.
class YourStartingPlanPage extends ConsumerStatefulWidget {
  const YourStartingPlanPage({super.key});

  @override
  ConsumerState<YourStartingPlanPage> createState() => _YourStartingPlanPageState();
}

class _YourStartingPlanPageState extends ConsumerState<YourStartingPlanPage> {
  bool _isStarting = false;

  /// Build plan items in order. Optionally reorder based on answers (e.g. prioritize prayer if weak).
  List<({String weekLabel, String title, String subtitle, Widget icon, Color bgColor})> _planItems(
    BuildContext context,
    OnboardingFlowState state,
    AppLocalizations l10n,
  ) {
    final items = <({String weekLabel, String title, String subtitle, Widget icon, Color bgColor})>[];
    // Default order: Faith Foundations → Daily Prayer → Living Islam
    final prayerWeak = state.prayerLevel == PrayerLevelOption.notYet || state.prayerLevel == PrayerLevelOption.learningToPray;
    final quranFocus = state.goals.contains(GoalOption.understandQuran) || state.challenges.contains(ChallengeOption.understandingArabic);

    if (prayerWeak && !quranFocus) {
      // Prioritize Daily Prayer first
      items.add((
        weekLabel: l10n.onboardingPlanWeeks3To5,
        title: l10n.onboardingPlanDailyPrayer,
        subtitle: l10n.onboardingPlanDailyPrayerSub,
        icon: const Icon(LucideIcons.calendarCheck, color: OnboardingColors.planGreen, size: 24),
        bgColor: OnboardingColors.planGreenBg,
      ));
      items.add((
        weekLabel: l10n.onboardingPlanWeeks1To2,
        title: l10n.onboardingPlanFaithFoundations,
        subtitle: l10n.onboardingPlanFaithFoundationsSub,
        icon: const Icon(LucideIcons.bookOpen, color: OnboardingColors.planBlue, size: 24),
        bgColor: OnboardingColors.planBlueBg,
      ));
    } else {
      items.add((
        weekLabel: l10n.onboardingPlanWeeks1To2,
        title: l10n.onboardingPlanFaithFoundations,
        subtitle: l10n.onboardingPlanFaithFoundationsSub,
        icon: const Icon(LucideIcons.bookOpen, color: OnboardingColors.planBlue, size: 24),
        bgColor: OnboardingColors.planBlueBg,
      ));
      items.add((
        weekLabel: l10n.onboardingPlanWeeks3To5,
        title: l10n.onboardingPlanDailyPrayer,
        subtitle: l10n.onboardingPlanDailyPrayerSub,
        icon: const Icon(LucideIcons.calendarCheck, color: OnboardingColors.planGreen, size: 24),
        bgColor: OnboardingColors.planGreenBg,
      ));
    }
    items.add((
      weekLabel: l10n.onboardingPlanWeeks6To8,
      title: l10n.onboardingPlanLivingIslam,
      subtitle: l10n.onboardingPlanLivingIslamSub,
      icon: const Icon(LucideIcons.heart, color: OnboardingColors.planOrange, size: 24),
      bgColor: OnboardingColors.planOrangeBg,
    ));
    return items;
  }

  Future<void> _handleStartJourney() async {
    setState(() => _isStarting = true);

    final flowState = ref.read(onboardingFlowProvider);
    final isAuth = ref.read(authProvider).isAuthenticated;

    if (isAuth) {
      try {
        final profileRepo = ref.read(onboardingProfileRepositoryProvider);
        await profileRepo.saveOnboardingProfile(flowState);
        ref.invalidate(onboardingProfileProvider);
        final legacyRepo = ref.read(onboardingRepositoryProvider);
        final goals = flowState.goals;
        final shahadaDate = flowState.islamDate?.toIso8601String().split('T').first;
        await legacyRepo.updateOnboarding(
          goals: goals.isEmpty ? null : goals,
          shahadaDate: shahadaDate,
          summaryCompleted: true,
        );
        await ref.read(authProvider.notifier).refreshOnboarding();
      } catch (_) {
        if (mounted) setState(() => _isStarting = false);
        return;
      }
    }

    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingFlowProvider);
    final planItems = _planItems(context, state, l10n);

    return OnboardingScaffold(
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingPrimaryButton(
            label: l10n.onboardingCommonStartMyJourney,
            onPressed: _isStarting ? null : _handleStartJourney,
            isLoading: _isStarting,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: OnboardingBottomDots(count: 5, currentIndex: 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: _isStarting ? null : () => context.go('/onboarding/preferences'),
                  icon: const Icon(LucideIcons.arrowLeft, color: OnboardingColors.textPrimary),
                ),
                const Spacer(),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: OnboardingColors.iconBadgeBeige,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(LucideIcons.compass, color: OnboardingColors.planOrange, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingPlanTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: OnboardingColors.textPrimary,
                ) ?? const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: OnboardingColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingPlanSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: OnboardingColors.textMuted,
                ) ?? const TextStyle(color: OnboardingColors.textMuted),
          ),
          const SizedBox(height: 28),
          Stack(
            children: [
              Positioned(
                left: 23,
                top: 24,
                bottom: 24,
                child: Container(
                  width: 2,
                  color: OnboardingColors.border,
                ),
              ),
              Column(
                children: planItems.map((e) => PlanTimelineItem(
                      icon: e.icon,
                      iconBgColor: e.bgColor,
                      weekLabel: e.weekLabel,
                      title: e.title,
                      subtitle: e.subtitle,
                    )).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ExpandableInfoCard(
            icon: const Icon(LucideIcons.calendar, color: OnboardingColors.planOrange, size: 24),
            title: l10n.onboardingPlanAddIslamDate,
            subtitle: l10n.onboardingPlanAddIslamDateSub,
            expandedChild: _IslamDatePicker(
              onDateSelected: (d) => ref.read(onboardingFlowProvider.notifier).setIslamDate(d),
              initialDate: state.islamDate,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _IslamDatePicker extends StatelessWidget {
  const _IslamDatePicker({
    required this.onDateSelected,
    this.initialDate,
  });

  final ValueChanged<DateTime?> onDateSelected;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: initialDate ?? now,
          firstDate: DateTime(1900),
          lastDate: now,
        );
        if (date != null) onDateSelected(date);
      },
      icon: const Icon(LucideIcons.calendar, size: 18),
      label: Text(
        initialDate != null
            ? DateFormat.yMMMd().format(initialDate!)
            : 'Select date',
      ),
    );
  }
}
