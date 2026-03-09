import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/design_system/widgets/noorly_section_icon.dart'
    show NoorlySectionIcon, noorlySectionIconGap;
import 'package:flutter_app/features/library/utils/noorly_icon_mapper.dart';
import 'package:flutter_app/features/verses/data/library_verses_api.dart';
import 'package:flutter_app/features/verses/presentation/widgets/save_verse_button.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VerseCollectionPage extends ConsumerWidget {
  const VerseCollectionPage({required this.collectionId, super.key});

  final String collectionId;

  int get _id => int.tryParse(collectionId) ?? 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final detailAsync =
        ref.watch(libraryVerseCollectionDetailProvider(_id));

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                      child: detail.verses.isEmpty
                          ? _buildEmpty(context, colorScheme)
                          : ListView.builder(
                              padding: const EdgeInsets.all(
                                  AppSpacing.lg),
                              itemCount: detail.verses.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.md),
                                  child: _buildVerseCard(context, ref,
                                      detail.verses[index],
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
    LibraryVerseCollectionItem collection,
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
                context.go('/verses');
              }
            },
            icon: const Icon(LucideIcons.arrowLeft),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: noorlySectionIconGap),
          NoorlySectionIcon(icon: iconForVerseCollection(collection.icon)),
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
            onPressed: () => context.go('/verses'),
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
          'No verses in this collection',
          style: AppTypography.body(
              color: colorScheme.onSurface.withAlpha(150)),
        ),
      ),
    );
  }

  Widget _buildVerseCard(
    BuildContext context,
    WidgetRef ref,
    LibraryVerseItem verse,
    ColorScheme colorScheme,
  ) {
    final text = verse.text ?? verse.textEn ?? verse.textAr ?? '';
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final refStr = verse.referenceDisplay(isArabic);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border:
            Border.all(color: colorScheme.outline.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  'Verse',
                  style: AppTypography.caption(
                    color: colorScheme.primary,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          if (verse.textAr != null && verse.textAr!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              verse.textAr!,
              style: AppTypography.arabicH2(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ],
          if (verse.textAr != null && verse.textAr!.isNotEmpty)
            const SizedBox(height: AppSpacing.md),
          Text(
            '"$text"',
            style: AppTypography.bodySm(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          if (refStr.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                '— $refStr',
                style: AppTypography.caption(
                    color: colorScheme.onSurface.withAlpha(150)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SaveVerseButton(verseId: verse.id, compact: true),
              const SizedBox(width: AppSpacing.sm),
              _buildActionButton(
                context: context,
                icon: LucideIcons.copy,
                label: AppLocalizations.of(context)!.actionCopy,
                colorScheme: colorScheme,
                onTap: () {
                  final toCopy = verse.textAr != null
                      ? '${verse.textAr}\n\n$text\n\n— $refStr'
                      : '$text\n\n— $refStr';
                  Clipboard.setData(ClipboardData(text: toCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.copiedToClipboard),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildActionButton(
                context: context,
                icon: LucideIcons.share2,
                label: AppLocalizations.of(context)!.actionShare,
                colorScheme: colorScheme,
                onTap: () {
                  ShareContentDialog.show(
                    context,
                    ShareableContent(
                      id: verse.id.toString(),
                      arabic: verse.textAr ?? '',
                      transliteration: '',
                      translation: text,
                      source: refStr,
                      title: AppLocalizations.of(context)!.libraryVerses,
                    ),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildActionButton(
                context: context,
                icon: LucideIcons.volume2,
                label: AppLocalizations.of(context)!.actionListen,
                colorScheme: colorScheme,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.listenComingSoon),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
              color: colorScheme.outline.withAlpha(100)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18,
                color: colorScheme.onSurface.withAlpha(150)),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.caption(
                  color: colorScheme.onSurface.withAlpha(150))
                  .copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
