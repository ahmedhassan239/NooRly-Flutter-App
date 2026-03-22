import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart'
    show noorlyEmojiBookmark;
import 'package:flutter_app/features/hadith/data/library_hadith_api.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/features/library/presentation/widgets/rounded_list_card.dart';
import 'package:flutter_app/features/library/utils/library_utils.dart'
    show contentScopeIconUrlForKey;
import 'package:flutter_app/features/library/utils/noorly_icon_mapper.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HadithHubPage extends ConsumerStatefulWidget {
  const HadithHubPage({super.key});

  @override
  ConsumerState<HadithHubPage> createState() => _HadithHubPageState();
}

class _HadithHubPageState extends ConsumerState<HadithHubPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final collectionsAsync = ref.watch(libraryHadithCollectionsAllProvider);
    final savedListAsync = ref.watch(savedHadithListProvider);
    final savedCount = savedListAsync.when(
      data: (list) => list.length,
      loading: () => 0,
      error: (_, __) => 0,
    );
    final savedHadithTabIconUrl = ref.watch(libraryTabsProvider).when(
          data: (tabs) => contentScopeIconUrlForKey(tabs, 'hadith'),
          loading: () => null,
          error: (_, __) => null,
        );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(colorScheme),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) =>
                        setState(() => _query = value.toLowerCase()),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      prefixIcon: const Icon(Icons.search),
                      hintText: AppLocalizations.of(context)!.searchHadith,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoundedListCard(
                          title: AppLocalizations.of(context)!.savedCardHadith,
                          subtitle: AppLocalizations.of(context)!.savedCountLabel(savedCount),
                          icon: noorlyEmojiBookmark,
                          iconUrl: savedHadithTabIconUrl,
                          onTap: () => context.push('/hadith/saved'),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        collectionsAsync.when(
                          data: (collections) {
                            final filtered = collections.where((c) {
                              if (_query.isEmpty) return true;
                              return c.title.toLowerCase().contains(_query);
                            }).toList();
                            if (filtered.isEmpty) {
                              return _buildEmpty(colorScheme);
                            }
                            return _buildCollectionsList(
                                context, filtered, colorScheme);
                          },
                          loading: () => const Center(
                              child: Padding(
                            padding: EdgeInsets.all(AppSpacing.xl),
                            child: CircularProgressIndicator(),
                          )),
                          error: (_, __) => _buildEmpty(colorScheme),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Text(
            'Hadith',
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(
              LucideIcons.bookOpen,
              size: 48,
              color: colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No hadith collections yet',
              style: AppTypography.body(
                  color: colorScheme.onSurface.withAlpha(150)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionsList(
    BuildContext context,
    List<LibraryHadithCollectionItem> collections,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: collections.map((c) {
        final subtitle = (c.itemsCount ?? 0) > 0
            ? '${c.itemsCount} hadith'
            : '';
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: RoundedListCard(
            title: c.title,
            subtitle: subtitle,
            icon: iconForHadithCollection(c.icon),
            iconUrl: (c.iconUrl != null && c.iconUrl!.trim().isNotEmpty)
                ? c.iconUrl
                : null,
            onTap: () => context.push('/hadith/collection/${c.id}'),
          ),
        );
      }).toList(),
    );
  }
}
