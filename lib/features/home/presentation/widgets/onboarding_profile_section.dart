import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/home/presentation/widgets/dotted_card_background.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_profile_entity.dart';
import 'package:flutter_app/features/onboarding/presentation/utils/onboarding_profile_labels.dart';
import 'package:flutter_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Dashboard section that displays the user's saved onboarding profile.
/// Shows friendly labels and handles empty/loading/error.
class OnboardingProfileSection extends ConsumerWidget {
  const OnboardingProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(onboardingProfileProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return profileAsync.when(
      data: (OnboardingProfileEntity? profile) {
        if (profile == null || profile.isEmpty) {
          return _buildEmptyCard(context, colorScheme, l10n);
        }
        return _buildProfileCard(context, colorScheme, l10n, profile);
      },
      loading: () => _buildLoadingCard(context, colorScheme),
      error: (_, __) => _buildErrorCard(context, colorScheme, l10n, ref),
    );
  }

  Widget _buildEmptyCard(
    BuildContext context,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return DottedCard(
      padding: const EdgeInsets.all(20),
      onTap: () => context.push('/onboarding/about-you'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.compass, color: colorScheme.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                l10n.dashboardOnboardingTitle,
                style: AppTypography.h3(color: colorScheme.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.dashboardOnboardingEmpty,
            style: AppTypography.bodySm(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => context.push('/onboarding/about-you'),
            child: Text(l10n.dashboardOnboardingCompleteCta),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context, ColorScheme colorScheme) {
    return DottedCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading...',
            style: AppTypography.body(color: colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(
    BuildContext context,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    return DottedCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashboardOnboardingTitle,
            style: AppTypography.h3(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Could not load your profile.',
            style: AppTypography.bodySm(
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => ref.invalidate(onboardingProfileProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    OnboardingProfileEntity profile,
  ) {
    final rows = <Widget>[];

    if (profile.displayName != null && profile.displayName!.trim().isNotEmpty) {
      rows.add(_row(l10n.dashboardOnboardingDisplayName, profile.displayName!, colorScheme));
    }
    final embrace = embraceIslamLabel(l10n, profile.embraceIslamRange);
    if (embrace != null) {
      rows.add(_row(l10n.dashboardOnboardingEmbraceIslam, embrace, colorScheme));
    }
    final arabic = arabicLevelLabel(l10n, profile.arabicLevel);
    if (arabic != null) {
      rows.add(_row(l10n.dashboardOnboardingArabicLevel, arabic, colorScheme));
    }
    final prayer = prayerLevelLabel(l10n, profile.prayerLevel);
    if (prayer != null) {
      rows.add(_row(l10n.dashboardOnboardingPrayerLevel, prayer, colorScheme));
    }
    final quran = quranLevelLabel(l10n, profile.quranReadingLevel);
    if (quran != null) {
      rows.add(_row(l10n.dashboardOnboardingQuranLevel, quran, colorScheme));
    }
    if (profile.goals.isNotEmpty) {
      final labels = profile.goals
          .map((g) => goalLabel(l10n, g))
          .whereType<String>()
          .toList();
      if (labels.isNotEmpty) {
        rows.add(_sectionTitle(l10n.dashboardOnboardingYourGoals, colorScheme));
        rows.add(const SizedBox(height: 6));
        rows.add(_wrapChips(labels, colorScheme));
        rows.add(const SizedBox(height: 12));
      }
    }
    if (profile.challenges.isNotEmpty) {
      final labels = profile.challenges
          .map((c) => challengeLabel(l10n, c))
          .whereType<String>()
          .toList();
      if (labels.isNotEmpty) {
        rows.add(_sectionTitle(l10n.dashboardOnboardingYourChallenges, colorScheme));
        rows.add(const SizedBox(height: 6));
        rows.add(_wrapChips(labels, colorScheme));
        rows.add(const SizedBox(height: 12));
      }
    }
    final daily = dailyTimeLabel(l10n, profile.dailyTime);
    if (daily != null) {
      rows.add(_row(l10n.dashboardOnboardingDailyTime, daily, colorScheme));
    }
    final bestTime = learningTimeLabel(l10n, profile.preferredLearningTime);
    if (bestTime != null) {
      rows.add(_row(l10n.dashboardOnboardingBestTime, bestTime, colorScheme));
    }
    final style = learningStyleLabel(l10n, profile.learningStyle);
    if (style != null) {
      rows.add(_row(l10n.dashboardOnboardingLearningStyle, style, colorScheme));
    }
    final reminder = reminderLabel(l10n, profile.reminderPreference);
    if (reminder != null) {
      rows.add(_row(l10n.dashboardOnboardingReminders, reminder, colorScheme));
    }
    if (profile.islamDate != null) {
      rows.add(_row(
        l10n.dashboardOnboardingIslamDate,
        DateFormat.yMMMd().format(profile.islamDate!),
        colorScheme,
      ));
    }

    if (rows.isEmpty) {
      return _buildEmptyCard(context, colorScheme, l10n);
    }

    return DottedCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.compass, color: colorScheme.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                l10n.dashboardOnboardingYourJourney,
                style: AppTypography.h3(color: colorScheme.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.dashboardOnboardingSubtitle,
            style: AppTypography.bodySm(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...rows,
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, ColorScheme colorScheme) {
    return Text(
      title,
      style: AppTypography.bodySm(
        color: colorScheme.onSurface.withValues(alpha: 0.8),
      ).copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _row(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTypography.bodySm(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySm(color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapChips(List<String> labels, ColorScheme colorScheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: labels
          .map(
            (l) => Chip(
              label: Text(
                l,
                style: AppTypography.caption(color: colorScheme.onSecondaryContainer),
              ),
              backgroundColor: colorScheme.secondaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          )
          .toList(),
    );
  }
}
