/// Hadith collection detail: collection meta + hadiths from API (text, text_ar, text_en, etc.).
/// Optional disabled icon buttons. No mock data.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/core/content/content_display_normalize.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/hadith/presentation/widgets/save_hadith_button.dart';
import 'package:flutter_app/features/library/data/dto/hadith_dto.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/features/library/presentation/widgets/library_state_views.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HadithCollectionDetailsScreen extends ConsumerWidget {
  const HadithCollectionDetailsScreen({
    super.key,
    required this.collectionId,
  });

  final int collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final detailsAsync =
        ref.watch(hadithCollectionDetailsProvider(collectionId));

    return Scaffold(
      appBar: AppBar(
        title: detailsAsync.when(
          data: (d) => Text(
            (d?.collection.title ?? '').isNotEmpty
                ? d!.collection.title
                : 'Collection',
          ),
          loading: () => const Text('Collection'),
          error: (_, __) => const Text('Collection'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: detailsAsync.when(
              data: (detail) {
                if (detail == null || detail.hadiths.isEmpty) {
                  return const LibraryEmptyView(
                    message: 'No items in this collection',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: detail.hadiths.length,
                  itemBuilder: (_, i) => _HadithItemCard(
                    item: detail.hadiths[i],
                    colorScheme: colorScheme,
                  ),
                );
              },
              loading: () => const LibraryLoadingView(),
              error: (e, _) => LibraryErrorView(
                message: e.toString(),
                onRetry: () => ref.invalidate(
                  hadithCollectionDetailsProvider(collectionId),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool _hadithTextDifferent(String? a, String b) {
  final na = ContentDisplayNormalize.forDisplay(a);
  final nb = ContentDisplayNormalize.forDisplay(b);
  if (na.isEmpty) return nb.isNotEmpty;
  return na != nb;
}

class _HadithItemCard extends StatelessWidget {
  const _HadithItemCard({
    required this.item,
    required this.colorScheme,
  });

  final HadithDto item;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final text = ContentDisplayNormalize.forDisplay(item.text);
    final textAr = ContentDisplayNormalize.forDisplay(item.textAr);
    final textEn = ContentDisplayNormalize.forDisplay(item.textEn);
    final showText = text.isNotEmpty;
    final showTextAr = textAr.isNotEmpty && _hadithTextDifferent(item.text, textAr);
    final showTextEn = textEn.isNotEmpty &&
        _hadithTextDifferent(item.text, textEn) &&
        _hadithTextDifferent(item.textAr, textEn);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colorScheme.outline.withAlpha(128),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showText)
            Text(
              text,
              style: AppTypography.body(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          if (showTextAr) ...[
            if (showText) const SizedBox(height: AppSpacing.sm),
            Text(
              textAr,
              style: AppTypography.body(
                color: colorScheme.onSurface.withAlpha(200),
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ],
          if (showTextEn) ...[
            if (showText || showTextAr) const SizedBox(height: AppSpacing.sm),
            Text(
              textEn,
              style: AppTypography.bodySm(
                color: colorScheme.onSurface.withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (item.collectionName != null && item.collectionName!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.collectionName!,
              style: AppTypography.caption(
                color: colorScheme.onSurface.withAlpha(150),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (item.hadithNumber != null || item.chapterNumber != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              [
                if (item.hadithNumber != null) item.hadithNumber.toString(),
                if (item.chapterNumber != null) item.chapterNumber.toString(),
              ].join(' • '),
              style: AppTypography.caption(
                color: colorScheme.onSurface.withAlpha(150),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SaveHadithButton(hadithId: item.id, compact: true),
              const SizedBox(width: AppSpacing.sm),
              _PlaceholderAction(
                icon: LucideIcons.copy,
                label: 'Copy',
                colorScheme: colorScheme,
              ),
              const SizedBox(width: AppSpacing.sm),
              _PlaceholderAction(
                icon: LucideIcons.share2,
                label: 'Share',
                colorScheme: colorScheme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlaceholderAction extends StatelessWidget {
  const _PlaceholderAction({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: null,
      icon: Icon(icon, size: 20, color: colorScheme.onSurface.withAlpha(120)),
      tooltip: '$label (coming soon)',
    );
  }
}
