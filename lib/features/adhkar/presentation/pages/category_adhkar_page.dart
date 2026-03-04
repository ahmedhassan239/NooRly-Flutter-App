import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart'
    show DhikrEntity;
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/adhkar/providers/adhkar_by_category_id_provider.dart';
import 'package:flutter_app/features/adhkar/providers/saved_adhkar_provider.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/features/library/data/dto/category_dto.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/features/library/utils/library_utils.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart'
    show ToggleSaveResult;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CategoryAdhkarPage extends ConsumerWidget {
  const CategoryAdhkarPage({required this.categoryId, super.key});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(libraryAdhkarCategoriesProvider);
    final adhkarAsync = ref.watch(adhkarByCategoryIdProvider(categoryId));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: categoriesAsync.when(
              data: (categories) {
                final category = _categoryById(categories, categoryId);
                if (category == null) {
                  return _buildNotFound(context, colorScheme);
                }
                return adhkarAsync.when(
                  data: (adhkarList) {
                    return Column(
                      children: [
                        _buildHeader(
                          context,
                          category,
                          adhkarList.length,
                          colorScheme,
                        ),
                        Expanded(
                          child: adhkarList.isEmpty
                              ? _buildEmptyState(context, colorScheme)
                              : ListView.builder(
                                  padding: const EdgeInsets.all(AppSpacing.lg),
                                  itemCount: adhkarList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.md,
                                      ),
                                      child: _buildAdhkarCard(
                                        context,
                                        ref,
                                        categoryId,
                                        adhkarList[index],
                                        colorScheme,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                  loading: () => Column(
                    children: [
                      _buildHeader(
                        context,
                        category,
                        0,
                        colorScheme,
                      ),
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                  error: (e, _) => Column(
                    children: [
                      _buildHeader(
                        context,
                        category,
                        0,
                        colorScheme,
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                e.toString(),
                                textAlign: TextAlign.center,
                                style: AppTypography.body(
                                  color: colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              TextButton(
                                onPressed: () => ref.invalidate(
                                  adhkarByCategoryIdProvider(categoryId),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _buildNotFound(context, colorScheme),
            ),
          ),
        ),
      ),
    );
  }

  CategoryDto? _categoryById(List<CategoryDto> categories, String id) {
    final n = int.tryParse(id);
    if (n == null) return null;
    try {
      return categories.firstWhere((c) => c.id == n);
    } catch (_) {
      return null;
    }
  }

  Widget _buildNotFound(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.bookX,
            size: 64,
            color: colorScheme.onSurface.withAlpha(100),
          ),
          const SizedBox(height: 16),
          Text(
            'Category not found',
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/adhkar'),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    CategoryDto category,
    int adhkarCount,
    ColorScheme colorScheme,
  ) {
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
                context.go('/adhkar');
              }
            },
            icon: const Icon(LucideIcons.arrowLeft),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            iconKeyToIconData(category.icon),
            color: parseHexColor(category.color),
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title ?? '',
                  style: AppTypography.h2(color: colorScheme.onSurface),
                ),
                Text(
                  '$adhkarCount adhkar',
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
              'No adhkar in this category',
              style: AppTypography.body(
                color: colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdhkarCard(
    BuildContext context,
    WidgetRef ref,
    String categoryId,
    DhikrEntity dhikr,
    ColorScheme colorScheme,
  ) {
    final overrides = ref.watch(adhkarSaveOverrideProvider);
    final pending = ref.watch(adhkarSavePendingProvider);
    final isSaved = overrides[dhikr.id] ?? dhikr.isSaved;
    final isSavePending = pending.contains(dhikr.id);
    final arabic = dhikr.arabicText;
    final translation = dhikr.translation ?? '';
    final transliteration = dhikr.transliteration ?? '';
    final source = dhikr.source ?? '';
    final repetition = dhikr.repetitionCount;

    return InkWell(
      onTap: () => context.push('/adhkar/${dhikr.id}'),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colorScheme.outline.withAlpha(128)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Repeat count badge aligned top right
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: colorScheme.outline.withAlpha(100),
                  ),
                ),
                child: Text(
                  'Say ${repetition}x',
                  style: AppTypography.caption(
                    color: colorScheme.onSurface.withAlpha(150),
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (arabic.isNotEmpty)
              Text(
                arabic,
                style: AppTypography.arabicH2(color: colorScheme.onSurface),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            if (arabic.isNotEmpty) const SizedBox(height: AppSpacing.lg),
            if (transliteration.isNotEmpty)
              Text(
                transliteration,
                style: AppTypography.bodySm(color: colorScheme.primary)
                    .copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
            if (transliteration.isNotEmpty) const SizedBox(height: AppSpacing.sm),
            if (translation.isNotEmpty)
              Text(
                '"$translation"',
                style: AppTypography.bodySm(color: colorScheme.onSurface),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
            if (translation.isNotEmpty) const SizedBox(height: AppSpacing.sm),
            if (source.isNotEmpty)
              Text(
                '— $source',
                style: AppTypography.caption(
                  color: colorScheme.onSurface.withAlpha(150),
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
            if (source.isNotEmpty) const SizedBox(height: AppSpacing.sm),
            const SizedBox(height: AppSpacing.lg),
            _buildActionButtons(
              context,
              ref,
              categoryId,
              dhikr,
              isSaved,
              isSavePending,
              colorScheme,
              arabic: arabic,
              transliteration: transliteration,
              translation: translation,
              source: source,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    String categoryId,
    DhikrEntity dhikr,
    bool isSaved,
    bool isSavePending,
    ColorScheme colorScheme, {
    required String arabic,
    required String transliteration,
    required String translation,
    required String source,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildSaveButton(
            context: context,
            ref: ref,
            dhikr: dhikr,
            isSaved: isSaved,
            isSavePending: isSavePending,
            colorScheme: colorScheme,
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
                  '$arabic\n\n$transliteration\n\n"$translation"\n\n— $source';
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
              ShareContentDialog.show(
                context,
                ShareableContent(
                  id: dhikr.id,
                  arabic: arabic,
                  transliteration: transliteration,
                  translation: translation,
                  source: source,
                  title: 'Share Adhkar',
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _toggleSaveAdhkar(
    BuildContext context,
    WidgetRef ref,
    DhikrEntity dhikr,
    bool currentlySaved,
  ) async {
    final result = await ref.read(toggleSaveAdhkarProvider.notifier).toggle(
          dhikr.id,
          currentlySaved,
        );
    if (!context.mounted) return;
    switch (result) {
      case ToggleSaveResult.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentlySaved
                  ? 'Removed from favorites'
                  : 'Saved to favorites',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      case ToggleSaveResult.failure:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not update. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      case ToggleSaveResult.notAuthenticated:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to save items.'),
            duration: Duration(seconds: 2),
          ),
        );
      case ToggleSaveResult.skipped:
        break;
    }
  }

  Widget _buildSaveButton({
    required BuildContext context,
    required WidgetRef ref,
    required DhikrEntity dhikr,
    required bool isSaved,
    required bool isSavePending,
    required ColorScheme colorScheme,
  }) {
    return _buildActionButton(
      context: context,
      icon: LucideIcons.heart,
      label: isSaved ? 'Saved' : 'Save',
      colorScheme: colorScheme,
      isActive: isSaved,
      isEnabled: !isSavePending,
      isLoading: isSavePending,
      onTap: isSavePending
          ? null
          : () => _toggleSaveAdhkar(context, ref, dhikr, isSaved),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    VoidCallback? onTap,
    bool isActive = false,
    bool isEnabled = true,
    bool isLoading = false,
  }) {
    final enabled = isEnabled && onTap != null && !isLoading;
    return InkWell(
      onTap: enabled ? onTap : null,
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
            if (isLoading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              )
            else
              Icon(
                icon,
                size: 18,
                color: !enabled
                    ? colorScheme.onSurface.withAlpha(80)
                    : isActive
                        ? colorScheme.primary
                        : colorScheme.onSurface.withAlpha(150),
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption(
                color: !enabled
                    ? colorScheme.onSurface.withAlpha(80)
                    : isActive
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
