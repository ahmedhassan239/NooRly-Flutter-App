import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme_provider.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_app/design_system/app_icons.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/bottom_nav.dart';
import 'package:flutter_app/design_system/widgets/icon_helper.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_summary_entity.dart';
import 'package:flutter_app/features/journey/providers/journey_providers.dart';
import 'package:flutter_app/features/profile/presentation/profile_mock_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final journeySummaryAsync = ref.watch(journeySummaryProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, ref, isDarkMode, colorScheme),
                        _buildProfileAvatar(
                          context,
                          ref,
                          colorScheme,
                          user?.displayName,
                          user?.email,
                          journeySummaryAsync,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildYourProgress(context, ref, colorScheme, journeySummaryAsync),
                        const SizedBox(height: AppSpacing.lg),
                        _buildJourneyProgress(context, colorScheme, journeySummaryAsync),
                        const SizedBox(height: AppSpacing.lg),
                        _buildMilestones(context, colorScheme, journeySummaryAsync),
                        const SizedBox(height: AppSpacing.lg),
                        _buildPersonalInfo(context, colorScheme, user),
                        const SizedBox(height: AppSpacing.lg),
                        _buildQuickActions(context, colorScheme),
                        const SizedBox(height: AppSpacing.lg),
                        _buildLogoutButton(context, ref, colorScheme),
                        const SizedBox(height: AppSpacing.md),
                        _buildAppVersion(context, colorScheme),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isDarkMode, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          Text(
            AppLocalizations.of(context)!.profileTitle,
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.outline),
            ),
            child: IconButton(
              onPressed: () {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
              icon: Icon(
                isDarkMode ? LucideIcons.sun : LucideIcons.moon,
                size: 20,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    String? name,
    String? email,
    AsyncValue<JourneySummaryEntity> summaryAsync,
  ) {
    final dayIndex = summaryAsync.valueOrNull?.dayIndex ?? 1;
    final totalDays = summaryAsync.valueOrNull?.totalDays ?? 60;
    final initial = (name != null && name.isNotEmpty)
        ? name.substring(0, 1).toUpperCase()
        : (email != null && email.isNotEmpty)
            ? email.substring(0, 1).toUpperCase()
            : '?';
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTypography.displayLg(color: colorScheme.onPrimary),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 2),
                  ),
                  child: Icon(
                    LucideIcons.pencil,
                    size: 14,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            name ?? email ?? AppLocalizations.of(context)!.profileTitle,
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          if (email != null && email.isNotEmpty)
            Text(
              email,
              style: AppTypography.bodySm(color: colorScheme.onSurface.withAlpha(150)),
            ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.bird,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)!.profileDayOfTotal(dayIndex, totalDays),
                style: AppTypography.bodySm(color: colorScheme.primary)
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYourProgress(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    AsyncValue<JourneySummaryEntity> summaryAsync,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.trophy, size: 18, color: AppColors.accentGold),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.profileYourProgress,
                style: AppTypography.body(color: colorScheme.onSurface)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          summaryAsync.when(
            data: (summary) {
              final l10n = AppLocalizations.of(context)!;
              return Row(
                children: [
                  Expanded(
                    child: _buildProgressStatCard(
                      icon: LucideIcons.flame,
                      iconColor: AppColors.accentCoral,
                      value: summary.streakDays.toString(),
                      label: l10n.profileStreakLabel,
                      sublabel: l10n.profileDaysLabel,
                      colorScheme: colorScheme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildProgressStatCard(
                      icon: LucideIcons.target,
                      iconColor: colorScheme.primary,
                      value: summary.activeWeeks.toString(),
                      label: l10n.profileActiveLabel,
                      sublabel: l10n.profileWeeksLabel,
                      colorScheme: colorScheme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildProgressStatCard(
                      icon: AppIcons.bonus,
                      iconColor: AppColors.accentGreen,
                      value: summary.leftDays.toString(),
                      label: l10n.profileLeftLabel,
                      sublabel: l10n.profileDaysLabel,
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
              );
            },
            loading: () => _buildProgressSkeleton(context, colorScheme),
            error: (_, __) => _buildProgressError(context, ref, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSkeleton(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(child: _buildProgressStatCard(icon: LucideIcons.flame, iconColor: AppColors.accentCoral, value: '—', label: l10n.profileStreakLabel, sublabel: l10n.profileDaysLabel, colorScheme: colorScheme)),
        const SizedBox(width: 12),
        Expanded(child: _buildProgressStatCard(icon: LucideIcons.target, iconColor: colorScheme.primary, value: '—', label: l10n.profileActiveLabel, sublabel: l10n.profileWeeksLabel, colorScheme: colorScheme)),
        const SizedBox(width: 12),
        Expanded(child: _buildProgressStatCard(icon: AppIcons.bonus, iconColor: AppColors.accentGreen, value: '—', label: l10n.profileLeftLabel, sublabel: l10n.profileDaysLabel, colorScheme: colorScheme)),
      ],
    );
  }

  Widget _buildProgressError(BuildContext context, WidgetRef ref, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colorScheme.outline.withAlpha(128)),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.profileCouldNotLoadProgress,
            style: AppTypography.bodySm(color: colorScheme.onSurface.withAlpha(150)),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: () => ref.invalidate(journeySummaryProvider),
            icon: const Icon(LucideIcons.refreshCw, size: 18),
            label: Text(AppLocalizations.of(context)!.actionRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required String sublabel,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colorScheme.outline.withAlpha(128)),
      ),
      child: Column(
        children: [
          IconHelper(icon: icon, size: 24, color: iconColor),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.h2(color: iconColor)),
          Text(label, style: AppTypography.caption(color: colorScheme.onSurface.withAlpha(150))),
          Text(sublabel, style: AppTypography.caption(color: colorScheme.onSurface.withAlpha(150)).copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildJourneyProgress(
    BuildContext context,
    ColorScheme colorScheme,
    AsyncValue<JourneySummaryEntity> summaryAsync,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.target, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.profileJourneyProgress,
                style: AppTypography.body(color: colorScheme.onSurface)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          summaryAsync.when(
            data: (summary) {
              final percent = summary.completionPercent.clamp(0.0, 100.0) / 100;
              final percentInt = percent >= 1.0 ? 100 : summary.completionPercent.round();
              return Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: colorScheme.outline.withAlpha(128)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.profileLessonsCompleted(summary.completedLessons),
                          style: AppTypography.bodySm(color: colorScheme.onSurface),
                        ),
                        Text(
                          '${summary.completedLessons}/${summary.totalLessons}',
                          style: AppTypography.bodySm(color: colorScheme.onSurface.withAlpha(150)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percent,
                        minHeight: 8,
                        backgroundColor: colorScheme.outlineVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppLocalizations.of(context)!.profilePercentComplete(percentInt),
                      style: AppTypography.caption(color: colorScheme.onSurface.withAlpha(150)),
                    ),
                  ],
                ),
              );
            },
            loading: () => Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: colorScheme.outline.withAlpha(128)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: null,
                      minHeight: 8,
                      backgroundColor: colorScheme.outlineVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestones(
    BuildContext context,
    ColorScheme colorScheme,
    AsyncValue<JourneySummaryEntity> summaryAsync,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.trophy, size: 18, color: AppColors.accentGold),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.profileMilestones,
                style: AppTypography.body(color: colorScheme.onSurface)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          summaryAsync.when(
            data: (summary) {
              final l10n = AppLocalizations.of(context)!;
              final milestones = summary.milestones
                  .map((m) => MilestoneData(
                        title: l10n.profileWeekComplete(m.week),
                        status: _milestoneStatusFromString(m.status),
                      ))
                  .toList();
              if (milestones.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: colorScheme.outline.withAlpha(128)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.profileNoMilestonesYet,
                    style: AppTypography.bodySm(color: colorScheme.onSurface.withAlpha(150)),
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: colorScheme.outline.withAlpha(128)),
                ),
                child: Column(
                  children: milestones.asMap().entries.map((entry) {
                    final index = entry.key;
                    final milestone = entry.value;
                    final isLast = index == milestones.length - 1;
                    return _buildMilestoneItem(context, milestone, isLast, colorScheme);
                  }).toList(),
                ),
              );
            },
            loading: () => Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: colorScheme.outline.withAlpha(128)),
              ),
              child: Column(
                children: List.generate(4, (_) => const SizedBox(height: 48)),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  MilestoneStatus _milestoneStatusFromString(String status) {
    switch (status) {
      case 'completed':
        return MilestoneStatus.completed;
      case 'in_progress':
        return MilestoneStatus.inProgress;
      default:
        return MilestoneStatus.locked;
    }
  }

  Widget _buildMilestoneItem(BuildContext context, MilestoneData milestone, bool isLast, ColorScheme colorScheme) {
    IconData icon;
    Color iconColor;
    Color bgColor;
    Color textColor;
    String? statusText;

    switch (milestone.status) {
      case MilestoneStatus.completed:
        icon = LucideIcons.checkCircle;
        iconColor = AppColors.accentGreen;
        bgColor = Colors.transparent;
        textColor = colorScheme.onSurface;
        break;
      case MilestoneStatus.inProgress:
        icon = LucideIcons.circle;
        iconColor = colorScheme.primary;
        bgColor = colorScheme.primary.withAlpha(15);
        textColor = colorScheme.onSurface;
        statusText = AppLocalizations.of(context)!.profileInProgress;
        break;
      case MilestoneStatus.locked:
        icon = LucideIcons.lock;
        iconColor = colorScheme.onSurface.withAlpha(100);
        bgColor = Colors.transparent;
        textColor = colorScheme.onSurface.withAlpha(100);
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        border: isLast ? null : Border(bottom: BorderSide(color: colorScheme.outline.withAlpha(128))),
      ),
      child: Row(
        children: [
          IconHelper(icon: icon, size: 20, color: iconColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Row(
              children: [
                Text(milestone.title, style: AppTypography.bodySm(color: textColor)),
                if (statusText != null) ...[
                  const SizedBox(width: 8),
                  Text(statusText, style: AppTypography.caption(color: colorScheme.primary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(BuildContext context, ColorScheme colorScheme, UserEntity? user) {
    final l10n = AppLocalizations.of(context)!;
    final shahadaStr = user?.shahadaDate != null
        ? DateFormat.yMMMd().format(user!.shahadaDate!)
        : l10n.profileNotSet;
    final goalsStr = (user?.learningGoals != null && user!.learningGoals!.isNotEmpty)
        ? user.learningGoals!.join(', ')
        : ProfileMockData.learningGoal;
    final genderStr = user?.gender ?? '—';
    final birthStr = user?.birthDate != null
        ? DateFormat.yMMMd().format(user!.birthDate!)
        : '—';
    final localeStr = user?.locale ?? '—';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profilePersonalInfo,
            style: AppTypography.body(color: colorScheme.onSurface)
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: colorScheme.outline.withAlpha(128)),
            ),
            child: Column(
              children: [
                _buildInfoRow(l10n.profileLabelName, user?.name ?? user?.email ?? '—', colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow(l10n.profileLabelEmail, user?.email ?? '—', colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow(l10n.profileLabelGender, genderStr, colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow(l10n.profileLabelBirthDate, birthStr, colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow(l10n.profileLabelLocale, localeStr, colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow(l10n.profileLabelShahadaDate, shahadaStr,
                    isValueMuted: user?.shahadaDate == null, colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow(l10n.profileLabelLearningGoals, goalsStr, colorScheme: colorScheme),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          InkWell(
            onTap: () => context.push('/edit-profile'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.profileEditProfile,
                  style: AppTypography.bodySm(color: colorScheme.primary)
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                Icon(LucideIcons.chevronRight, size: 16, color: colorScheme.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isValueMuted = false, required ColorScheme colorScheme}) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySm(color: colorScheme.onSurface)),
          Text(value, style: AppTypography.bodySm(color: isValueMuted ? colorScheme.onSurface.withAlpha(100) : colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.profileQuickActions,
            style: AppTypography.body(color: colorScheme.onSurface)
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildQuickActionItem(
            icon: LucideIcons.bookMarked,
            iconBgColor: colorScheme.primary.withAlpha(25),
            iconColor: colorScheme.primary,
            title: AppLocalizations.of(context)!.profileSavedDuas,
            subtitle: AppLocalizations.of(context)!.profileViewSavedDuas,
            onTap: () => context.push('/saved'),
            colorScheme: colorScheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildQuickActionItem(
            icon: LucideIcons.heart,
            iconBgColor: AppColors.accentCoral.withAlpha(25),
            iconColor: AppColors.accentCoral,
            title: AppLocalizations.of(context)!.profileYourReflections,
            subtitle: AppLocalizations.of(context)!.profileReviewReflections,
            onTap: () => context.push('/reflections'),
            colorScheme: colorScheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildQuickActionItem(
            icon: LucideIcons.settings,
            iconBgColor: colorScheme.onSurface.withAlpha(25),
            iconColor: colorScheme.onSurface.withAlpha(150),
            title: AppLocalizations.of(context)!.settingsTitle,
            subtitle: AppLocalizations.of(context)!.profileManagePreferences,
            onTap: () => context.push('/settings'),
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colorScheme.outline.withAlpha(128)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(child: IconHelper(icon: icon, size: 22, color: iconColor)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.bodySm(color: colorScheme.onSurface).copyWith(fontWeight: FontWeight.w500)),
                  Text(subtitle, style: AppTypography.caption(color: colorScheme.onSurface.withAlpha(150))),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: colorScheme.onSurface.withAlpha(100)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: InkWell(
        onTap: () {
          final l10n = AppLocalizations.of(context)!;
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(l10n.profileLogOutTitle),
              content: Text(l10n.profileLogOutConfirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(l10n.actionCancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    ref.read(authProvider.notifier).logout();
                  },
                  child: Text(l10n.profileLogOut, style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: colorScheme.outline.withAlpha(128)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.logOut, size: 18, color: AppColors.error),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.profileLogOut, style: AppTypography.body(color: AppColors.error).copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppVersion(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Text(
        '${AppLocalizations.of(context)!.appTitle} ${ProfileMockData.appVersion}',
        style: AppTypography.caption(color: colorScheme.onSurface.withAlpha(100)),
      ),
    );
  }
}
