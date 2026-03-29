import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/core/content/library_reference_format.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart'
    show DhikrEntity;
import 'package:flutter_app/core/utils/locale_digits.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/adhkar/providers/adhkar_by_category_id_provider.dart';
import 'package:flutter_app/features/adhkar/presentation/widgets/save_adhkar_button.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/features/library/data/dto/category_dto.dart';
import 'package:flutter_app/features/library/presentation/widgets/library_card_compact_action_button.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/design_system/widgets/noorly_section_icon.dart'
    show NoorlySectionIcon, noorlySectionIconGap;
import 'package:flutter_app/features/library/utils/noorly_icon_mapper.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
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
                          ref,
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
                        ref,
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
                        ref,
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
    WidgetRef ref,
    CategoryDto category,
    int adhkarCount,
    ColorScheme colorScheme,
  ) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    final countLabel = toLocaleDigits(
      AppLocalizations.of(context)!.itemCountAdhkar(adhkarCount),
      locale,
    );
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
          const SizedBox(width: noorlySectionIconGap),
          NoorlySectionIcon(
            icon: iconForCategory(
              category.icon,
              fallbackKey: kCategoryIconFallbackTasbih,
            ),
            iconUrl: (category.iconUrl != null &&
                    category.iconUrl!.trim().isNotEmpty)
                ? category.iconUrl
                : null,
          ),
          const SizedBox(width: noorlySectionIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title ?? '',
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
    final locale = ref.watch(localeControllerProvider).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final arabic = dhikr.arabicText;
    final translation = dhikr.translation ?? '';
    final transliteration = dhikr.transliteration ?? '';
    final source = formatLooseReligiousSourceLine(
      l10n,
      locale,
      dhikr.source ?? '',
      sourceAr: dhikr.sourceAr,
    );
    final repetition = dhikr.repetitionCount;
    final repetitionLabel = toLocaleDigits(l10n.sayRepetition(repetition), locale);
    final dir = LocalizedReligiousContent.textDirectionFor(locale);
    final primary = LocalizedReligiousContent.primaryBody(
      languageCode: locale,
      arabic: arabic,
      translation: translation,
    );
    final useArabic = LocalizedReligiousContent.useArabicTypography(locale);

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
        child: Directionality(
          textDirection: dir,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
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
                    repetitionLabel,
                    style: AppTypography.caption(
                      color: colorScheme.onSurface.withAlpha(150),
                    ).copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (primary.isNotEmpty)
                Text(
                  primary,
                  style: useArabic
                      ? AppTypography.arabicH2(color: colorScheme.onSurface)
                      : AppTypography.bodySm(color: colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
              if (source.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '— $source',
                  style: AppTypography.caption(
                    color: colorScheme.onSurface.withAlpha(150),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              _buildActionButtons(
                context,
                ref,
                colorScheme,
                arabic: arabic,
                transliteration: transliteration,
                translation: translation,
                source: source,
                dhikrId: dhikr.id,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme, {
    required String arabic,
    required String transliteration,
    required String translation,
    required String source,
    required String dhikrId,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SaveAdhkarButton(adhkarId: dhikrId, compact: true),
        const SizedBox(width: AppSpacing.sm),
        LibraryCardCompactSecondaryButton(
          icon: LucideIcons.copy,
          label: l10n.copy,
          onTap: () {
            final lc = ref.read(localeControllerProvider).languageCode;
            final textToCopy = LocalizedReligiousContent.composePlainText(
              languageCode: lc,
              arabic: arabic,
              translation: translation,
              source: source,
            );
            Clipboard.setData(ClipboardData(text: textToCopy));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.copiedToClipboard),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        const SizedBox(width: AppSpacing.sm),
        LibraryCardCompactSecondaryButton(
          icon: LucideIcons.share2,
          label: l10n.share,
          onTap: () {
            ShareContentDialog.show(
              context,
              ShareableContent(
                id: dhikrId,
                arabic: arabic,
                transliteration: transliteration,
                translation: translation,
                source: source,
                shareBadgeLabel: l10n.adhkar,
                title: '${l10n.share} ${l10n.adhkar}',
              ),
            );
          },
        ),
      ],
    );
  }
}
