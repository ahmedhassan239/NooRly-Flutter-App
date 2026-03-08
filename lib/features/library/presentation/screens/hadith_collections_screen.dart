/// Hadith collections list (all from API, no category). No mock data.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/features/library/presentation/widgets/library_state_views.dart';
import 'package:flutter_app/features/library/utils/noorly_icon_mapper.dart';
import 'package:flutter_app/features/library/presentation/widgets/rounded_list_card.dart';

class HadithCollectionsScreen extends ConsumerWidget {
  const HadithCollectionsScreen({
    super.key,
    required this.categoryId,
  });

  /// Ignored; kept for route /library/hadith/category/:categoryId. All collections are shown.
  final int categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final collectionsAsync = ref.watch(hadithCollectionsAllProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Collections'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: collectionsAsync.when(
                data: (list) {
                  if (list.isEmpty) {
                    return const LibraryEmptyView(
                      message: 'No collections yet',
                    );
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final c = list[i];
                      final subtitle = '${c.itemsCount} hadith';
                      return RoundedListCard(
                        title: c.title,
                        subtitle: subtitle,
                        icon: iconForHadithCollection(c.icon),
                        onTap: () => context.push(
                          '/library/hadith/collection/${c.id}',
                        ),
                      );
                    },
                  );
                },
                loading: () => const LibraryLoadingView(),
                error: (e, _) => LibraryErrorView(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(hadithCollectionsAllProvider),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
