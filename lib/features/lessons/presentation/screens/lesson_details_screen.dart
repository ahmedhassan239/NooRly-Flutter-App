import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/core/utils/locale_digits.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/features/lessons/domain/entities/lesson_entity.dart';
import 'package:flutter_app/features/lessons/presentation/providers/lesson_details_provider.dart';
import 'package:flutter_app/features/lessons/presentation/state/lesson_details_state.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/lesson_renderer.dart';
import 'package:flutter_app/features/journey/providers/journey_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

class LessonDetailsScreen extends ConsumerWidget {
  const LessonDetailsScreen({super.key, required this.lessonId});

  /// Backend lesson id (e.g. "1", "2") or "day:N" for load-by-day.
  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonDetailsProvider(lessonId));

    return Scaffold(
      appBar: _buildAppBar(context),
      body: switch (state) {
        LessonDetailsLoading() => const Center(child: CircularProgressIndicator()),
        LessonDetailsLoaded(:final lesson, :final isCompleted,
            :final reflectionText, :final nextLessonId, :final reflectionSaved) =>
          _LessonContent(
            lessonId: lessonId,
            lesson: lesson,
            isCompleted: isCompleted,
            reflectionText: reflectionText,
            nextLessonId: nextLessonId,
            reflectionSaved: reflectionSaved,
          ),
        LessonDetailsError(:final message) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTypography.body(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: AppLocalizations.of(context)!.lessonRetry,
                  onPressed: () => ref.read(lessonDetailsProvider(lessonId).notifier).load(),
                ),
              ],
            ),
          ),
        ),
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      leading: IconButton(
        icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
        onPressed: () => context.pop(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: null,
      actions: [
        IconButton(
          icon: Icon(LucideIcons.heart, color: colorScheme.onSurface),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _LessonContent extends ConsumerStatefulWidget {
  const _LessonContent({
    required this.lessonId,
    required this.lesson,
    required this.isCompleted,
    required this.reflectionText,
    this.nextLessonId,
    required this.reflectionSaved,
  });

  final String lessonId;
  final LessonEntity lesson;
  final bool isCompleted;
  final String reflectionText;
  final int? nextLessonId;
  final bool reflectionSaved;

  @override
  ConsumerState<_LessonContent> createState() => _LessonContentState();
}

class _LessonContentState extends ConsumerState<_LessonContent> {
  late TextEditingController _reflectionController;

  @override
  void initState() {
    super.initState();
    _reflectionController = TextEditingController(text: widget.reflectionText);
  }

  @override
  void didUpdateWidget(_LessonContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reflectionText != widget.reflectionText &&
        _reflectionController.text != widget.reflectionText) {
      _reflectionController.text = widget.reflectionText;
    }
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = ref.watch(localeControllerProvider).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final lesson = widget.lesson;
    final dayNumber = lesson.dayNumber;
    final weekNumber = lesson.weekNumber;
    final title = lesson.title;
    final subtitle = lesson.description;
    final readMinutes = lesson.readTime > 0 ? lesson.readTime : 0;
    final categoryLabel = _categoryLabel(lesson.category);
    final dayChipLabel = toLocaleDigits(l10n.journeyDayLabel(dayNumber), locale);
    final weekChipLabel = toLocaleDigits(l10n.journeyWeekLabel(weekNumber), locale);
    final minReadLabel = toLocaleDigits(l10n.journeyDurationMinRead(readMinutes), locale);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              180,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chips: Day, Week, Completed
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _Chip(label: dayChipLabel, colorScheme: colorScheme),
                      _Chip(label: weekChipLabel, colorScheme: colorScheme),
                      if (widget.isCompleted)
                        _Chip(
                          label: l10n.lessonCompleted,
                          colorScheme: colorScheme,
                          isAccent: true,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    title,
                    style: AppTypography.h1(color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTypography.body(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        minReadLabel,
                        style: AppTypography.caption(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          categoryLabel,
                          style: AppTypography.caption(
                            color: colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl2),

                  // Structured content blocks (native Flutter widgets).
                  // Includes verses, hadith, callouts, steps, quotes, etc.
                  if (lesson.blocks.isNotEmpty) ...[
                    LessonRenderer(blocks: lesson.blocks),
                    const SizedBox(height: AppSpacing.xl2),
                  ],

                  // Personal Reflection
                  Text(
                    l10n.lessonPersonalReflection,
                    style: AppTypography.h3(color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _reflectionController,
                    maxLines: 4,
                    onChanged: (_) {
                      ref.read(lessonDetailsProvider(widget.lessonId).notifier).setReflectionText(
                            _reflectionController.text,
                          );
                    },
                    cursorColor: colorScheme.primary,
                    decoration: InputDecoration(
                      hintText: l10n.lessonWriteThoughts,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide(color: colorScheme.primary, width: 2),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      hintStyle: AppTypography.body(
                        color: colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                    ),
                    style: AppTypography.body(color: colorScheme.onSurface),
                  ),
                  Row(
                    children: [
                      if (widget.reflectionSaved)
                        Text(
                          l10n.lessonSaved,
                          style: AppTypography.caption(color: colorScheme.primary),
                        )
                      else
                        TextButton(
                          onPressed: () {
                            ref
                                .read(lessonDetailsProvider(widget.lessonId).notifier)
                                .saveReflection(_reflectionController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.lessonReflectionSaved)),
                            );
                          },
                          child: Text(l10n.lessonSaveReflection),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),

        // Sticky bottom bar
        _BottomBar(
          lessonId: widget.lessonId,
          isCompleted: widget.isCompleted,
          nextLessonId: widget.nextLessonId,
        ),
      ],
    );
  }


  String _categoryLabel(dynamic category) {
    if (category is String) {
      if (category.isEmpty) return 'Lesson';
      return '${category[0].toUpperCase()}${category.substring(1)}';
    }
    if (category is LessonCategory) {
      final name = category.name;
      return '${name[0].toUpperCase()}${name.substring(1)}';
    }
    return 'Lesson';
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.colorScheme,
    this.isAccent = false,
  });

  final String label;
  final ColorScheme colorScheme;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final accentColor = colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAccent
            ? accentColor.withValues(alpha: 0.18)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: isAccent
              ? accentColor.withValues(alpha: 0.55)
              : colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.caption(
          color: isAccent ? accentColor : colorScheme.onSurface,
        ).copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
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
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: isCompleted
                          ? _LessonCompletedBanner(colorScheme: colorScheme)
                          : AppButton(
                              text: AppLocalizations.of(context)!.lessonMarkAsCompleted,
                              fullWidth: true,
                              onPressed: () async {
                                await notifier.completeLesson();
                                ref.invalidate(journeyProvider);
                              },
                              icon: Icon(
                                LucideIcons.check,
                                size: 18,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: AppButton(
                        fullWidth: true,
                        variant: AppButtonVariant.secondary,
                        text: nextLessonId != null
                            ? AppLocalizations.of(context)!.lessonNextLesson
                            : AppLocalizations.of(context)!.lessonNoMoreLessons,
                        onPressed: nextLessonId != null
                            ? () => context.push('/lessons/$nextLessonId')
                            : null,
                      ),
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
/// styling that was unreadable in dark mode.
class _LessonCompletedBanner extends StatelessWidget {
  const _LessonCompletedBanner({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.check, size: 20, color: colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            l10n.lessonCompleted,
            style: AppTypography.body(color: colorScheme.onSurface).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
