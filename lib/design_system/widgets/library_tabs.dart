import 'package:flutter/material.dart';
import 'package:flutter_app/core/content/domain/entities/content_scope_entity.dart';
import 'package:flutter_app/core/content/providers/content_scope_providers.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/library/utils/library_utils.dart'
    show libraryTabLeading, resolveContentScopeEmoji;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Library Tabs
///
/// Navigation tabs for content hubs. Label and order from API content scopes.
/// Displays emoji icons matching backend/admin visual (e.g. 🤲 Prayer, 📖 Quran).
/// Uses scope-key fallback when API does not send icon.
class LibraryTabs extends ConsumerWidget {
  const LibraryTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).uri.path;
    final colorScheme = Theme.of(context).colorScheme;
    final scopesAsync = ref.watch(contentScopesProvider);

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant.withAlpha(50),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: scopesAsync.when(
          data: (scopes) {
            if (scopes.isEmpty) return const [SizedBox.shrink()];
            final tabs = scopes.map((s) => _scopeToTab(s, colorScheme)).toList();
            return _buildTabButtons(context, tabs, currentPath, colorScheme);
          },
          loading: () => const [SizedBox.shrink()],
          error: (_, __) => const [SizedBox.shrink()],
        ),
      ),
    );
  }

  List<Widget> _buildTabButtons(
    BuildContext context,
    List<_TabItem> tabs,
    String currentPath,
    ColorScheme colorScheme,
  ) {
    return tabs.map((tab) {
      return Expanded(
        child: _TabButton(
          tab: tab,
          isActive: currentPath.startsWith(tab.path),
          colorScheme: colorScheme,
          onTap: () => context.go(tab.path),
        ),
      );
    }).toList();
  }

  _TabItem _scopeToTab(ContentScopeEntity scope, ColorScheme colorScheme) {
    final path = '/${scope.key}';
    final emoji = resolveContentScopeEmoji(scope.iconKey, scope.key);
    return _TabItem(
      emoji: emoji,
      iconUrl: scope.iconUrl,
      label: scope.label,
      path: path,
    );
  }
}


class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.isActive,
    required this.colorScheme,
    required this.onTap,
  });

  final _TabItem tab;
  final bool isActive;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = isActive
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.7);

    return InkWell(
      onTap: onTap,
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
                    color: Colors.black.withValues(alpha: 0.05),
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
            libraryTabLeading(emoji: tab.emoji, iconUrl: tab.iconUrl),
            const SizedBox(width: 6),
            Text(
              tab.label,
              style: AppTypography.caption(color: textColor).copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.emoji,
    this.iconUrl,
    required this.label,
    required this.path,
  });

  final String emoji;
  final String? iconUrl;
  final String label;
  final String path;
}
