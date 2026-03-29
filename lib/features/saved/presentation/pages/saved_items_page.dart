import 'package:flutter/material.dart';
import 'package:flutter_app/core/content/content_display_normalize.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/saved/data/saved_api.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Saved items screen: All / Duas / Adhkar / Verses / Hadith / Lessons with tabs.
/// Unified saved items screen (Profile quick action and `/saved`).
class SavedItemsPage extends ConsumerWidget {
  const SavedItemsPage({super.key});

  /// First non-empty raw field, normalized for list preview (no huge gaps / tail noise).
  static String _savedSnippetPreview(String? a, [String? b, String? c]) {
    final raw = (a != null && a.trim().isNotEmpty)
        ? a
        : (b != null && b.trim().isNotEmpty)
            ? b
            : (c ?? '');
    final n = ContentDisplayNormalize.forDisplay(raw);
    if (n.length <= 80) return n;
    return '${n.substring(0, 80)}…';
  }

  static const List<String> _tabTypes = [
    'all',
    'dua',
    'adhkar',
    'verse',
    'hadith',
    'lesson',
  ];

  List<String> _tabLabels(AppLocalizations l10n) => [
    l10n.savedTabAll,
    l10n.savedTabDuas,
    l10n.savedTabAdhkar,
    l10n.savedTabVerses,
    l10n.savedTabHadith,
    l10n.savedTabLessons,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final auth = ref.watch(authProvider);

    final l10n = AppLocalizations.of(context)!;

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.savedTitle),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            l10n.savedSignInToView,
            style: AppTypography.body(color: colorScheme.onSurface),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: _tabTypes.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.savedTitle),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _tabLabels(l10n).map((label) => Tab(text: label)).toList(),
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
                    type: _normalizeSavedType(u.type),
                    title: u.title,
                    snippet: u.snippet,
                    referenceId: _resolveReferenceId(u.referenceId, fallback: u.id),
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
                    title: u.title ?? AppLocalizations.of(context)!.savedTypeDua,
                    snippet: SavedItemsPage._savedSnippetPreview(
                      u.text,
                      u.textAr,
                    ),
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
                    title: u.title ?? AppLocalizations.of(context)!.savedTypeAdhkar,
                    snippet: SavedItemsPage._savedSnippetPreview(
                      u.text,
                      u.textAr,
                    ),
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
                    snippet: SavedItemsPage._savedSnippetPreview(
                      u.text,
                      u.textAr,
                    ),
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
                    title: u.collectionName ?? u.collection ?? AppLocalizations.of(context)!.savedTypeHadith,
                    snippet: SavedItemsPage._savedSnippetPreview(
                      u.text,
                      u.textAr,
                      u.textEn,
                    ),
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

    if (type == 'lesson') {
      final async = ref.watch(savedLessonListProvider);
      final l10n = AppLocalizations.of(context)!;
      final localeCode = ref.watch(localeControllerProvider).languageCode;
      return async.when(
        data: (items) => _buildList(
          context,
          ref,
          colorScheme,
          items
              .map(
                (u) => _DisplayItem(
                  type: 'lesson',
                  title: _lessonDisplayTitle(u, localeCode, l10n.savedTypeLesson),
                  snippet: _lessonDisplaySnippet(u, localeCode),
                  referenceId: u.id.toString(),
                ),
              )
              .toList(),
          isEmpty: items.isEmpty,
          onRefresh: () => ref.invalidate(savedLessonListProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, ref, colorScheme, () => ref.invalidate(savedLessonListProvider)),
      );
    }

    return const SizedBox.shrink();
  }

  static String _lessonDisplayTitle(
    SavedLessonItem u,
    String localeCode,
    String placeholder,
  ) {
    final t = u.localizedTitle(localeCode).trim();
    return t.isNotEmpty ? t : placeholder;
  }

  static String _lessonDisplaySnippet(SavedLessonItem u, String localeCode) {
    final fromApi = u.localizedSnippet(localeCode);
    if (fromApi.isNotEmpty) return fromApi;
    final d = u.dayNumber;
    final w = u.weekNumber;
    if (d == null && w == null) return '';
    final parts = <String>[];
    if (d != null) parts.add('Day $d');
    if (w != null) parts.add('Week $w');
    return parts.join(' · ');
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
              AppLocalizations.of(context)!.savedNoItems,
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
        ),
      ),
    );
  }

  static String _normalizeSavedType(String rawType) {
    final t = rawType.trim().toLowerCase();
    if (t == 'dhikr') return 'adhkar';
    if (t == 'adhkars') return 'adhkar';
    if (t == 'ayah' || t == 'quran') return 'verse';
    if (t == 'verses') return 'verse';
    if (t == 'duas') return 'dua';
    if (t == 'hadiths') return 'hadith';
    if (t == 'lessons') return 'lesson';
    return t;
  }

  static String _resolveReferenceId(dynamic rawId, {required int fallback}) {
    if (rawId == null) return fallback > 0 ? fallback.toString() : '';
    final id = rawId.toString().trim();
    if (id.isNotEmpty && id != '0' && id != 'null') return id;
    return fallback > 0 ? fallback.toString() : '';
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
              AppLocalizations.of(context)!.savedCouldNotLoad,
              style: AppTypography.body(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 18),
              label: Text(AppLocalizations.of(context)!.actionRetry),
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

/// Saved list rows are display-only except rows with type `lesson` (opens lesson detail).
class _SavedItemCard extends StatelessWidget {
  const _SavedItemCard({
    required this.item,
    required this.colorScheme,
  });
  final _DisplayItem item;
  final ColorScheme colorScheme;

  static String _typeLabel(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 'hadith':
        return l10n.savedTypeHadith;
      case 'verse':
        return l10n.savedTypeVerse;
      case 'dua':
        return l10n.savedTypeDua;
      case 'adhkar':
        return l10n.savedTypeAdhkar;
      case 'lesson':
        return l10n.savedTypeLesson;
      default:
        return type;
    }
  }

  bool get _lessonNavigable =>
      item.type == 'lesson' && item.referenceId.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final card = Container(
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
                  _typeLabel(context, item.type),
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
          if (_lessonNavigable) ...[
            const SizedBox(width: AppSpacing.sm),
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: colorScheme.onSurface.withAlpha(150),
            ),
          ],
        ],
      ),
    );

    if (!_lessonNavigable) {
      return card;
    }

    return InkWell(
      onTap: () {
        final id = Uri.encodeComponent(item.referenceId.trim());
        context.push('/lessons/$id');
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: card,
    );
  }
}
