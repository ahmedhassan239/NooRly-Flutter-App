import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/design_system/app_icons.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/journey/presentation/journey_mock_data.dart';
import 'package:flutter_app/features/journey/presentation/widgets/journey_stat_card.dart';
import 'package:flutter_app/features/journey/presentation/widgets/week_card.dart';
import 'package:flutter_app/features/journey/providers/journey_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class JourneyPage extends ConsumerStatefulWidget {
  const JourneyPage({super.key});

  @override
  ConsumerState<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends ConsumerState<JourneyPage> {
  int _selectedNavIndex = 2; // Journey tab selected

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Header
                _buildHeader(),
                // Content
                Expanded(
                  child: ref.watch(journeyProvider).when(
                        data: (journey) {
                          final weeks = journeyToWeekDataList(journey.weeks);
                          final progressPercent =
                              journey.progressPercentage.round();
                          final doneCount = journey.doneDays;
                          final total = journey.totalDays;
                          final currentWeek = journey.currentWeekNumber;
                          final progress =
                              total > 0 ? (doneCount / total) : 0.0;
                          return SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: AppSpacing.md),
                                _buildStatsRow(
                                    progressPercent, doneCount, currentWeek),
                                const SizedBox(height: AppSpacing.lg),
                                _buildOverallProgress(
                                    doneCount, total, progress),
                                const SizedBox(height: AppSpacing.lg),
                                _buildWeeksList(weeks),
                                const SizedBox(height: AppSpacing.lg),
                                _buildEncouragementMessage(),
                              ],
                            ),
                          );
                        },
                        loading: () => const Center(
                            child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        )),
                        error: (err, st) {
                          final message = err is ApiException
                              ? err.message
                              : (err is Exception
                                  ? err.toString().replaceFirst('Exception: ', '')
                                  : err.toString());
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Could not load journey',
                                    style: AppTypography.body(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  if (message.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      message,
                                      textAlign: TextAlign.center,
                                      style: AppTypography.caption(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  FilledButton.icon(
                                    onPressed: () =>
                                        ref.invalidate(journeyProvider),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
            icon: Icon(LucideIcons.home),
            color: colorScheme.onSurface,
          ),
          // Title
          Expanded(
            child: Column(
              children: [
                Text(
                  'Your Journey',
                  style: AppTypography.h2(color: colorScheme.onSurface),
                ),
                Text(
                  '90-Day Learning Path',
                  style: AppTypography.caption(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
          // Placeholder for symmetry
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int progressPercent, int doneCount, int currentWeek) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: JourneyStatCard(
              value: '$progressPercent%',
              label: 'Progress',
              icon: LucideIcons.target,
              iconColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: JourneyStatCard(
              value: '$doneCount',
              label: 'Done',
              icon: LucideIcons.trophy,
              iconColor: AppColors.accentGold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: JourneyStatCard(
              value: 'W$currentWeek',
              label: 'Current',
              icon: LucideIcons.flame,
              iconColor: AppColors.accentCoral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress(int doneCount, int total, double progress) {
    final colorScheme = Theme.of(context).colorScheme;
    final safeProgress = total > 0 ? progress.clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.bird,
                    size: 16,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Overall Progress',
                    style: AppTypography.bodySm(color: colorScheme.onSurface)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                '$doneCount/$total',
                style: AppTypography.bodySm(color: colorScheme.primary)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: safeProgress,
              minHeight: 8,
              backgroundColor: colorScheme.outlineVariant,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _openLesson(BuildContext context, LessonData lesson) {
    if (lesson.isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete previous lessons first.'),
        ),
      );
      return;
    }
    context.push('/lessons/${lesson.id}');
  }

  Widget _buildWeeksList(List<WeekData> weeks) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: weeks.map((week) {
          return WeekCard(
            key: ValueKey('week_${week.weekId ?? week.weekNumber}'),
            week: week,
            initiallyExpanded: week.isCurrent,
            onLessonTap: (lesson) => _openLesson(context, lesson),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEncouragementMessage() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: colorScheme.outline.withAlpha(128)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.bonus,
              size: 18,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Text(
              "Keep going! You're doing great!",
              style: AppTypography.bodySm(color: colorScheme.onSurface),
            ),
            const SizedBox(width: 8),
            Icon(
              LucideIcons.heart,
              size: 18,
              color: AppColors.accentCoral,
            ),
          ],
        ),
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
          color: isSelected ? colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
              ).copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


