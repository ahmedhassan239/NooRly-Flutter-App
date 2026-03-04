import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/hadith/data/library_hadith_api.dart';
import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Shows all hadith collections (same as hub). Kept for deep-link /hadith/category/:id.
class CategoryHadithPage extends ConsumerStatefulWidget {
  const CategoryHadithPage({required this.categoryId, super.key});

  final String categoryId;

  @override
  ConsumerState<CategoryHadithPage> createState() => _CategoryHadithPageState();
}

class _CategoryHadithPageState extends ConsumerState<CategoryHadithPage> {
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(context, colorScheme),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) =>
                        setState(() => _query = value.toLowerCase()),
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search hadith collections...',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: collectionsAsync.when(
                    data: (collections) {
                      final filtered = collections.where((c) {
                        if (_query.isEmpty) return true;
                        return c.title.toLowerCase().contains(_query);
                      }).toList();
                      if (filtered.isEmpty) {
                        return _buildEmpty(context, colorScheme);
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final c = filtered[index];
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
      BuildContext context, ColorScheme colorScheme) {
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
                context.go('/hadith');
              }
            },
            icon: const Icon(LucideIcons.arrowLeft),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Hadith',
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
              'No hadith collections yet',
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
    LibraryHadithCollectionItem collection,
    ColorScheme colorScheme,
  ) {
    final color = collection.color != null
        ? AppColors.fromHex(collection.color)
        : colorScheme.primary;
    final resolvedColor = color ?? colorScheme.primary;

    return InkWell(
      onTap: () =>
          context.push('/hadith/collection/${collection.id}'),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border:
              Border.all(color: colorScheme.outline.withAlpha(128)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: resolvedColor.withAlpha(25),
                borderRadius:
                    BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                iconFromKey(collection.icon),
                size: 24,
                color: resolvedColor,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                collection.title,
                style: AppTypography.bodySm(
                        color: colorScheme.onSurface)
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: colorScheme.onSurface.withAlpha(100),
            ),
          ],
        ),
      ),
    );
  }
}
