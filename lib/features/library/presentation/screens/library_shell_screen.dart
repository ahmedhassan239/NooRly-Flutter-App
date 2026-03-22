/// Library shell: single tab row + body from StatefulNavigationShell (IndexedStack).
/// Tab taps call navigationShell.goBranch(index); selected state from navigationShell.currentIndex.
/// There is only ONE tabs layer here; detail pages (e.g. /verses/collection/:id) are child routes
/// of each branch, so they do not create a second tab bar. Data is preserved via keepAlive on providers.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/bottom_nav.dart';
import 'package:flutter_app/features/library/data/dto/content_scope_dto.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/features/library/presentation/widgets/library_state_views.dart';
import 'package:flutter_app/features/library/utils/library_utils.dart'
    show libraryTabLeading, resolveContentScopeEmoji;
import 'package:flutter_app/l10n/generated/app_localizations.dart';

/// Fixed branch order: matches StatefulShellRoute branches (duas=0, adhkar=1, hadith=2, verses=3).
const List<String> _libraryTabKeys = ['duas', 'adhkar', 'hadith', 'verses'];

class LibraryShellScreen extends ConsumerWidget {
  const LibraryShellScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final tabsAsync = ref.watch(libraryTabsProvider);
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(colorScheme),
                Expanded(
                  child: tabsAsync.when(
                    data: (apiTabs) {
                      final tabs = _tabsInBranchOrder(apiTabs);
                      if (tabs.isEmpty) {
                        return LibraryEmptyView(
                          message: AppLocalizations.of(context)!.libraryNoTabsAvailable,
                        );
                      }
                      return Column(
                        children: [
                          _buildTabBar(
                            context,
                            tabs,
                            colorScheme,
                            currentIndex,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Expanded(
                            child: navigationShell,
                          ),
                        ],
                      );
                    },
                    loading: () => const Expanded(
                      child: LibraryLoadingView(),
                    ),
                    error: (e, _) => LibraryErrorView(
                      message: e.toString(),
                      onRetry: () => ref.invalidate(libraryTabsProvider),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  /// Order API tabs to match branch index: duas, adhkar, hadith, verses.
  List<ContentScopeDto> _tabsInBranchOrder(List<ContentScopeDto> apiTabs) {
    final byKey = {for (final t in apiTabs) t.key: t};
    return _libraryTabKeys
        .map((key) => byKey[key])
        .whereType<ContentScopeDto>()
        .toList();
  }

  static Widget _buildHeader(ColorScheme colorScheme) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.libraryTitle,
              style: AppTypography.h2(color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(
    BuildContext context,
    List<ContentScopeDto> tabs,
    ColorScheme colorScheme,
    int currentIndex,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant.withAlpha(50),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final t = tabs[index];
          final emoji = resolveContentScopeEmoji(t.icon, t.key);
          final iconUrl = t.iconUrl?.trim();
          final isActive = index == currentIndex;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                onTap: () {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index != currentIndex,
                  );
                },
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? colorScheme.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      libraryTabLeading(emoji: emoji, iconUrl: iconUrl),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          _localizedTabLabel(context, t),
                          style: AppTypography.caption(
                            color: isActive
                                ? colorScheme.onSurface
                                : colorScheme.onSurface.withAlpha(150),
                          ).copyWith(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  static String _localizedTabLabel(BuildContext context, ContentScopeDto t) {
    final l10n = AppLocalizations.of(context)!;
    switch (t.key) {
      case 'duas': return l10n.libraryDuas;
      case 'hadith': return l10n.libraryHadith;
      case 'verses': return l10n.libraryVerses;
      case 'adhkar': return l10n.libraryAdhkar;
      default: return t.label;
    }
  }
}
