import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/saved/data/saved_api.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Saved items screen: All / Duas / Adhkar / Verses / Hadith with tabs.
/// Navigate from Profile "Saved Duas" quick action.
class SavedItemsPage extends ConsumerWidget {
  const SavedItemsPage({super.key});

  static const List<String> _tabTypes = ['all', 'dua', 'adhkar', 'verse', 'hadith'];
  static const List<String> _tabLabels = ['All', 'Duas', 'Adhkar', 'Verses', 'Hadith'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final auth = ref.watch(authProvider);

    if (!auth.isAuthenticated) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Saved'),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            'Sign in to view saved items',
            style: AppTypography.body(color: colorScheme.onSurface),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: _tabTypes.length,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Saved'),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _tabLabels.map((l) => Tab(text: l)).toList(),
          ),
        ),
        body: TabBarView(
          children: _tabTypes.map((type) => _TabContent(type: type)).toList(),
        ),
      ),
    );
  }
}

class _TabContent extends ConsumerWidget {
  const _TabContent({required this.type});
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    if (type == 'all') {
      final async = ref.watch(savedAllListProvider);
      return async.when(
        data: (result) => _buildList(
          context,
          ref,
          colorScheme,
          result.items
              .map((u) => _DisplayItem(
                    type: u.type,
                    title: u.title,
                    snippet: u.snippet,
                    referenceId: u.referenceId?.toString() ?? '',
                  ))
              .toList(),
          isEmpty: result.items.isEmpty,
          onRefresh: () => ref.invalidate(savedAllListProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, ref, colorScheme, () => ref.invalidate(savedAllListProvider)),
      );
    }

    if (type == 'dua') {
      final async = ref.watch(savedDuaListProvider);
      return async.when(
        data: (items) => _buildList(
          context,
          ref,
          colorScheme,
          items
              .map((u) => _DisplayItem(
                    type: 'dua',
                    title: u.title ?? 'Dua',
                    snippet: (u.text ?? u.textAr ?? '').length > 80
                        ? '${(u.text ?? u.textAr ?? '').substring(0, 80)}…'
                        : (u.text ?? u.textAr ?? ''),
                    referenceId: u.id.toString(),
                  ))
              .toList(),
          isEmpty: items.isEmpty,
          onRefresh: () => ref.invalidate(savedDuaListProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, ref, colorScheme, () => ref.invalidate(savedDuaListProvider)),
      );
    }

    if (type == 'adhkar') {
      final async = ref.watch(savedAdhkarListProvider);
      return async.when(
        data: (items) => _buildList(
          context,
          ref,
          colorScheme,
          items
              .map((u) => _DisplayItem(
                    type: 'adhkar',
                    title: u.title ?? 'Dhikr',
                    snippet: (u.text ?? u.textAr ?? '').length > 80
                        ? '${(u.text ?? u.textAr ?? '').substring(0, 80)}…'
                        : (u.text ?? u.textAr ?? ''),
                    referenceId: u.id.toString(),
                  ))
              .toList(),
          isEmpty: items.isEmpty,
          onRefresh: () => ref.invalidate(savedAdhkarListProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, ref, colorScheme, () => ref.invalidate(savedAdhkarListProvider)),
      );
    }

    if (type == 'verse') {
      final async = ref.watch(savedVerseListProvider);
      return async.when(
        data: (items) => _buildList(
          context,
          ref,
          colorScheme,
          items
              .map((u) => _DisplayItem(
                    type: 'verse',
                    title: u.reference ?? '${u.surahNameEn ?? ''} ${u.ayahNumber}',
                    snippet: (u.text ?? u.textAr ?? '').length > 80
                        ? '${(u.text ?? u.textAr ?? '').substring(0, 80)}…'
                        : (u.text ?? u.textAr ?? ''),
                    referenceId: u.id.toString(),
                  ))
              .toList(),
          isEmpty: items.isEmpty,
          onRefresh: () => ref.invalidate(savedVerseListProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, ref, colorScheme, () => ref.invalidate(savedVerseListProvider)),
      );
    }

    if (type == 'hadith') {
      final async = ref.watch(savedHadithListProvider);
      return async.when(
        data: (items) => _buildList(
          context,
          ref,
          colorScheme,
          items
              .map((u) => _DisplayItem(
                    type: 'hadith',
                    title: u.collectionName ?? u.collection ?? 'Hadith',
                    snippet: (u.text ?? u.textAr ?? u.textEn ?? '').length > 80
                        ? '${(u.text ?? u.textAr ?? u.textEn ?? '').substring(0, 80)}…'
                        : (u.text ?? u.textAr ?? u.textEn ?? ''),
                    referenceId: u.id.toString(),
                  ))
              .toList(),
          isEmpty: items.isEmpty,
          onRefresh: () => ref.invalidate(savedHadithListProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, ref, colorScheme, () => ref.invalidate(savedHadithListProvider)),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    List<_DisplayItem> items, {
    required bool isEmpty,
    required VoidCallback onRefresh,
  }) {
    if (isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.bookMarked, size: 48, color: colorScheme.outline),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No saved items',
              style: AppTypography.body(color: colorScheme.onSurface.withAlpha(150)),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => _SavedItemCard(
          item: items[index],
          colorScheme: colorScheme,
          onTap: () => _navigateToDetail(context, items[index]),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, _DisplayItem item) {
    switch (item.type) {
      case 'hadith':
        context.push('/hadith/${item.referenceId}');
        break;
      case 'verse':
        context.push('/verses/${item.referenceId}');
        break;
      case 'dua':
        context.push('/dua/${item.referenceId}');
        break;
      case 'adhkar':
        context.push('/adhkar/${item.referenceId}');
        break;
      default:
        break;
    }
  }

  Widget _buildError(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.alertCircle, size: 48, color: colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Could not load saved items',
              style: AppTypography.body(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisplayItem {
  const _DisplayItem({
    required this.type,
    required this.title,
    required this.snippet,
    required this.referenceId,
  });
  final String type;
  final String title;
  final String snippet;
  final String referenceId;
}

class _SavedItemCard extends StatelessWidget {
  const _SavedItemCard({
    required this.item,
    required this.colorScheme,
    required this.onTap,
  });
  final _DisplayItem item;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  static String _typeLabel(String type) {
    switch (type) {
      case 'hadith':
        return 'Hadith';
      case 'verse':
        return 'Verse';
      case 'dua':
        return 'Dua';
      case 'adhkar':
        return 'Dhikr';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colorScheme.outline.withAlpha(128)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _typeLabel(item.type),
                    style: AppTypography.caption(
                      color: colorScheme.primary,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: AppTypography.bodySm(color: colorScheme.onSurface)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  if (item.snippet.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.snippet,
                      style: AppTypography.caption(
                        color: colorScheme.onSurface.withAlpha(180),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(LucideIcons.chevronRight, size: 20, color: colorScheme.onSurface.withAlpha(150)),
          ],
        ),
      ),
    );
  }
}
