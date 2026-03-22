import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/core/content/library_reference_format.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/core/utils/locale_digits.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/duas_mock_data.dart';
import 'package:flutter_app/features/duas/providers/saved_duas_provider.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_dua_dialog.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CategoryDuasPage extends ConsumerWidget {
  const CategoryDuasPage({required this.categoryId, super.key});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = DuasMockDataExtension.getCategoryById(categoryId);
    final duas = DuasMockDataExtension.getDuasByCategory(categoryId);
    final colorScheme = Theme.of(context).colorScheme;

    if (category == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.bookX, size: 64, color: colorScheme.onSurface.withAlpha(100)),
              const SizedBox(height: 16),
              Text(
                'Category not found',
                style: AppTypography.h2(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/duas'),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(context, ref, category, duas.length, colorScheme),
                Expanded(
                  child: duas.isEmpty
                      ? _buildEmptyState(context, colorScheme)
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          itemCount: duas.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.md),
                              child: _buildDuaCard(context, ref, duas[index], colorScheme),
                            );
                          },
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
    DuaCategory category,
    int duaCount,
    ColorScheme colorScheme,
  ) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    final countLabel = toLocaleDigits(
      AppLocalizations.of(context)!.duasCountLabel(duaCount),
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
                context.go('/duas');
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
                category.title,
                style: AppTypography.h2(color: colorScheme.onSurface),
              ),
              Text(
                countLabel,
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
            Icon(
              LucideIcons.bookOpen,
              size: 64,
              color: colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No duas found',
              style: AppTypography.body(color: colorScheme.onSurface.withAlpha(150)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaCard(
    BuildContext context,
    WidgetRef ref,
    DuaData dua,
    ColorScheme colorScheme,
  ) {
    final isSaved = ref.watch(isDuaSavedProvider(dua.id));
    final l10n = AppLocalizations.of(context)!;
    final lc = ref.watch(localeControllerProvider).languageCode;
    final dir = LocalizedReligiousContent.textDirectionFor(lc);
    final primary = LocalizedReligiousContent.primaryBody(
      languageCode: lc,
      arabic: dua.arabic,
      translation: dua.translation,
    );
    final useArabic = LocalizedReligiousContent.useArabicTypography(lc);
    final sourceLine = formatLooseReligiousSourceLine(
      l10n,
      lc,
      dua.source,
      sourceAr: dua.sourceAr,
    );

    return Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  l10n.dua,
                  style: AppTypography.caption(color: colorScheme.primary)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              primary,
              style: useArabic
                  ? AppTypography.arabicH2(color: colorScheme.onSurface)
                  : AppTypography.bodySm(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '— $sourceLine',
              style: AppTypography.caption(
                color: colorScheme.onSurface.withAlpha(150),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildActionButtons(context, ref, dua, isSaved, colorScheme, l10n, sourceLine),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    DuaData dua,
    bool isSaved,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    String sourceLine,
  ) {
    final lc = ref.read(localeControllerProvider).languageCode;
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: isSaved ? LucideIcons.heartOff : LucideIcons.heart,
            label: isSaved ? l10n.actionSaved : l10n.save,
            colorScheme: colorScheme,
            isActive: isSaved,
            onTap: () {
              ref.read(savedDuasProvider.notifier).toggleSaveDua(dua.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSaved ? l10n.removedFromSaved : l10n.savedToFavorites,
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: LucideIcons.copy,
            label: l10n.copy,
            colorScheme: colorScheme,
            onTap: () {
              final textToCopy = LocalizedReligiousContent.composePlainText(
                languageCode: lc,
                arabic: dua.arabic,
                translation: dua.translation,
                source: sourceLine,
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
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: LucideIcons.share2,
            label: l10n.share,
            colorScheme: colorScheme,
            onTap: () {
              ShareDuaDialog.show(context, dua);
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
