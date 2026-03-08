import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/library_tabs.dart';
import 'package:flutter_app/design_system/widgets/noorly_section_icon.dart'
    show NoorlySectionIcon, noorlySectionIconGap;
import 'package:flutter_app/features/adhkar/presentation/adhkar_mock_data.dart';
import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart'
    show noorlyEmojiTasbih;
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdhkarHubPage extends StatefulWidget {
  const AdhkarHubPage({super.key});

  @override
  State<AdhkarHubPage> createState() => _AdhkarHubPageState();
}

class _AdhkarHubPageState extends State<AdhkarHubPage> {
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
    final filteredCategories = _searchQuery.isEmpty
        ? AdhkarMockData.categories
        : AdhkarMockData.categories
            .where((cat) => cat.title
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

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
                        _buildSearchBar(colorScheme),
                        const SizedBox(height: AppSpacing.lg),
                        _buildCategoriesList(context, filteredCategories, colorScheme),
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
          hintText: 'Search adhkar...',
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

  Widget _buildCategoriesList(
    BuildContext context,
    List<AdhkarCategory> categories,
    ColorScheme colorScheme,
  ) {
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
                'No adhkar found',
                style: AppTypography.body(color: colorScheme.onSurface.withAlpha(150)),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: _buildCategoryCard(context, category, colorScheme),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    AdhkarCategory category,
    ColorScheme colorScheme,
  ) {
    final isSavedCategory = category.id == 'saved';

    return InkWell(
      onTap: () {
        if (isSavedCategory) {
          context.push('/adhkar/saved');
        } else {
          context.push('/adhkar/category/${category.id}');
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
            NoorlySectionIcon(icon: noorlyEmojiTasbih),
            const SizedBox(width: noorlySectionIconGap),
            // Content
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
                    category.subtitle,
                    style: AppTypography.caption(
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
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
