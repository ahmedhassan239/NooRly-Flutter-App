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
import 'package:flutter_app/features/onboarding/presentation/widgets/selectable_radio_row.dart';
import 'package:flutter_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

/// Step 3: Your current knowledge — Arabic, prayer, Quran (each single-select).
class CurrentKnowledgePage extends ConsumerWidget {
  const CurrentKnowledgePage({super.key});

  static const _arabicOptions = [
    (ArabicLevelOption.yesFluently, 'onboardingArabicYesFluently'),
    (ArabicLevelOption.yesSlowly, 'onboardingArabicYesSlowly'),
    (ArabicLevelOption.learningNow, 'onboardingArabicLearningNow'),
    (ArabicLevelOption.noWantToLearn, 'onboardingArabicNoWantToLearn'),
    (ArabicLevelOption.no, 'onboardingArabicNo'),
  ];
  static const _prayerOptions = [
    (PrayerLevelOption.yesRegularly, 'onboardingPrayerYesRegularly'),
    (PrayerLevelOption.yesNotAll5, 'onboardingPrayerYesNotAll5'),
    (PrayerLevelOption.learningToPray, 'onboardingPrayerLearningToPray'),
    (PrayerLevelOption.notYet, 'onboardingPrayerNotYet'),
  ];
  static const _quranOptions = [
    (QuranReadingOption.yesRegularly, 'onboardingQuranYesRegularly'),
    (QuranReadingOption.yesOccasionally, 'onboardingQuranYesOccasionally'),
    (QuranReadingOption.justStarted, 'onboardingQuranJustStarted'),
    (QuranReadingOption.notYet, 'onboardingQuranNotYet'),
  ];

  static String _arabicL10n(AppLocalizations l10n, String key) {
    switch (key) {
      case 'onboardingArabicYesFluently': return l10n.onboardingArabicYesFluently;
      case 'onboardingArabicYesSlowly': return l10n.onboardingArabicYesSlowly;
      case 'onboardingArabicLearningNow': return l10n.onboardingArabicLearningNow;
      case 'onboardingArabicNoWantToLearn': return l10n.onboardingArabicNoWantToLearn;
      case 'onboardingArabicNo': return l10n.onboardingArabicNo;
      default: return key;
    }
  }
  static String _prayerL10n(AppLocalizations l10n, String key) {
    switch (key) {
      case 'onboardingPrayerYesRegularly': return l10n.onboardingPrayerYesRegularly;
      case 'onboardingPrayerYesNotAll5': return l10n.onboardingPrayerYesNotAll5;
      case 'onboardingPrayerLearningToPray': return l10n.onboardingPrayerLearningToPray;
      case 'onboardingPrayerNotYet': return l10n.onboardingPrayerNotYet;
      default: return key;
    }
  }
  static String _quranL10n(AppLocalizations l10n, String key) {
    switch (key) {
      case 'onboardingQuranYesRegularly': return l10n.onboardingQuranYesRegularly;
      case 'onboardingQuranYesOccasionally': return l10n.onboardingQuranYesOccasionally;
      case 'onboardingQuranJustStarted': return l10n.onboardingQuranJustStarted;
      case 'onboardingQuranNotYet': return l10n.onboardingQuranNotYet;
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
            onPressed: () => context.go('/onboarding/goals'),
          ),
          OnboardingSecondaryButton(
            label: l10n.onboardingCommonSkipForNow,
            onPressed: () => context.go('/onboarding/goals'),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(
            currentStep: 3,
            totalSteps: OnboardingFlowState.totalSteps,
            onBack: () => context.go('/onboarding/about-you'),
          ),
          IconBadgeHeader(
            icon: const Icon(LucideIcons.bookOpen, color: OnboardingColors.textPrimary, size: 24),
            title: l10n.onboardingKnowledgeTitle,
            subtitle: l10n.onboardingKnowledgeSubtitle,
          ),
          SectionTitle(title: l10n.onboardingKnowledgeArabicLabel),
          ..._arabicOptions.map((e) => SelectableRadioRow(
                label: _arabicL10n(l10n, e.$2),
                isSelected: state.arabicLevel == e.$1,
                onTap: () => ref.read(onboardingFlowProvider.notifier).setArabicLevel(e.$1),
              )),
          const SizedBox(height: 20),
          SectionTitle(title: l10n.onboardingKnowledgePrayerLabel),
          ..._prayerOptions.map((e) => SelectableRadioRow(
                label: _prayerL10n(l10n, e.$2),
                isSelected: state.prayerLevel == e.$1,
                onTap: () => ref.read(onboardingFlowProvider.notifier).setPrayerLevel(e.$1),
              )),
          const SizedBox(height: 20),
          SectionTitle(title: l10n.onboardingKnowledgeQuranLabel),
          ..._quranOptions.map((e) => SelectableRadioRow(
                label: _quranL10n(l10n, e.$2),
                isSelected: state.quranReadingLevel == e.$1,
                onTap: () => ref.read(onboardingFlowProvider.notifier).setQuranReadingLevel(e.$1),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
