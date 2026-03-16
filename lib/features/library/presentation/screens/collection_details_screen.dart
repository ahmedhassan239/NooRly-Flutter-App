/// Collection detail: title + list of items (text, translation, reference).
/// Placeholder actions: Save/Copy/Share/Listen (disabled / TODO).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/library/data/dto/collection_item_dto.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/features/library/presentation/widgets/library_state_views.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CollectionDetailsScreen extends ConsumerWidget {
  const CollectionDetailsScreen({
    super.key,
    required this.scopeKey,
    required this.collectionId,
  });

  final String scopeKey;
  final int collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final detailsAsync = ref.watch(libraryCollectionDetailsProvider(
      (scopeKey: scopeKey, collectionId: collectionId),
    ));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: detailsAsync.when(
          data: (d) => Text(d?.title ?? 'Collection'),
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
                if (detail == null || detail.items.isEmpty) {
                  return const LibraryEmptyView(
                    message: 'No items in this collection',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: detail.items.length,
                  itemBuilder: (_, i) => _ItemCard(
                    item: detail.items[i],
                    colorScheme: colorScheme,
                  ),
                );
              },
              loading: () => const LibraryLoadingView(),
              error: (e, _) => LibraryErrorView(
                message: e.toString(),
                onRetry: () => ref.invalidate(
                  libraryCollectionDetailsProvider(
                    (scopeKey: scopeKey, collectionId: collectionId),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.colorScheme,
  });

  final CollectionItemDto item;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
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
          Text(
            item.text,
            style: AppTypography.body(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          if (item.translation != null && item.translation!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              item.translation!,
              style: AppTypography.bodySm(
                color: colorScheme.onSurface.withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (item.referenceLabel.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.referenceLabel,
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
              _PlaceholderAction(
                icon: LucideIcons.bookmark,
                label: 'Save',
                colorScheme: colorScheme,
              ),
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

/// Placeholder action button (disabled / TODO - no fake behavior).
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
