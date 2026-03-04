import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/features/hadith/data/library_hadith_api.dart';
import 'package:flutter_app/features/hadith/presentation/widgets/save_hadith_button.dart';
import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart';
import 'package:flutter_app/design_system/colors.dart';
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
    final color = collection.color != null
        ? AppColors.fromHex(collection.color)
        : colorScheme.primary;
    final resolvedColor = color ?? colorScheme.primary;

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
          const SizedBox(width: AppSpacing.sm),
          Icon(
            iconFromKey(collection.icon),
            size: 24,
            color: resolvedColor,
          ),
          const SizedBox(width: AppSpacing.sm),
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
    final text = hadith.text ?? hadith.textEn ?? hadith.textAr ?? '';
    final source = hadith.collectionName != null
        ? '${hadith.collectionName}${hadith.hadithNumber != null ? ', ${hadith.hadithNumber}' : ''}'
        : '';

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
          if (hadith.textAr != null && hadith.textAr!.isNotEmpty)
            Text(
              hadith.textAr!,
              style: AppTypography.arabicH2(color: colorScheme.onSurface),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          if (hadith.textAr != null && hadith.textAr!.isNotEmpty)
            const SizedBox(height: AppSpacing.md),
          Text(
            '"$text"',
            style: AppTypography.bodySm(color: colorScheme.onSurface),
          ),
          if (source.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              '— $source',
              style: AppTypography.caption(
                  color: colorScheme.onSurface.withAlpha(150)),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              SaveHadithButton(hadithId: hadith.id, compact: true),
              const SizedBox(width: AppSpacing.sm),
              _buildActionButton(
                context: context,
                icon: LucideIcons.copy,
                label: 'Copy',
                colorScheme: colorScheme,
                onTap: () {
                  final toCopy = hadith.textAr != null
                      ? '${hadith.textAr}\n\n$text\n\n— $source'
                      : '$text\n\n— $source';
                  Clipboard.setData(ClipboardData(text: toCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Copied to clipboard! ✓'),
                        duration: Duration(seconds: 2)),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildActionButton(
                context: context,
                icon: LucideIcons.share2,
                label: 'Share',
                colorScheme: colorScheme,
                onTap: () {
                  ShareContentDialog.show(
                    context,
                    ShareableContent(
                      id: hadith.id.toString(),
                      arabic: hadith.textAr ?? '',
                      transliteration: '',
                      translation: text,
                      source: source,
                      title: 'Share Hadith',
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
