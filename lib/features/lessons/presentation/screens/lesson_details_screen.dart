import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/features/lessons/domain/entities/lesson_entity.dart';
import 'package:flutter_app/features/lessons/presentation/providers/lesson_details_provider.dart';
import 'package:flutter_app/features/lessons/presentation/state/lesson_details_state.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/lesson_html_content.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/quran_verses_section.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/hadith_section.dart';
import 'package:flutter_app/features/journey/providers/journey_providers.dart';

class LessonDetailsScreen extends ConsumerWidget {
  const LessonDetailsScreen({super.key, required this.lessonId});

  /// Backend lesson id (e.g. "1", "2") or "day:N" for load-by-day.
  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonDetailsProvider(lessonId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                  text: 'Retry',
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
    final lesson = widget.lesson;
    final dayNumber = lesson.dayNumber;
    final weekNumber = lesson.weekNumber;
    final title = lesson.title;
    final subtitle = lesson.description;
    final readMinutes = lesson.readTime > 0 ? lesson.readTime : 0;
    final categoryLabel = _categoryLabel(lesson.category);
    final bodyContent = _normalizeContent(lesson.content);

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
                      _Chip(label: 'Day $dayNumber', colorScheme: colorScheme),
                      _Chip(label: 'Week $weekNumber', colorScheme: colorScheme),
                      if (widget.isCompleted)
                        _Chip(
                          label: 'Completed',
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
                        '$readMinutes min read',
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

                  // Main content: API only (HTML or plain text with newlines)
                  if (bodyContent.isNotEmpty) ...[
                    _buildContentWidget(context, bodyContent, colorScheme),
                    const SizedBox(height: AppSpacing.xl2),
                  ],

                  // Quran verses (from API)
                  if (lesson.quranVerses.isNotEmpty) ...[
                    QuranVersesSection(verses: lesson.quranVerses),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Hadith items (from lesson; hide if empty)
                  if (lesson.hadithItems.isNotEmpty) ...[
                    HadithSection(items: lesson.hadithItems),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Personal Reflection
                  Text(
                    'Personal Reflection',
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
                    decoration: InputDecoration(
                      hintText: 'Write your thoughts...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                      ),
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                    ),
                    style: AppTypography.body(),
                  ),
                  Row(
                    children: [
                      if (widget.reflectionSaved)
                        Text(
                          'Saved',
                          style: AppTypography.caption(color: AppColors.accentGreen),
                        )
                      else
                        TextButton(
                          onPressed: () {
                            ref
                                .read(lessonDetailsProvider(widget.lessonId).notifier)
                                .saveReflection(_reflectionController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reflection saved')),
                            );
                          },
                          child: const Text('Save reflection'),
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

  /// Unescape backend escaped newlines (e.g. "\\n" -> newline).
  static String _normalizeContent(String s) {
    if (s.isEmpty) return s;
    return s.replaceAll(r'\n', '\n');
  }

  /// Render API content: HTML via LessonHtmlContent, else plain text with newlines.
  static Widget _buildContentWidget(BuildContext context, String bodyContent, ColorScheme colorScheme) {
    final trimmed = bodyContent.trim();
    final looksLikeHtml = trimmed.startsWith('<') ||
        trimmed.contains('<p>') ||
        trimmed.contains('<div') ||
        trimmed.contains('<br');
    if (looksLikeHtml) {
      return LessonHtmlContent(html: bodyContent, textColor: colorScheme.onSurface);
    }
    return SelectableText(
      bodyContent,
      style: AppTypography.body(color: colorScheme.onSurface),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAccent
            ? AppColors.accentGreen.withValues(alpha: 0.15)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: isAccent ? AppColors.accentGreen : colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.caption(
          color: isAccent ? AppColors.accentGreen : colorScheme.onSurface,
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

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        MediaQuery.paddingOf(context).bottom + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3))),
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: isCompleted
                    ? OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.accentGreen,
                          side: BorderSide(color: AppColors.accentGreen),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.check, size: 18, color: AppColors.accentGreen),
                            const SizedBox(width: 8),
                            const Text('Completed'),
                          ],
                        ),
                      )
                    : AppButton(
                        text: 'Mark as Completed',
                        onPressed: () async {
                          await notifier.completeLesson();
                          ref.invalidate(journeyProvider);
                        },
                        icon: Icon(LucideIcons.check, size: 18, color: colorScheme.onPrimary),
                      ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: AppButton(
                  text: nextLessonId != null ? 'Next Lesson →' : 'No more lessons',
                  onPressed: nextLessonId != null
                      ? () => context.push('/lessons/$nextLessonId')
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
