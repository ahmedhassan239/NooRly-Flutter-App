import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/design_system/typography.dart';
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

/// Step 2: A little about you — name input + when did you embrace Islam (single-select).
class AboutYouPage extends ConsumerStatefulWidget {
  const AboutYouPage({super.key});

  @override
  ConsumerState<AboutYouPage> createState() => _AboutYouPageState();
}

class _AboutYouPageState extends ConsumerState<AboutYouPage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(onboardingFlowProvider);
      if (state.displayName != null) _nameController.text = state.displayName!;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  static const _embraceOptions = [
    (EmbraceIslamOption.lessThan1Month, 'onboardingEmbraceIslamLessThan1Month'),
    (EmbraceIslamOption.oneTo6Months, 'onboardingEmbraceIslam1To6Months'),
    (EmbraceIslamOption.sixTo12Months, 'onboardingEmbraceIslam6To12Months'),
    (EmbraceIslamOption.oneTo2Years, 'onboardingEmbraceIslam1To2Years'),
    (EmbraceIslamOption.twoPlusYears, 'onboardingEmbraceIslam2PlusYears'),
    (EmbraceIslamOption.bornMuslim, 'onboardingEmbraceIslamBornMuslim'),
  ];

  String _getL10n(AppLocalizations l10n, String key) {
    switch (key) {
      case 'onboardingEmbraceIslamLessThan1Month':
        return l10n.onboardingEmbraceIslamLessThan1Month;
      case 'onboardingEmbraceIslam1To6Months':
        return l10n.onboardingEmbraceIslam1To6Months;
      case 'onboardingEmbraceIslam6To12Months':
        return l10n.onboardingEmbraceIslam6To12Months;
      case 'onboardingEmbraceIslam1To2Years':
        return l10n.onboardingEmbraceIslam1To2Years;
      case 'onboardingEmbraceIslam2PlusYears':
        return l10n.onboardingEmbraceIslam2PlusYears;
      case 'onboardingEmbraceIslamBornMuslim':
        return l10n.onboardingEmbraceIslamBornMuslim;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingFlowProvider);

    return OnboardingScaffold(
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingPrimaryButton(
            label: l10n.onboardingCommonContinue,
            onPressed: () {
              ref.read(onboardingFlowProvider.notifier).setDisplayName(_nameController.text);
              context.go('/onboarding/knowledge');
            },
          ),
          OnboardingSecondaryButton(
            label: l10n.onboardingCommonSkipForNow,
            onPressed: () => context.go('/onboarding/knowledge'),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(
            currentStep: 2,
            totalSteps: OnboardingFlowState.totalSteps,
            onBack: () => context.go('/'),
          ),
          IconBadgeHeader(
            icon: const Icon(LucideIcons.user, color: OnboardingColors.textPrimary, size: 24),
            title: l10n.onboardingAboutYouTitle,
            subtitle: l10n.onboardingAboutYouSubtitle,
          ),
          SectionTitle(title: l10n.onboardingAboutYouNameLabel),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextField(
              controller: _nameController,
              onChanged: (v) => ref.read(onboardingFlowProvider.notifier).setDisplayName(v),
              decoration: InputDecoration(
                hintText: l10n.onboardingAboutYouNamePlaceholder,
                hintStyle: AppTypography.body(color: OnboardingColors.textMuted),
                filled: true,
                fillColor: OnboardingColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: OnboardingColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: OnboardingColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          SectionTitle(title: l10n.onboardingAboutYouEmbraceIslamLabel),
          ..._embraceOptions.map((e) {
            final value = e.$1;
            final labelKey = e.$2;
            return SelectableRadioRow(
              label: _getL10n(l10n, labelKey),
              isSelected: state.embraceIslamRange == value,
              onTap: () => ref.read(onboardingFlowProvider.notifier).setEmbraceIslam(value),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
