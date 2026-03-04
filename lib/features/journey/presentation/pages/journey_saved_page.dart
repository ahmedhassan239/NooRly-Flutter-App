import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/providers/saved_lessons_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class JourneySavedPage extends ConsumerWidget {
  const JourneySavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedLessons = ref.watch(savedLessonsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(context, savedLessons.length, colorScheme),
                Expanded(
                  child: savedLessons.isEmpty
                      ? _buildEmptyState(context, colorScheme)
                      : _buildSavedLessonsList(context, ref, savedLessons, colorScheme),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int count, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withAlpha(128)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/journey');
              }
            },
            icon: const Icon(LucideIcons.arrowLeft),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Favorite Lessons',
                style: AppTypography.h2(color: colorScheme.onSurface),
              ),
              Text(
                '$count saved',
                style: AppTypography.caption(color: colorScheme.onSurface.withAlpha(150)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant.withAlpha(100),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.heart,
                size: 36,
                color: colorScheme.onSurface.withAlpha(100),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No favorite lessons yet',
              style: AppTypography.h3(color: colorScheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tap the heart icon on any lesson to add it to your favorites.',
              style: AppTypography.bodySm(color: colorScheme.onSurface.withAlpha(150)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: () => context.go('/journey'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onSurface,
                side: BorderSide(color: colorScheme.outline),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                ),
              child: const Text('Browse Lessons'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedLessonsList(
    BuildContext context,
    WidgetRef ref,
    List<SavedLessonData> savedLessons,
    ColorScheme colorScheme,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: savedLessons.length,
      itemBuilder: (context, index) {
        final lesson = savedLessons[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: _buildSavedLessonCard(context, ref, lesson, colorScheme),
        );
      },
    );
  }

  Widget _buildSavedLessonCard(
    BuildContext context,
    WidgetRef ref,
    SavedLessonData lesson,
    ColorScheme colorScheme,
  ) {
    return InkWell(
      onTap: () => context.push('/lesson/${lesson.dayNumber}'),
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
            // Day badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Day',
                      style: AppTypography.caption(color: colorScheme.primary)
                          .copyWith(fontSize: 10),
                    ),
                    Text(
                      '${lesson.dayNumber}',
                      style: AppTypography.h3(color: colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: AppTypography.bodySm(color: colorScheme.onSurface)
                        .copyWith(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.bookOpen,
                        size: 12,
                        color: colorScheme.onSurface.withAlpha(150),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        lesson.category,
                        style: AppTypography.caption(
                          color: colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        LucideIcons.clock,
                        size: 12,
                        color: colorScheme.onSurface.withAlpha(150),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        lesson.duration,
                        style: AppTypography.caption(
                          color: colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Remove button
            IconButton(
              onPressed: () {
                ref.read(savedLessonsProvider.notifier).unsaveLesson(lesson.dayNumber);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed "${lesson.title}" from favorites'),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: colorScheme.primary,
                      onPressed: () {
                        ref.read(savedLessonsProvider.notifier).saveLesson(lesson.dayNumber);
                      },
                    ),
                  ),
                );
              },
              icon: Icon(
                LucideIcons.heartOff,
                color: AppColors.accentCoral,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
