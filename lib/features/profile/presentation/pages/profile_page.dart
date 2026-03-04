import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme_provider.dart';
import 'package:flutter_app/design_system/app_icons.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/bottom_nav.dart';
import 'package:flutter_app/design_system/widgets/icon_helper.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
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
                        _buildProfileAvatar(colorScheme, user?.displayName, user?.email),
                        const SizedBox(height: AppSpacing.lg),
                        _buildYourProgress(colorScheme),
                        const SizedBox(height: AppSpacing.lg),
                        _buildJourneyProgress(colorScheme),
                        const SizedBox(height: AppSpacing.lg),
                        _buildMilestones(colorScheme),
                        const SizedBox(height: AppSpacing.lg),
                        _buildPersonalInfo(context, colorScheme, user),
                        const SizedBox(height: AppSpacing.lg),
                        _buildQuickActions(context, colorScheme),
                        const SizedBox(height: AppSpacing.lg),
                        _buildLogoutButton(context, ref, colorScheme),
                        const SizedBox(height: AppSpacing.md),
                        _buildAppVersion(colorScheme),
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
            'Profile',
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

  Widget _buildProfileAvatar(ColorScheme colorScheme, String? name, String? email) {
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
            name ?? email ?? 'Profile',
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
                'Day ${ProfileMockData.currentDay} of ${ProfileMockData.totalDays}',
                style: AppTypography.bodySm(color: colorScheme.primary)
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYourProgress(ColorScheme colorScheme) {
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
                'Your Progress',
                style: AppTypography.body(color: colorScheme.onSurface)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildProgressStatCard(
                  icon: LucideIcons.flame,
                  iconColor: AppColors.accentCoral,
                  value: ProfileMockData.streakDays.toString(),
                  label: 'Streak',
                  sublabel: 'days',
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProgressStatCard(
                  icon: LucideIcons.target,
                  iconColor: colorScheme.primary,
                  value: ProfileMockData.activeWeeks.toString(),
                  label: 'Active',
                  sublabel: 'weeks',
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProgressStatCard(
                  icon: AppIcons.bonus,
                  iconColor: AppColors.accentGreen,
                  value: ProfileMockData.daysLeft.toString(),
                  label: 'Left',
                  sublabel: 'days',
                  colorScheme: colorScheme,
                ),
              ),
            ],
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

  Widget _buildJourneyProgress(ColorScheme colorScheme) {
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
                'Journey Progress',
                style: AppTypography.body(color: colorScheme.onSurface)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
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
                      '${ProfileMockData.lessonsCompleted} lessons completed',
                      style: AppTypography.bodySm(color: colorScheme.onSurface),
                    ),
                    Text(
                      '${ProfileMockData.lessonsCompleted + 1}/${ProfileMockData.totalLessons}',
                      style: AppTypography.bodySm(color: colorScheme.onSurface.withAlpha(150)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ProfileMockData.progressPercent,
                    minHeight: 8,
                    backgroundColor: colorScheme.outlineVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${ProfileMockData.progressPercentInt}% complete',
                  style: AppTypography.caption(color: colorScheme.onSurface.withAlpha(150)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestones(ColorScheme colorScheme) {
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
                'Milestones',
                style: AppTypography.body(color: colorScheme.onSurface)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: colorScheme.outline.withAlpha(128)),
            ),
            child: Column(
              children: ProfileMockData.milestones.asMap().entries.map((entry) {
                final index = entry.key;
                final milestone = entry.value;
                final isLast = index == ProfileMockData.milestones.length - 1;
                return _buildMilestoneItem(milestone, isLast, colorScheme);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem(MilestoneData milestone, bool isLast, ColorScheme colorScheme) {
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
      case MilestoneStatus.inProgress:
        icon = LucideIcons.circle;
        iconColor = colorScheme.primary;
        bgColor = colorScheme.primary.withAlpha(15);
        textColor = colorScheme.onSurface;
        statusText = '(In Progress)';
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
    final shahadaStr = user?.shahadaDate != null
        ? DateFormat.yMMMd().format(user!.shahadaDate!)
        : 'Not set';
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
            'Personal Info',
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
                _buildInfoRow('Name', user?.name ?? user?.email ?? '—', colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow('Email', user?.email ?? '—', colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow('Gender', genderStr, colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow('Birth date', birthStr, colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow('Locale', localeStr, colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow('Shahada Date', shahadaStr,
                    isValueMuted: user?.shahadaDate == null, colorScheme: colorScheme),
                Container(height: 1, color: colorScheme.outline.withAlpha(128)),
                _buildInfoRow('Learning Goals', goalsStr, colorScheme: colorScheme),
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
                  'Edit Profile',
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
            'Quick Actions',
            style: AppTypography.body(color: colorScheme.onSurface)
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildQuickActionItem(
            icon: LucideIcons.bookMarked,
            iconBgColor: colorScheme.primary.withAlpha(25),
            iconColor: colorScheme.primary,
            title: 'Saved Duas',
            subtitle: 'View your saved duas collection',
            onTap: () => context.push('/duas/saved'),
            colorScheme: colorScheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildQuickActionItem(
            icon: LucideIcons.heart,
            iconBgColor: AppColors.accentCoral.withAlpha(25),
            iconColor: AppColors.accentCoral,
            title: 'Your Reflections',
            subtitle: 'Review your lesson reflections',
            onTap: () {},
            colorScheme: colorScheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildQuickActionItem(
            icon: LucideIcons.settings,
            iconBgColor: colorScheme.onSurface.withAlpha(25),
            iconColor: colorScheme.onSurface.withAlpha(150),
            title: 'Settings',
            subtitle: 'Manage app preferences',
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
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Log Out'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    ref.read(authProvider.notifier).logout();
                  },
                  child: Text('Log Out', style: TextStyle(color: AppColors.error)),
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
              Text('Log Out', style: AppTypography.body(color: AppColors.error).copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppVersion(ColorScheme colorScheme) {
    return Center(
      child: Text(
        'Noor Journey ${ProfileMockData.appVersion}',
        style: AppTypography.caption(color: colorScheme.onSurface.withAlpha(100)),
      ),
    );
  }
}
