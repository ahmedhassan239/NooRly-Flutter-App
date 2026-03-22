import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/library/utils/noorly_icon_mapper.dart';
import 'package:flutter_app/features/library/presentation/widgets/rounded_list_card.dart';
import 'package:flutter_app/features/verses/data/library_verses_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CategoryVersesPage extends ConsumerWidget {
  const CategoryVersesPage({required this.categoryId, super.key});

  final String categoryId;

  int get _categoryIdInt => int.tryParse(categoryId) ?? 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final collectionsAsync =
        ref.watch(libraryVersesCollectionsProvider(_categoryIdInt));
    final categoriesAsync = ref.watch(libraryVersesCategoriesProvider);

    final categoryList = categoriesAsync.valueOrNull ?? [];
    final match =
        categoryList.where((c) => c.id == _categoryIdInt).toList();
    final categoryName =
        match.isEmpty ? 'Category' : match.first.name;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(context, categoryName, colorScheme),
                Expanded(
                  child: collectionsAsync.when(
                    data: (collections) {
                      if (collections.isEmpty) {
                        return _buildEmpty(context, colorScheme);
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: collections.length,
                        itemBuilder: (context, index) {
                          final c = collections[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm),
                            child: _buildCollectionCard(
                                context, c, colorScheme),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                        child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: CircularProgressIndicator(),
                    )),
                    error: (_, __) => _buildEmpty(context, colorScheme),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, String title, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: colorScheme.outline.withAlpha(128))),
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
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: AppTypography.h2(color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.bookOpen,
              size: 64,
              color: colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No collections in this category',
              style: AppTypography.body(
                  color: colorScheme.onSurface.withAlpha(150)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(
    BuildContext context,
    LibraryVerseCollectionItem collection,
    ColorScheme colorScheme,
  ) {
    final subtitle = (collection.itemsCount ?? 0) > 0
        ? '${collection.itemsCount} verses'
        : '';
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: RoundedListCard(
        title: collection.title,
        subtitle: subtitle,
        icon: iconForVerseCollection(collection.icon),
        iconUrl: (collection.iconUrl != null &&
                collection.iconUrl!.trim().isNotEmpty)
            ? collection.iconUrl
            : null,
        onTap: () => context.push('/verses/collection/${collection.id}'),
      ),
    );
  }
}
