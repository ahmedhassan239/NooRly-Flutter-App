import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart';
import 'package:flutter_app/features/hadith/data/library_hadith_api.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                      hintText: 'Search hadith...',
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
                        _buildSavedHadithCard(context, colorScheme, savedCount),
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

  Widget _buildSavedHadithCard(
    BuildContext context,
    ColorScheme colorScheme,
    int savedCount,
  ) {
    return InkWell(
      onTap: () => context.push('/hadith/saved'),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
              color: colorScheme.outline.withAlpha(128)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                LucideIcons.bookmark,
                size: 24,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved Hadith',
                    style: AppTypography.bodySm(
                            color: colorScheme.onSurface)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$savedCount saved',
                    style: AppTypography.caption(
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
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
        final color = c.color != null
            ? AppColors.fromHex(c.color)
            : colorScheme.primary;
        final resolvedColor = color ?? colorScheme.primary;
        final subtitle = (c.itemsCount ?? 0) > 0
            ? '${c.itemsCount} hadith'
            : null;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: InkWell(
            onTap: () => context.push('/hadith/collection/${c.id}'),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                    color: colorScheme.outline.withAlpha(128)),
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
                      iconFromKey(c.icon),
                      size: 24,
                      color: resolvedColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.title,
                          style: AppTypography.bodySm(
                                  color: colorScheme.onSurface)
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: AppTypography.caption(
                              color: colorScheme.onSurface
                                  .withAlpha(150),
                            ),
                          ),
                        ],
                      ],
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
          ),
        );
      }).toList(),
    );
  }
}
