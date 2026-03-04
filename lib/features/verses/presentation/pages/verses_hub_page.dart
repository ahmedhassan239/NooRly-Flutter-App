import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/library_tabs.dart';
import 'package:flutter_app/features/verses/data/library_verses_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VersesHubPage extends ConsumerWidget {
  const VersesHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoriesAsync = ref.watch(libraryVersesCategoriesProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(colorScheme),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LibraryTabs(),
                        const SizedBox(height: AppSpacing.lg),
                        categoriesAsync.when(
                          data: (categories) {
                            if (categories.isEmpty) {
                              return _buildEmpty(colorScheme);
                            }
                            return _buildCategoriesList(
                                context, categories, colorScheme);
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
            'Library',
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
              'No verse categories yet',
              style: AppTypography.body(
                  color: colorScheme.onSurface.withAlpha(150)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    List<LibraryVerseCategory> categories,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: InkWell(
            onTap: () =>
                context.push('/verses/category/${category.id}'),
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
                      borderRadius:
                          BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(
                      LucideIcons.bookOpen,
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
                          category.name,
                          style: AppTypography.bodySm(
                                  color: colorScheme.onSurface)
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        if (category.description != null &&
                            category.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            category.description!,
                            style: AppTypography.caption(
                              color: colorScheme.onSurface
                                  .withAlpha(150),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
