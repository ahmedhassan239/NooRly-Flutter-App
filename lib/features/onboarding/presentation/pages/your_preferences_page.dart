import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/features/onboarding/domain/entities/onboarding_flow_state.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_options.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/icon_badge_header.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_bottom_dots.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_primary_button.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_scaffold.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_secondary_button.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/section_title.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/selectable_chip.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/selectable_option_card.dart';
import 'package:flutter_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

/// Step 5: Your preferences — time daily (tiles), best time (chips), learning style (chips), reminders (cards).
class YourPreferencesPage extends ConsumerWidget {
  const YourPreferencesPage({super.key});

  static const _dailyTimeOptions = [
    (DailyTimeOption.fiveTo10, 'onboardingTime5To10', 'onboardingTime5To10Sub'),
    (DailyTimeOption.fifteenTo20, 'onboardingTime15To20', 'onboardingTime15To20Sub'),
    (DailyTimeOption.thirtyPlus, 'onboardingTime30Plus', 'onboardingTime30PlusSub'),
    (DailyTimeOption.flexible, 'onboardingTimeFlexible', 'onboardingTimeFlexibleSub'),
  ];
  static const _learningTimeOptions = [
    (LearningTimeOption.morning, 'onboardingBestTimeMorning', LucideIcons.sunrise),
    (LearningTimeOption.afternoon, 'onboardingBestTimeAfternoon', LucideIcons.sun),
    (LearningTimeOption.evening, 'onboardingBestTimeEvening', LucideIcons.moon),
    (LearningTimeOption.night, 'onboardingBestTimeNight', LucideIcons.moon),
    (LearningTimeOption.anytime, 'onboardingBestTimeAnytime', LucideIcons.clock),
  ];
  static const _learningStyleOptions = [
    (LearningStyleOption.reading, 'onboardingStyleReading', LucideIcons.bookOpen),
    (LearningStyleOption.listening, 'onboardingStyleListening', LucideIcons.headphones),
    (LearningStyleOption.videos, 'onboardingStyleVideos', LucideIcons.play),
    (LearningStyleOption.interactive, 'onboardingStyleInteractive', LucideIcons.network),
    (LearningStyleOption.mixOfAll, 'onboardingStyleMixOfAll', LucideIcons.lightbulb),
  ];
  static const _reminderOptions = [
    (ReminderOption.allReminders, 'onboardingReminderAll', 'onboardingReminderAllSub'),
    (ReminderOption.prayerTimesOnly, 'onboardingReminderPrayerOnly', 'onboardingReminderPrayerOnlySub'),
    (ReminderOption.letMeCustomize, 'onboardingReminderCustomize', 'onboardingReminderCustomizeSub'),
    (ReminderOption.noThanks, 'onboardingReminderNoThanks', 'onboardingReminderNoThanksSub'),
  ];

