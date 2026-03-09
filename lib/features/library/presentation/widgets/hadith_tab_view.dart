/// Hadith tab content for Library: search, Saved Hadith card, collections list.
/// Content only — no Scaffold; parent LibraryScreen provides header "Library", tabs, BottomNav.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/design_system/widgets/noorly_section_icon.dart'
    show noorlySectionIconGap;
import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart'
    show noorlyEmojiBookmark;
import 'package:flutter_app/features/library/presentation/widgets/app_search_field.dart';
import 'package:flutter_app/features/library/presentation/widgets/library_state_views.dart';
import 'package:flutter_app/features/library/presentation/widgets/rounded_list_card.dart';
import 'package:flutter_app/features/library/utils/noorly_icon_mapper.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

class HadithTabView extends ConsumerStatefulWidget {
  const HadithTabView({super.key});

  @override
  ConsumerState<HadithTabView> createState() => _HadithTabViewState();
}

class _HadithTabViewState extends ConsumerState<HadithTabView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final collectionsAsync = ref.watch(hadithCollectionsAllProvider);
    final savedListAsync = ref.watch(savedHadithListProvider);
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
            hintText: l10n.searchHadith,
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: AppSpacing.md),
          RoundedListCard(
            title: l10n.savedCardHadith,
            subtitle: l10n.savedCountLabel(savedCount),
            icon: noorlyEmojiBookmark,
            onTap: () => context.push('/hadith/saved'),
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
                  return LibraryEmptyView(
                    message: l10n.libraryNoCollectionsYet,
                  );
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final c = filtered[i];
                    final subtitle = c.itemsCount > 0
                        ? l10n.itemCountHadith(c.itemsCount)
                        : '';
                    return RoundedListCard(
                      title: c.title,
                      subtitle: subtitle,
                      icon: iconForHadithCollection(c.icon),
                      onTap: () =>
                          context.push('/hadith/collection/${c.id}'),
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
        ],
      ),
    );
  }
}
