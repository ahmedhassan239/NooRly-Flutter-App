/// Verses tab content for Library: search, Saved Verses card, collections list.
/// Content only — no Scaffold; parent LibraryShellScreen provides header, tabs, BottomNav.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/features/library/presentation/widgets/app_search_field.dart';
import 'package:flutter_app/features/library/presentation/widgets/library_state_views.dart';
import 'package:flutter_app/features/library/presentation/widgets/rounded_list_card.dart';
import 'package:flutter_app/features/library/utils/library_utils.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_app/features/verses/data/library_verses_api.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VersesTabContent extends ConsumerStatefulWidget {
  const VersesTabContent({super.key});

  @override
  ConsumerState<VersesTabContent> createState() => _VersesTabContentState();
}

class _VersesTabContentState extends ConsumerState<VersesTabContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectionsAsync = ref.watch(verseCollectionsAllProvider);
    final savedListAsync = ref.watch(savedVerseListProvider);
    final savedCount = savedListAsync.when(
      data: (list) => list.length,
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSearchField(
            controller: _searchController,
            hintText: 'Search verses...',
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: AppSpacing.md),
          RoundedListCard(
            title: 'Saved Verses',
            subtitle: '$savedCount saved',
            icon: LucideIcons.bookmark,
            onTap: () => context.push('/verses/saved'),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: collectionsAsync.when(
              data: (list) {
                final q = _searchQuery.trim().toLowerCase();
                final filtered = q.isEmpty
                    ? list
                    : list
                        .where((c) =>
                            c.title.toLowerCase().contains(q))
                        .toList();
                if (filtered.isEmpty) {
                  return const LibraryEmptyView(
                    message: 'No collections yet',
                  );
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final c = filtered[i];
                    final subtitle = c.itemsCount != null && c.itemsCount! > 0
                        ? '${c.itemsCount} verses'
                        : '';
                    return RoundedListCard(
                      title: c.title,
                      subtitle: subtitle,
                      icon: iconKeyToIconData(c.icon),
                      iconColor: parseHexColor(c.color),
                      onTap: () =>
                          context.push('/verses/collection/${c.id}'),
                    );
                  },
                );
              },
              loading: () => const LibraryLoadingView(),
              error: (e, _) => LibraryErrorView(
                message: e.toString(),
                onRetry: () => ref.invalidate(verseCollectionsAllProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
