/// Library screen: single tab bar, one content area. Tab switches update state only (no PUSH).
/// /hadith, /duas, etc. redirect to /library?tab=x; tapping a tab only updates selectedLibraryTabProvider.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/bottom_nav.dart';
import 'package:flutter_app/features/library/data/dto/content_scope_dto.dart';
import 'package:flutter_app/features/library/presentation/providers/library_providers.dart';
import 'package:flutter_app/features/adhkar/presentation/widgets/adhkar_tab_content.dart';
import 'package:flutter_app/features/duas/presentation/widgets/duas_tab_content.dart';
import 'package:flutter_app/features/library/presentation/widgets/hadith_tab_view.dart';
import 'package:flutter_app/features/library/presentation/widgets/library_state_views.dart';
import 'package:flutter_app/features/verses/presentation/widgets/verses_tab_content.dart';
import 'package:flutter_app/features/library/utils/library_utils.dart'
    show resolveContentScopeEmoji;

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key, this.initialTabKey});

  /// From route /library?tab=hadith or redirect from /hadith. Synced to provider once.
  final String? initialTabKey;

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tabsAsync = ref.watch(libraryTabsProvider);
    final selectedKey = ref.watch(selectedLibraryTabProvider);

    if (widget.initialTabKey != null &&
        widget.initialTabKey!.isNotEmpty &&
        ref.read(selectedLibraryTabProvider) != widget.initialTabKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(selectedLibraryTabProvider.notifier).state = widget.initialTabKey!;
        }
      });
    }

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
                  child: tabsAsync.when(
                    data: (tabs) {
                      if (tabs.isEmpty) {
                        return const LibraryEmptyView(
                          message: 'No library tabs available',
                        );
                      }
                      final currentKey = _resolveCurrentTabKey(tabs, selectedKey);
                      final match =
                          tabs.where((t) => t.key == currentKey).toList();
                      final currentLabel =
                          match.isEmpty ? currentKey : match.first.label;
                      return Column(
                        children: [
                          _buildTabBar(context, ref, tabs, colorScheme, currentKey),
                          const SizedBox(height: AppSpacing.md),
                          Expanded(
                            child: _buildTabContent(
                              context,
                              scopeKey: currentKey,
                              scopeLabel: currentLabel,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const LibraryLoadingView(),
                    error: (e, _) => LibraryErrorView(
                      message: e.toString(),
                      onRetry: () =>
                          ref.invalidate(libraryTabsProvider),
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

  String _resolveCurrentTabKey(List<ContentScopeDto> tabs, String selectedKey) {
    if (widget.initialTabKey != null && widget.initialTabKey!.isNotEmpty) {
      final found = tabs.any((t) => t.key == widget.initialTabKey);
      if (found) return widget.initialTabKey!;
    }
    if (selectedKey.isNotEmpty) {
      final found = tabs.any((t) => t.key == selectedKey);
      if (found) return selectedKey;
    }
    return tabs.first.key;
  }

  static Widget _buildHeader(ColorScheme colorScheme) {
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

  Widget _buildTabBar(
    BuildContext context,
    WidgetRef ref,
    List<ContentScopeDto> tabs,
    ColorScheme colorScheme,
    String currentKey,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant.withAlpha(50),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: tabs.map((t) {
          final emoji = resolveContentScopeEmoji(t.icon, t.key);
          final isActive = t.key == currentKey;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                onTap: () {
                  ref.read(selectedLibraryTabProvider.notifier).state = t.key;
                },
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isActive ? colorScheme.surface : Colors.transparent,
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
                      Text(
                        emoji,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          t.label,
                          style: AppTypography.caption(
                            color: isActive ? colorScheme.onSurface : colorScheme.onSurface.withAlpha(150),
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
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context, {
    required String scopeKey,
    required String scopeLabel,
  }) {
    switch (scopeKey) {
      case 'hadith':
        return const HadithTabView();
      case 'duas':
        return const DuasTabContent();
      case 'adhkar':
        return const AdhkarTabContent();
      case 'verses':
        return const VersesTabContent();
      default:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              '$scopeLabel content',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  ),
            ),
          ),
        );
    }
  }
}
