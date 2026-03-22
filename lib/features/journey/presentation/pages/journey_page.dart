import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
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
import 'package:flutter_app/design_system/widgets/bottom_nav.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class JourneyPage extends ConsumerStatefulWidget {
  const JourneyPage({super.key});

  @override
  ConsumerState<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends ConsumerState<JourneyPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
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
                          final localeCode = Localizations.localeOf(context).languageCode;
                          final weeks = journeyToWeekDataList(journey.weeks, localeCode);
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
                          final l10n = AppLocalizations.of(context)!;
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
                                    l10n.journeyCouldNotLoad,
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
                                    label: Text(l10n.actionRetry),
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
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
            icon: const Icon(LucideIcons.home),
            color: colorScheme.onSurface,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  l10n.journeyTitle,
                  style: AppTypography.h2(color: colorScheme.onSurface),
                ),
                Text(
                  l10n.journeyLearningPath,
                  style: AppTypography.caption(
                      color: colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int progressPercent, int doneCount, int currentWeek) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: JourneyStatCard(
              value: '$progressPercent%',
              label: l10n.journeyStatProgress,
              icon: LucideIcons.target,
              iconColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: JourneyStatCard(
              value: '$doneCount',
              label: l10n.journeyStatDone,
              icon: LucideIcons.trophy,
              iconColor: AppColors.accentGold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: JourneyStatCard(
              value: l10n.journeyWeekLabel(currentWeek),
              label: l10n.journeyStatCurrent,
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
                    AppLocalizations.of(context)!.journeyOverallProgress,
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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.journeyCompletePreviousFirst),
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
              AppLocalizations.of(context)!.journeyEncouragement,
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

}


