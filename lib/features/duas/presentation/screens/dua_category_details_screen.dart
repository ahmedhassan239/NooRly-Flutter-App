import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart';
import 'package:flutter_app/core/content/providers/content_providers.dart' as content_providers;
import 'package:flutter_app/core/utils/locale_digits.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/domain/entities/dua_entity.dart';
import 'package:flutter_app/features/duas/presentation/duas_mock_data.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_dua_dialog.dart';
import 'package:flutter_app/features/duas/providers/duas_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// True when [translation] is not the same as [arabic], to avoid showing duplicate text.
bool _isTranslationDifferent(String arabic, String translation) {
  final a = arabic.trim();
  final t = translation.trim();
  if (a.isEmpty || t.isEmpty) return t.isNotEmpty;
  return a != t;
}

/// Dua Category Details screen — API-backed list of duas in a category.
/// Route: /duas/category/:categoryId
/// Data: [duaCategoryByIdProvider] for header, [content_providers.duasByCategoryProvider] for list (API: GET /duas/category/:id).
class DuaCategoryDetailsScreen extends ConsumerWidget {
  const DuaCategoryDetailsScreen({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryAsync = ref.watch(duaCategoryByIdProvider(categoryId));
    // API: DuasEndpoints.byCategory(categoryId) via content repository
    final duasAsync = ref.watch(content_providers.duasByCategoryProvider(categoryId));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(context, ref, categoryAsync, duasAsync, colorScheme),
                Expanded(
                  child: duasAsync.when(
                    data: (duas) {
                      if (duas.isEmpty) {
                        return _buildEmptyState(context, colorScheme);
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: duas.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: _buildDuaCard(
                              context,
                              ref,
                              duas[index],
                              colorScheme,
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.alertCircle,
                              size: 48,
                              color: colorScheme.error,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Could not load duas',
                              style: AppTypography.body(color: colorScheme.onSurface),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              err.toString(),
                              style: AppTypography.caption(color: colorScheme.error),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            TextButton(
                              onPressed: () => ref
                                  .invalidate(content_providers.duasByCategoryProvider(categoryId)),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<DuaCategoryEntity?> categoryAsync,
    AsyncValue<List<ContentEntity>> duasAsync,
    ColorScheme colorScheme,
  ) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final title = categoryAsync.valueOrNull?.title ?? 'Category';
    final count = duasAsync.valueOrNull?.length ?? categoryAsync.valueOrNull?.count ?? 0;
    final countLabel = toLocaleDigits(l10n.duasCountLabel(count), locale);

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
                context.go('/duas');
              }
            },
            icon: const Icon(LucideIcons.arrowLeft),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h2(color: colorScheme.onSurface),
                ),
                Text(
                  countLabel,
                  style: AppTypography.caption(
                    color: colorScheme.onSurface.withAlpha(150),
                  ),
                ),
              ],
            ),
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
            Icon(
              LucideIcons.bookOpen,
              size: 64,
              color: colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No duas in this category',
              style: AppTypography.body(
                color: colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaCard(
    BuildContext context,
    WidgetRef ref,
    ContentEntity e,
    ColorScheme colorScheme,
  ) {
    final isSaved = e.isSaved;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colorScheme.outline.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                AppLocalizations.of(context)!.savedTypeDua,
                style: AppTypography.caption(color: colorScheme.primary)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            e.arabicText,
            style: AppTypography.arabicH2(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: AppSpacing.md),
          if ((e.transliteration ?? '').isNotEmpty)
            Text(
              e.transliteration!,
              style: AppTypography.bodySm(color: colorScheme.primary)
                  .copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          if ((e.transliteration ?? '').isNotEmpty) const SizedBox(height: AppSpacing.sm),
          if ((e.translation ?? '').isNotEmpty && _isTranslationDifferent(e.arabicText, e.translation!))
            Text(
              '"${e.translation}"',
              style: AppTypography.bodySm(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
          if ((e.translation ?? '').isNotEmpty && _isTranslationDifferent(e.arabicText, e.translation!))
            const SizedBox(height: AppSpacing.sm),
          if ((e.source ?? '').isNotEmpty)
            Text(
              '- ${e.source}',
              style: AppTypography.caption(
                color: colorScheme.onSurface.withAlpha(150),
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: AppSpacing.md),
          _buildActionButtons(context, ref, e, isSaved, colorScheme),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    ContentEntity e,
    bool isSaved,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: isSaved ? LucideIcons.heartOff : LucideIcons.heart,
            label: 'Save',
            colorScheme: colorScheme,
            isActive: isSaved,
            onTap: () async {
              final notifier = ref.read(content_providers.saveContentProvider.notifier);
              if (isSaved) {
                await notifier.unsaveDua(e.id);
              } else {
                await notifier.saveDua(e.id);
              }
              ref.invalidate(content_providers.duasByCategoryProvider(categoryId));
              ref.invalidate(content_providers.savedDuasProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isSaved
                          ? 'Removed from favorites'
                          : 'Saved to favorites ❤️',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: LucideIcons.copy,
            label: 'Copy',
            colorScheme: colorScheme,
            onTap: () {
              final textToCopy =
                  '${e.arabicText}\n\n${e.transliteration ?? ""}\n\n"${e.translation ?? ""}"\n\n- ${e.source ?? ""}';
              Clipboard.setData(ClipboardData(text: textToCopy));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied to clipboard! ✓'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: LucideIcons.share2,
            label: 'Share',
            colorScheme: colorScheme,
            onTap: () {
              final duaData = DuaData(
                id: e.id,
                arabic: e.arabicText,
                transliteration: e.transliteration ?? '',
                translation: e.translation ?? '',
                source: e.source ?? '',
              );
              ShareDuaDialog.show(context, duaData);
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: LucideIcons.volume2,
            label: 'Listen',
            colorScheme: colorScheme,
            onTap: () {
              if ((e.audioUrl ?? '').isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Audio not available 🔊'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Play: ${e.audioUrl}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary.withAlpha(25)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: isActive
                ? colorScheme.primary.withAlpha(50)
                : colorScheme.outline.withAlpha(100),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurface.withAlpha(150),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption(
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(150),
              ).copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
