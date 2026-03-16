import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/locale_provider.dart';
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

/// True when [translation] is not effectively the same as [arabic] (avoids duplicate text).
bool _isTranslationDifferent(String arabic, String translation) {
  final a = arabic.trim();
  final t = translation.trim();
  if (a.isEmpty || t.isEmpty) return t.isNotEmpty;
  return a != t;
}

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
        backgroundColor: colorScheme.surface,
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
      backgroundColor: colorScheme.surface,
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
          // Dua label (localized: "Dua" / "دعاء")
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
          // Arabic text
          Text(
            dua.arabic,
            style: AppTypography.arabicH2(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: AppSpacing.md),
          // Transliteration
          Text(
            dua.transliteration,
            style: AppTypography.bodySm(color: colorScheme.primary)
                .copyWith(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          // Translation (only if different from Arabic to avoid duplicate text)
          if (_isTranslationDifferent(dua.arabic, dua.translation)) ...[
            Text(
              '"${dua.translation}"',
              style: AppTypography.bodySm(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          // Source
          Text(
            '- ${dua.source}',
            style: AppTypography.caption(color: colorScheme.onSurface.withAlpha(150)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          // Action buttons
          _buildActionButtons(context, ref, dua, isSaved, colorScheme),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    DuaData dua,
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
            onTap: () {
              ref.read(savedDuasProvider.notifier).toggleSaveDua(dua.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSaved ? 'Removed from favorites' : 'Saved to favorites ❤️',
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
            label: 'Copy',
            colorScheme: colorScheme,
            onTap: () {
              final textToCopy = '${dua.arabic}\n\n${dua.transliteration}\n\n"${dua.translation}"\n\n- ${dua.source}';
              Clipboard.setData(ClipboardData(text: textToCopy));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Copied to clipboard! ✓'),
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
            label: 'Share',
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
