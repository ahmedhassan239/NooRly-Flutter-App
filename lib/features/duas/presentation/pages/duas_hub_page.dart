import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/library_tabs.dart';
import 'package:flutter_app/design_system/widgets/noorly_section_icon.dart'
    show NoorlySectionIcon, noorlySectionIconGap;
import 'package:flutter_app/features/duas/domain/entities/dua_entity.dart';
import 'package:flutter_app/features/duas/providers/duas_providers.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/features/library/utils/library_utils.dart'
    show contentScopeIconUrlForKey;
import 'package:flutter_app/features/library/utils/noorly_icon_mapper.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DuasHubPage extends ConsumerStatefulWidget {
  const DuasHubPage({super.key});

  @override
  ConsumerState<DuasHubPage> createState() => _DuasHubPageState();
}

class _DuasHubPageState extends ConsumerState<DuasHubPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoriesAsync = ref.watch(duaCategoriesFromApiProvider);
    final savedDuasTabIconUrl = ref.watch(libraryTabsProvider).when(
          data: (tabs) => contentScopeIconUrlForKey(tabs, 'duas'),
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
                _buildHeader(context, colorScheme),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LibraryTabs(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildSearchBar(colorScheme),
                        const SizedBox(height: AppSpacing.lg),
                        _buildCategoriesSection(
                          context,
                          categoriesAsync,
                          colorScheme,
                          savedDuasTabIconUrl,
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

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.libraryTitle,
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.outline.withAlpha(128)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: AppTypography.body(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: 'Search duas...',
          hintStyle: AppTypography.body(color: colorScheme.onSurface.withAlpha(100)),
          prefixIcon: Icon(
            LucideIcons.search,
            size: 20,
            color: colorScheme.onSurface.withAlpha(150),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    LucideIcons.x,
                    size: 18,
                    color: colorScheme.onSurface.withAlpha(150),
                  ),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    AsyncValue<List<DuaCategoryEntity>> categoriesAsync,
    ColorScheme colorScheme,
    String? savedDuasTabIconUrl,
  ) {
    return categoriesAsync.when(
      data: (categories) {
        final fromApi = categories.where((c) => c.id != 'saved').toList();
        final filtered = _searchQuery.isEmpty
            ? fromApi
            : fromApi
                .where((c) =>
                    c.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();
        return _buildCategoriesList(
          context,
          filtered,
          colorScheme,
          savedDuasTabIconUrl: savedDuasTabIconUrl,
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.alertCircle,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Could not load categories',
                style: AppTypography.body(color: colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                err.toString(),
                style: AppTypography.caption(color: colorScheme.error),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    List<DuaCategoryEntity> categories,
    ColorScheme colorScheme, {
    String? savedDuasTabIconUrl,
  }) {
    if (categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Icon(
                LucideIcons.searchX,
                size: 48,
                color: colorScheme.onSurface.withAlpha(100),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _searchQuery.isEmpty
                    ? 'No categories yet'
                    : 'No duas found',
                style: AppTypography.body(color: colorScheme.onSurface.withAlpha(150)),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saved Duas (prepended)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: _buildCategoryCard(
            context,
            DuaCategoryEntity(
              id: 'saved',
              title: AppLocalizations.of(context)!.savedCardDuas,
              iconKey: 'bookmark',
              count: 0,
            ),
            colorScheme,
            isSaved: true,
            leadingIconUrlOverride: savedDuasTabIconUrl,
          ),
        ),
        ...categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _buildCategoryCard(
              context,
              category,
              colorScheme,
              isSaved: false,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    DuaCategoryEntity category,
    ColorScheme colorScheme, {
    bool isSaved = false,
    String? leadingIconUrlOverride,
  }) {
    return InkWell(
      onTap: () {
        if (isSaved || category.id == 'saved') {
          context.push('/duas/saved');
        } else {
          context.push('/duas/category/${category.id}');
        }
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colorScheme.outline.withAlpha(128)),
        ),
        child: Row(
          children: [
            NoorlySectionIcon(
              icon: iconForCategory(
                category.iconKey,
                fallbackKey: kCategoryIconFallbackPrayer,
              ),
              iconUrl: leadingIconUrlOverride ?? category.iconUrl,
            ),
            const SizedBox(width: noorlySectionIconGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: AppTypography.bodySm(color: colorScheme.onSurface)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.count > 0
                        ? AppLocalizations.of(context)!.duasCountLabel(category.count)
                        : (isSaved
                            ? AppLocalizations.of(context)!.duasYourSavedDuas
                            : AppLocalizations.of(context)!.duasCountLabel(0)),
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
}
