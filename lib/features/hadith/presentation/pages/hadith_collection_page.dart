import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/content/library_reference_format.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/features/hadith/data/library_hadith_api.dart';
import 'package:flutter_app/features/hadith/presentation/widgets/save_hadith_button.dart';
import 'package:flutter_app/features/library/presentation/widgets/library_card_compact_action_button.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_app/design_system/widgets/noorly_section_icon.dart'
    show NoorlySectionIcon, noorlySectionIconGap;
import 'package:flutter_app/features/library/utils/noorly_icon_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HadithCollectionPage extends ConsumerWidget {
  const HadithCollectionPage({required this.collectionId, super.key});

  final String collectionId;

  int get _id => int.tryParse(collectionId) ?? 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final detailAsync =
        ref.watch(libraryHadithCollectionDetailProvider(_id));

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: detailAsync.when(
              data: (detail) {
                if (detail == null) {
                  return _buildNotFound(context, colorScheme);
                }
                return Column(
                  children: [
                    _buildHeader(context, detail.collection,
                        colorScheme),
                    Expanded(
                      child: detail.hadiths.isEmpty
                          ? _buildEmpty(context, colorScheme)
                          : ListView.builder(
                              padding: const EdgeInsets.all(
                                  AppSpacing.lg),
                              itemCount: detail.hadiths.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.md),
                                  child: _buildHadithCard(context,
                                      ref, detail.hadiths[index],
                                      colorScheme),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                  child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              )),
              error: (_, __) => _buildNotFound(context, colorScheme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    LibraryHadithCollectionItem collection,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: colorScheme.outline.withAlpha(128))),
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
          const SizedBox(width: noorlySectionIconGap),
          NoorlySectionIcon(
            icon: iconForHadithCollection(collection.icon),
            iconUrl: (collection.iconUrl != null &&
                    collection.iconUrl!.trim().isNotEmpty)
                ? collection.iconUrl
                : null,
          ),
          const SizedBox(width: noorlySectionIconGap),
          Expanded(
            child: Text(
              collection.title,
              style: AppTypography.h2(color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFound(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.bookX,
              size: 64,
              color: colorScheme.onSurface.withAlpha(100)),
          const SizedBox(height: 16),
          Text(
            'Collection not found',
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/hadith'),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          'No hadith in this collection',
          style: AppTypography.body(
              color: colorScheme.onSurface.withAlpha(150)),
        ),
      ),
    );
  }

  Widget _buildHadithCard(
    BuildContext context,
    WidgetRef ref,
    LibraryHadithItem hadith,
    ColorScheme colorScheme,
  ) {
    final lc = Localizations.localeOf(context).languageCode;
    final text = hadith.text ?? hadith.textEn ?? hadith.textAr ?? '';
    final textAr = hadith.textAr ?? '';
    final primary = LocalizedReligiousContent.libraryPrimaryBody(
      languageCode: lc,
      textAr: hadith.textAr,
      translationOrEn: text,
    );
    final dir = LocalizedReligiousContent.textDirectionFor(lc);
    final useArabic = LocalizedReligiousContent.useArabicTypography(lc);
    final l10n = AppLocalizations.of(context)!;
    final source = formatLibraryHadithReference(
      l10n: l10n,
      languageCode: lc,
      collectionName: hadith.collectionName ?? hadith.collection,
      collectionNameAr: hadith.collectionNameAr,
      hadithNumber: hadith.hadithNumber,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border:
            Border.all(color: colorScheme.outline.withAlpha(128)),
      ),
      child: Directionality(
        textDirection: dir,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  l10n.hadith,
                  style: AppTypography.caption(color: colorScheme.primary)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
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
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SaveHadithButton(hadithId: hadith.id, compact: true),
                const SizedBox(width: AppSpacing.sm),
                LibraryCardCompactSecondaryButton(
                  icon: LucideIcons.copy,
                  label: l10n.copy,
                  onTap: () {
                    final toCopy = LocalizedReligiousContent.composePlainText(
                      languageCode: lc,
                      arabic: textAr,
                      translation: text,
                      source: source,
                    );
                    Clipboard.setData(ClipboardData(text: toCopy));
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
                        id: hadith.id.toString(),
                        arabic: textAr,
                        transliteration: '',
                        translation: text,
                        source: source,
                        shareBadgeLabel: l10n.hadith,
                        title: '${l10n.share} ${l10n.hadith}',
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
