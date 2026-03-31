import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/features/journey/providers/journey_providers.dart';
import 'package:flutter_app/features/lessons/presentation/providers/lesson_details_provider.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

/// Sticky bottom actions for [LessonDetailsScreen]: primary “complete” and
/// secondary “next / no more lessons”. Layout and spacing are tuned for RTL
/// Arabic and LTR English without clipping or forced Latin typography on Arabic.
class LessonBottomActionBar extends ConsumerWidget {
  const LessonBottomActionBar({
    super.key,
    required this.lessonId,
    required this.isCompleted,
    this.nextLessonId,
  });

  final String lessonId;
  final bool isCompleted;
  final int? nextLessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final notifier = ref.read(lessonDetailsProvider(lessonId).notifier);
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: colorScheme.surface,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.28)),
          ),
        ),
        child: SafeArea(
          top: false,
          minimum: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    isCompleted
                        ? _LessonCompletedBanner(colorScheme: colorScheme)
                        : AppButton(
                            text: l10n.lessonMarkAsCompleted,
                            fullWidth: true,
                            onPressed: () async {
                              await notifier.completeLesson();
                              ref.invalidate(journeyProvider);
                            },
                            icon: Icon(
                              LucideIcons.check,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                    SizedBox(height: AppSpacing.md),
                    AppButton(
                      fullWidth: true,
                      variant: AppButtonVariant.secondary,
                      text: nextLessonId != null
                          ? l10n.lessonNextLesson
                          : l10n.lessonNoMoreLessons,
                      onPressed: nextLessonId != null
                          ? () => context.push('/lessons/$nextLessonId')
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Non-interactive, theme-aware “completed” row — avoids disabled [OutlinedButton]
/// styling that was unreadable in dark mode. Matches action button height and radius.
class _LessonCompletedBanner extends StatelessWidget {
  const _LessonCompletedBanner({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.45),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(LucideIcons.check, size: 20, color: colorScheme.primary),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  l10n.lessonCompleted,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  style: AppTypography.buttonLabel(
                    context,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
