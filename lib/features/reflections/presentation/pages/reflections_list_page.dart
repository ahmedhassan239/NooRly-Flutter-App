import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/reflections/domain/reflection_entity.dart';
import 'package:flutter_app/features/reflections/presentation/providers/reflections_provider.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// List of user's saved lesson reflections. Opened from Profile "Your Reflections".
class ReflectionsListPage extends ConsumerWidget {
  const ReflectionsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(authProvider);

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.reflectionsTitle),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              l10n.profileReviewReflections,
              style: AppTypography.body(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final asyncReflections = ref.watch(reflectionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reflectionsTitle),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: asyncReflections.when(
        data: (list) {
          if (list.isEmpty) {
            return _EmptyReflections(emptyCta: l10n.reflectionsEmptyCta);
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(reflectionsListProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final r = list[index];
                return _ReflectionCard(
                  reflection: r,
                  l10n: l10n,
                  colorScheme: colorScheme,
                  onTap: () => _openReflectionDetail(context, r),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.alertCircle, size: 48, color: colorScheme.error),
                const SizedBox(height: AppSpacing.md),
                Text(
                  err.toString(),
                  style: AppTypography.body(color: colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () => ref.refresh(reflectionsListProvider),
                  child: Text(l10n.actionRetry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openReflectionDetail(BuildContext context, ReflectionEntity r) {
    // Expand in place or push detail: show full reflection + lesson context.
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => _ReflectionDetailSheet(
          reflection: r,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _EmptyReflections extends StatelessWidget {
  const _EmptyReflections({required this.emptyCta});
  final String emptyCta;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.pencil,
              size: 64,
              color: colorScheme.primary.withAlpha(128),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.reflectionsEmpty,
              style: AppTypography.h3(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              emptyCta,
              style: AppTypography.body(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(LucideIcons.arrowLeft, size: 20),
              label: Text(l10n.goBack),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  const _ReflectionCard({
    required this.reflection,
    required this.l10n,
    required this.colorScheme,
    required this.onTap,
  });

  final ReflectionEntity reflection;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  static const int _previewLength = 120;

  @override
  Widget build(BuildContext context) {
    final subtitle = reflection.lessonTitle?.isNotEmpty == true
        ? reflection.lessonTitle!
        : 'Lesson ${reflection.lessonId}';
    final contextLabel = reflection.weekNumber != null && reflection.lessonDay != null
        ? l10n.reflectionLessonContextWeek(
            reflection.weekNumber!,
            reflection.lessonDay!,
          )
        : reflection.lessonDay != null
            ? l10n.reflectionLessonContext(reflection.lessonDay!)
            : null;

    final preview = reflection.reflectionText.length > _previewLength
        ? '${reflection.reflectionText.substring(0, _previewLength)}…'
        : reflection.reflectionText;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: AppTypography.h3(color: colorScheme.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (contextLabel != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    contextLabel,
                    style: AppTypography.caption(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (preview.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    preview,
                    style: AppTypography.bodySm(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReflectionDetailSheet extends StatelessWidget {
  const _ReflectionDetailSheet({
    required this.reflection,
    required this.scrollController,
  });

  final ReflectionEntity reflection;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final contextLabel = reflection.weekNumber != null && reflection.lessonDay != null
        ? l10n.reflectionLessonContextWeek(
            reflection.weekNumber!,
            reflection.lessonDay!,
          )
        : reflection.lessonDay != null
            ? l10n.reflectionLessonContext(reflection.lessonDay!)
            : '';

    return SafeArea(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.outline.withAlpha(128),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              children: [
                Text(
                  reflection.lessonTitle?.isNotEmpty == true
                      ? reflection.lessonTitle!
                      : 'Lesson ${reflection.lessonId}',
                  style: AppTypography.h3(color: colorScheme.primary),
                ),
                if (contextLabel.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    contextLabel,
                    style: AppTypography.caption(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Text(
                  reflection.reflectionText,
                  style: AppTypography.body(color: colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
