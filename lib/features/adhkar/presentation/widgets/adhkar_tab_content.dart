// Adhkar tab body only (search + Saved Adhkar card + category list). Used by LibraryScreen; no header/tabs.
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
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdhkarTabContent extends ConsumerStatefulWidget {
  const AdhkarTabContent({super.key});

  @override
  ConsumerState<AdhkarTabContent> createState() => _AdhkarTabContentState();
}

class _AdhkarTabContentState extends ConsumerState<AdhkarTabContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(libraryAdhkarCategoriesProvider);
    final savedListAsync = ref.watch(savedAdhkarListProvider);
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
            hintText: 'Search adhkar...',
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: AppSpacing.md),
          RoundedListCard(
            title: 'Saved Adhkar',
            subtitle: '$savedCount saved',
            icon: LucideIcons.bookmark,
            onTap: () => context.push('/adhkar/saved'),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: categoriesAsync.when(
              data: (list) {
                final q = _searchQuery.trim().toLowerCase();
                final filtered = q.isEmpty
                    ? list
                    : list
                        .where((c) =>
                            (c.title ?? '')
                                .toLowerCase()
                                .contains(q))
                        .toList();
                if (filtered.isEmpty) {
                  return const LibraryEmptyView(
                    message: 'No adhkar categories yet',
                  );
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final c = filtered[i];
                    final subtitle = c.itemsCount > 0
                        ? '${c.itemsCount} adhkar'
                        : '';
                    return RoundedListCard(
                      title: c.title ?? '',
                      subtitle: subtitle,
                      icon: iconKeyToIconData(c.icon),
                      iconColor: parseHexColor(c.color),
                      onTap: () =>
                          context.push('/adhkar/category/${c.id}'),
                    );
                  },
                );
              },
              loading: () => const LibraryLoadingView(),
              error: (e, _) => LibraryErrorView(
                message: e.toString(),
                onRetry: () =>
                    ref.invalidate(libraryAdhkarCategoriesProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
