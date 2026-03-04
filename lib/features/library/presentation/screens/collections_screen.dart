/// Collections list for a library category (scopeKey + categoryId).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/features/library/presentation/widgets/app_search_field.dart';
import 'package:flutter_app/features/library/presentation/widgets/library_state_views.dart';
import 'package:flutter_app/features/library/presentation/widgets/rounded_list_card.dart';
import 'package:flutter_app/features/library/utils/library_utils.dart';

class CollectionsScreen extends ConsumerStatefulWidget {
  const CollectionsScreen({
    super.key,
    required this.scopeKey,
    required this.categoryId,
    this.scopeLabel,
  });

  final String scopeKey;
  final int categoryId;
  final String? scopeLabel;

  @override
  ConsumerState<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends ConsumerState<CollectionsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final searchQuery = ref.watch(librarySearchQueryProvider);
    final collectionsAsync = ref.watch(libraryCollectionsProvider(
      (scopeKey: widget.scopeKey, categoryId: widget.categoryId),
    ));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.scopeLabel ?? 'Collections'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSearchField(
                    controller: _searchController,
                    hintText: 'Search collections',
                    onChanged: (v) =>
                        ref.read(librarySearchQueryProvider.notifier).state = v,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: collectionsAsync.when(
                      data: (list) {
                        final filtered = list
                            .where((c) =>
                                c.title
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()))
                            .toList();
                        if (filtered.isEmpty) {
                          return const LibraryEmptyView(
                            message: 'No collections match your search',
                          );
                        }
                        final label =
                            widget.scopeLabel?.toLowerCase() ?? 'items';
                        return ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final c = filtered[i];
                            final subtitle =
                                '${c.itemsCount} $label';
                            return RoundedListCard(
                              title: c.title,
                              subtitle: subtitle,
                              icon: iconKeyToIconData(c.icon),
                              iconColor: parseHexColor(c.color),
                              onTap: () => context.push(
                                '/library/${widget.scopeKey}/collection/${c.id}',
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const LibraryLoadingView(),
                      error: (e, _) => LibraryErrorView(
                        message: e.toString(),
                        onRetry: () => ref.invalidate(libraryCollectionsProvider(
                          (scopeKey: widget.scopeKey,
                              categoryId: widget.categoryId),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
