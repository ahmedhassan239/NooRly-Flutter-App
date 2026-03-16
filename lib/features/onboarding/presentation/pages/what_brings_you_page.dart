import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/features/onboarding/domain/entities/onboarding_flow_state.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_options.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/icon_badge_header.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_primary_button.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_scaffold.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/onboarding_secondary_button.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/section_title.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/selectable_option_card.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/selectable_chip.dart';
import 'package:flutter_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

/// Step 4: What brings you here? — main goals (multi-select cards) + challenges (multi-select chips).
class WhatBringsYouPage extends ConsumerWidget {
  const WhatBringsYouPage({super.key});

  static const _goals = [
    (GoalOption.learnBasics, 'onboardingGoalLearnBasics', LucideIcons.bookOpen, OnboardingColors.goalBasics),
    (GoalOption.improvePrayer, 'onboardingGoalImprovePrayer', LucideIcons.hand, OnboardingColors.goalPrayer),
    (GoalOption.understandQuran, 'onboardingGoalUnderstandQuran', LucideIcons.book, OnboardingColors.goalQuran),
    (GoalOption.buildHabits, 'onboardingGoalBuildHabits', LucideIcons.sun, OnboardingColors.goalHabits),
    (GoalOption.connectCommunity, 'onboardingGoalConnectCommunity', LucideIcons.users, OnboardingColors.goalCommunity),
  ];
  static const _challenges = [
    (ChallengeOption.understandingArabic, 'onboardingChallengeUnderstandingArabic', LucideIcons.fileText, OnboardingColors.challengeArabic),
    (ChallengeOption.rememberingToPray, 'onboardingChallengeRememberingToPray', LucideIcons.clock, OnboardingColors.challengePray),
    (ChallengeOption.findingTime, 'onboardingChallengeFindingTime', LucideIcons.timer, OnboardingColors.challengeTime),
    (ChallengeOption.stayingConsistent, 'onboardingChallengeStayingConsistent', LucideIcons.trendingUp, OnboardingColors.challengeConsistent),
    (ChallengeOption.dealingWithDoubts, 'onboardingChallengeDealingWithDoubts', LucideIcons.messageCircle, OnboardingColors.challengeDoubts),
    (ChallengeOption.lackOfSupport, 'onboardingChallengeLackOfSupport', LucideIcons.users, OnboardingColors.challengeSupport),
  ];

  static String _goalLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'onboardingGoalLearnBasics': return l10n.onboardingGoalLearnBasics;
      case 'onboardingGoalImprovePrayer': return l10n.onboardingGoalImprovePrayer;
      case 'onboardingGoalUnderstandQuran': return l10n.onboardingGoalUnderstandQuran;
      case 'onboardingGoalBuildHabits': return l10n.onboardingGoalBuildHabits;
      case 'onboardingGoalConnectCommunity': return l10n.onboardingGoalConnectCommunity;
      default: return key;
    }
  }
  static String _challengeLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'onboardingChallengeUnderstandingArabic': return l10n.onboardingChallengeUnderstandingArabic;
      case 'onboardingChallengeRememberingToPray': return l10n.onboardingChallengeRememberingToPray;
      case 'onboardingChallengeFindingTime': return l10n.onboardingChallengeFindingTime;
      case 'onboardingChallengeStayingConsistent': return l10n.onboardingChallengeStayingConsistent;
      case 'onboardingChallengeDealingWithDoubts': return l10n.onboardingChallengeDealingWithDoubts;
      case 'onboardingChallengeLackOfSupport': return l10n.onboardingChallengeLackOfSupport;
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
            label: l10n.onboardingCommonContinue,
            onPressed: () => context.go('/onboarding/preferences'),
          ),
          OnboardingSecondaryButton(
            label: l10n.onboardingCommonSkipForNow,
            onPressed: () => context.go('/onboarding/preferences'),
          ),
          const SizedBox(height: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(
            currentStep: 4,
            totalSteps: OnboardingFlowState.totalSteps,
            onBack: () => context.go('/onboarding/knowledge'),
          ),
          IconBadgeHeader(
            icon: const Icon(LucideIcons.target, color: OnboardingColors.textPrimary, size: 24),
            title: l10n.onboardingGoalsTitle,
            subtitle: l10n.onboardingGoalsSubtitle,
          ),
          SectionTitle(title: l10n.onboardingGoalsMainLabel),
          ..._goals.map((e) => SelectableOptionCard(
                title: _goalLabel(l10n, e.$2),
                leading: Icon(e.$3, size: 22, color: e.$4),
                isSelected: state.goals.contains(e.$1),
                showRadio: false,
                onTap: () => ref.read(onboardingFlowProvider.notifier).toggleGoal(e.$1),
              )),
          const SizedBox(height: 24),
          SectionTitle(title: l10n.onboardingChallengesLabel),
          Wrap(
            children: _challenges.map((e) => SelectableChip(
                  label: _challengeLabel(l10n, e.$2),
                  icon: Icon(e.$3, size: 18, color: e.$4),
                  isSelected: state.challenges.contains(e.$1),
                  onTap: () => ref.read(onboardingFlowProvider.notifier).toggleChallenge(e.$1),
                )).toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
