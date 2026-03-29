import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/content/library_reference_format.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/bottom_nav.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/features/hadith/presentation/hadith_mock_data.dart';
import 'package:flutter_app/features/hadith/presentation/widgets/save_hadith_button.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HadithDetailPage extends ConsumerWidget {
  const HadithDetailPage({required this.hadithId, super.key});

  final String hadithId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hadith = HadithMockDataExtension.getHadithById(hadithId);
    final colorScheme = Theme.of(context).colorScheme;

    if (hadith == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.bookX, size: 64, color: colorScheme.onSurface.withAlpha(100)),
              const SizedBox(height: 16),
              Text(
                'Hadith not found',
                style: AppTypography.h2(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/hadith'),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final hadithIdInt = int.tryParse(hadithId) ?? 0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(context, colorScheme),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: _buildHadithContent(context, ref, hadith, hadithIdInt, colorScheme),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
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
                context.go('/hadith');
              }
            },
            icon: const Icon(LucideIcons.arrowLeft),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppLocalizations.of(context)!.hadith,
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithContent(
    BuildContext context,
    WidgetRef ref,
    HadithData hadith,
    int hadithIdInt,
    ColorScheme colorScheme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final lc = Localizations.localeOf(context).languageCode;
    final dir = LocalizedReligiousContent.textDirectionFor(lc);
    final primary = LocalizedReligiousContent.primaryBody(
      languageCode: lc,
      arabic: hadith.arabic,
      translation: hadith.translation,
    );
    final useArabic = LocalizedReligiousContent.useArabicTypography(lc);
    final sourceLine = formatHadithSourcePlainLine(l10n, lc, hadith.source);

    return Directionality(
      textDirection: dir,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentCoral.withAlpha(25),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              l10n.hadith,
              style: AppTypography.caption(color: AppColors.accentCoral)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            primary,
            style: useArabic
                ? AppTypography.arabicH1(color: colorScheme.onSurface)
                : AppTypography.body(color: colorScheme.onSurface)
                    .copyWith(fontSize: 20, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: colorScheme.outline.withAlpha(128)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.bookOpen,
                  size: 18,
                  color: colorScheme.onSurface.withAlpha(150),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    '${l10n.sourceLabel}: $sourceLine',
                    style: AppTypography.bodySm(color: colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildActionButtons(
            context,
            ref,
            hadith,
            hadithIdInt,
            colorScheme,
            sourceLine,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    HadithData hadith,
    int hadithIdInt,
    ColorScheme colorScheme,
    String sourceLine,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final lc = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SaveHadithButton(hadithId: hadithIdInt),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
                context: context,
                icon: LucideIcons.copy,
                label: l10n.copy,
                colorScheme: colorScheme,
                onTap: () {
                  final textToCopy = LocalizedReligiousContent.composePlainText(
                    languageCode: lc,
                    arabic: hadith.arabic,
                    translation: hadith.translation,
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
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(
              context: context,
              icon: LucideIcons.share2,
              label: l10n.share,
              colorScheme: colorScheme,
              onTap: () {
                ShareContentDialog.show(
                  context,
                  ShareableContent(
                    id: hadith.id,
                    arabic: hadith.arabic,
                    transliteration: hadith.transliteration,
                    translation: hadith.translation,
                    source: sourceLine,
                    shareBadgeLabel: l10n.hadith,
                    title: '${l10n.share} ${l10n.hadith}',
                  ),
                );
              },
            ),
          ],
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
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary.withAlpha(25)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isActive
                ? colorScheme.primary.withAlpha(50)
                : colorScheme.outline.withAlpha(100),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurface.withAlpha(150),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.bodySm(
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(150),
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
