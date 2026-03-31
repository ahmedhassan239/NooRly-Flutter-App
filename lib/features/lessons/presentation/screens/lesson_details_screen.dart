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
import 'package:flutter_app/features/lessons/presentation/widgets/lesson_bottom_action_bar.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/lesson_renderer.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

class LessonDetailsScreen extends ConsumerWidget {
  const LessonDetailsScreen({super.key, required this.lessonId});

  /// Backend lesson id (e.g. "1", "2") or "day:N" for load-by-day.
  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonDetailsProvider(lessonId));

    return Scaffold(
      appBar: _buildAppBar(context, ref, state),
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

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    LessonDetailsState state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final lesson = state is LessonDetailsLoaded ? state.lesson : null;
    final lessonIdStr = lesson?.id.toString();
    final isSaved = (lessonIdStr == null) ? false : (isItemSaved(ref, 'lesson', lessonIdStr) ?? false);
    final isPending = (lessonIdStr == null) ? false : isItemPending(ref, 'lesson', lessonIdStr);

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
          icon: Icon(
            LucideIcons.heart,
            color: isSaved ? colorScheme.primary : colorScheme.onSurface,
          ),
          tooltip: isSaved ? l10n.actionSaved : l10n.actionSave,
          onPressed: (lessonIdStr == null || isPending)
              ? null
              : () => _toggleSaveLesson(
                    context: context,
                    ref: ref,
                    lessonId: lessonIdStr,
                    currentIsSaved: isSaved,
                  ),
        ),
      ],
    );
  }

  Future<void> _toggleSaveLesson({
    required BuildContext context,
    required WidgetRef ref,
    required String lessonId,
    required bool currentIsSaved,
  }) async {
    final notifier = ref.read(toggleSaveProvider.notifier);
    final result = await notifier.toggle(
      type: 'lesson',
      itemId: lessonId,
      currentIsSaved: currentIsSaved,
    );

    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;
    switch (result) {
      case ToggleSaveResult.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(currentIsSaved ? l10n.removedFromSaved : l10n.savedToFavorites),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      case ToggleSaveResult.notAuthenticated:
        // Reuse existing auth gate route.
        context.push('/login');
        break;
      case ToggleSaveResult.failure:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.couldNotUpdateSavedState),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      case ToggleSaveResult.skipped:
        break;
    }
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
  late bool _isEditingReflection;

  @override
  void initState() {
    super.initState();
    _reflectionController = TextEditingController(text: widget.reflectionText);
    _isEditingReflection = widget.reflectionText.trim().isEmpty;
  }

  @override
  void didUpdateWidget(_LessonContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reflectionText != widget.reflectionText &&
        _reflectionController.text != widget.reflectionText) {
      _reflectionController.text = widget.reflectionText;
    }
    if (!_isEditingReflection && widget.reflectionText.trim().isEmpty) {
      _isEditingReflection = true;
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
                  _buildReflectionSection(context, ref, l10n, colorScheme),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),

        // Sticky bottom bar
        LessonBottomActionBar(
          lessonId: widget.lessonId,
          isCompleted: widget.isCompleted,
          nextLessonId: widget.nextLessonId,
        ),
      ],
    );
  }

  bool get _hasSavedReflection => widget.reflectionText.trim().isNotEmpty;

  Widget _buildReflectionSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final subtitleColor = colorScheme.onSurface.withValues(alpha: 0.65);
    final cardColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.35);
    final borderColor = colorScheme.outline.withValues(alpha: 0.24);
    final textDirection = Directionality.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.lessonPersonalReflection,
          style: AppTypography.h3(color: colorScheme.onSurface).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.lessonWriteThoughts,
          style: AppTypography.caption(color: subtitleColor),
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: borderColor),
          ),
          child: _isEditingReflection || !_hasSavedReflection
              ? _buildReflectionEditor(context, ref, l10n, colorScheme)
              : _buildSavedReflectionView(context, ref, l10n, colorScheme, textDirection),
        ),
      ],
    );
  }

  Widget _buildReflectionEditor(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final inputFill = colorScheme.surface;
    final inputBorder = colorScheme.outline.withValues(alpha: 0.22);
    final hintColor = colorScheme.onSurface.withValues(alpha: 0.42);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _reflectionController,
          minLines: 4,
          maxLines: 8,
          onChanged: (_) {
            ref.read(lessonDetailsProvider(widget.lessonId).notifier).setReflectionText(
                  _reflectionController.text,
                );
          },
          cursorColor: colorScheme.primary,
          decoration: InputDecoration(
            hintText: l10n.lessonWriteThoughts,
            hintStyle: AppTypography.body(color: hintColor),
            filled: true,
            fillColor: inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: BorderSide(color: inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: BorderSide(color: inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: BorderSide(color: colorScheme.primary.withValues(alpha: 0.8), width: 1.5),
            ),
          ),
          style: AppTypography.body(color: colorScheme.onSurface).copyWith(height: 1.55),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_hasSavedReflection)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEditingReflection = false;
                    _reflectionController.text = widget.reflectionText;
                  });
                },
                child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              )
            else
              const SizedBox.shrink(),
            TextButton(
              onPressed: _reflectionController.text.trim().isEmpty
                  ? null
                  : () {
                      ref
                          .read(lessonDetailsProvider(widget.lessonId).notifier)
                          .saveReflection(_reflectionController.text);
                      setState(() => _isEditingReflection = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.lessonReflectionSaved)),
                      );
                    },
              child: Text(
                l10n.lessonSaveReflection,
                style: AppTypography.bodySm(
                  color: colorScheme.primary,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavedReflectionView(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextDirection direction,
  ) {
    final bodyColor = colorScheme.onSurface.withValues(alpha: 0.92);
    final muted = colorScheme.onSurface.withValues(alpha: 0.58);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.reflectionText,
          style: AppTypography.body(color: bodyColor).copyWith(height: 1.6),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: direction == TextDirection.rtl ? Alignment.centerLeft : Alignment.centerRight,
          child: Wrap(
            spacing: AppSpacing.sm,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEditingReflection = true;
                  });
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(lessonDetailsProvider(widget.lessonId).notifier).saveReflection('');
                  setState(() {
                    _isEditingReflection = true;
                    _reflectionController.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.removedFromSaved)),
                  );
                },
                child: Text(
                  l10n.actionDelete,
                  style: AppTypography.bodySm(color: muted).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
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