  static String _sub(AppLocalizations l10n, String key) {
    switch (key) {
      case 'onboardingTime5To10Sub': return l10n.onboardingTime5To10Sub;
      case 'onboardingTime15To20Sub': return l10n.onboardingTime15To20Sub;
      case 'onboardingTime30PlusSub': return l10n.onboardingTime30PlusSub;
      case 'onboardingTimeFlexibleSub': return l10n.onboardingTimeFlexibleSub;
      case 'onboardingReminderAllSub': return l10n.onboardingReminderAllSub;
      case 'onboardingReminderPrayerOnlySub': return l10n.onboardingReminderPrayerOnlySub;
      case 'onboardingReminderCustomizeSub': return l10n.onboardingReminderCustomizeSub;
      case 'onboardingReminderNoThanksSub': return l10n.onboardingReminderNoThanksSub;
      default: return key;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingFlowProvider);

    return OnboardingScaffold(
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingPrimaryButton(
            label: l10n.onboardingCommonSeeMyPlan,
            onPressed: () => context.go('/onboarding/plan'),
          ),
          OnboardingSecondaryButton(
            label: l10n.onboardingCommonSkipForNow,
            onPressed: () => context.go('/onboarding/plan'),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: OnboardingBottomDots(count: 3, currentIndex: 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(
            currentStep: 5,
            totalSteps: OnboardingFlowState.totalSteps,
            onBack: () => context.go('/onboarding/goals'),
          ),
          IconBadgeHeader(
            icon: const Icon(LucideIcons.clock, color: OnboardingColors.textPrimary, size: 24),
            title: l10n.onboardingPreferencesTitle,
            subtitle: l10n.onboardingPreferencesSubtitle,
          ),
          SectionTitle(title: l10n.onboardingPreferencesTimeDailyLabel),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 12.0;
              final width = (constraints.maxWidth - gap) / 2;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: _dailyTimeOptions.map((e) {
                  final value = e.$1;
                  final titleKey = e.$2;
                  final subKey = e.$3;
                  String title;
                  switch (titleKey) {
                    case 'onboardingTime5To10': title = l10n.onboardingTime5To10; break;
                    case 'onboardingTime15To20': title = l10n.onboardingTime15To20; break;
                    case 'onboardingTime30Plus': title = l10n.onboardingTime30Plus; break;
                    case 'onboardingTimeFlexible': title = l10n.onboardingTimeFlexible; break;
                    default: title = titleKey;
                  }
                  return SizedBox(
                    width: width,
                    child: SelectableOptionCard(
                      title: title,
                      subtitle: _sub(l10n, subKey),
                      isSelected: state.dailyTime == value,
                      showRadio: true,
                      onTap: () => ref.read(onboardingFlowProvider.notifier).setDailyTime(value),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 20),
          SectionTitle(title: l10n.onboardingPreferencesBestTimeLabel),
          Wrap(
            children: _learningTimeOptions.map((e) {
              String label;
              switch (e.$2) {
                case 'onboardingBestTimeMorning': label = l10n.onboardingBestTimeMorning; break;
                case 'onboardingBestTimeAfternoon': label = l10n.onboardingBestTimeAfternoon; break;
                case 'onboardingBestTimeEvening': label = l10n.onboardingBestTimeEvening; break;
                case 'onboardingBestTimeNight': label = l10n.onboardingBestTimeNight; break;
                case 'onboardingBestTimeAnytime': label = l10n.onboardingBestTimeAnytime; break;
                default: label = e.$2;
              }
              return SelectableChip(
                label: label,
                icon: Icon(e.$3, size: 18),
                isSelected: state.preferredLearningTime == e.$1,
                onTap: () => ref.read(onboardingFlowProvider.notifier).setPreferredLearningTime(e.$1),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SectionTitle(title: l10n.onboardingPreferencesLearningStyleLabel),
          Wrap(
            children: _learningStyleOptions.map((e) {
              String label;
              switch (e.$2) {
                case 'onboardingStyleReading': label = l10n.onboardingStyleReading; break;
                case 'onboardingStyleListening': label = l10n.onboardingStyleListening; break;
                case 'onboardingStyleVideos': label = l10n.onboardingStyleVideos; break;
                case 'onboardingStyleInteractive': label = l10n.onboardingStyleInteractive; break;
                case 'onboardingStyleMixOfAll': label = l10n.onboardingStyleMixOfAll; break;
                default: label = e.$2;
              }
              return SelectableChip(
                label: label,
                icon: Icon(e.$3, size: 18),
                isSelected: state.learningStyle == e.$1,
                onTap: () => ref.read(onboardingFlowProvider.notifier).setLearningStyle(e.$1),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SectionTitle(title: l10n.onboardingPreferencesRemindersLabel),
          ..._reminderOptions.map((e) {
            String title;
            switch (e.$2) {
              case 'onboardingReminderAll': title = l10n.onboardingReminderAll; break;
              case 'onboardingReminderPrayerOnly': title = l10n.onboardingReminderPrayerOnly; break;
              case 'onboardingReminderCustomize': title = l10n.onboardingReminderCustomize; break;
              case 'onboardingReminderNoThanks': title = l10n.onboardingReminderNoThanks; break;
              default: title = e.$2;
            }
            return SelectableOptionCard(
              title: title,
              subtitle: _sub(l10n, e.$3),
              isSelected: state.reminderPreference == e.$1,
              showRadio: true,
              onTap: () => ref.read(onboardingFlowProvider.notifier).setReminderPreference(e.$1),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
