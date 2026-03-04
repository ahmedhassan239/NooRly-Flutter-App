import 'package:flutter/material.dart';
import 'package:flutter_app/core/content/domain/entities/content_scope_entity.dart';
import 'package:flutter_app/core/content/providers/content_scope_providers.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Library Tabs
///
/// Navigation tabs for content hubs. Built 100% from API content scopes:
/// label, icon, color; order from API. No hardcoded tabs.
/// If icon or color is null, fallback to default icon and theme primary.
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
            return _buildTabButtons(context, tabs, currentPath, colorScheme, scopes);
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
    List<ContentScopeEntity>? scopes,
  ) {
    return tabs.asMap().entries.map((entry) {
      final i = entry.key;
      final tab = entry.value;
      final scopeColor = scopes != null && i < scopes.length
          ? AppColors.fromHex(scopes[i].iconColor)
          : null;
      return Expanded(
        child: _TabButton(
          tab: tab,
          isActive: currentPath.startsWith(tab.path),
          colorScheme: colorScheme,
          accentColor: scopeColor,
          onTap: () => context.go(tab.path),
        ),
      );
    }).toList();
  }

  _TabItem _scopeToTab(ContentScopeEntity scope, ColorScheme colorScheme) {
    final path = '/${scope.key}';
    final icon = iconFromKey(scope.iconKey);
    return _TabItem(icon: icon, label: scope.label, path: path);
  }
}


class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.isActive,
    required this.colorScheme,
    required this.onTap,
    this.accentColor,
  });

  final _TabItem tab;
  final bool isActive;
  final ColorScheme colorScheme;
  final VoidCallback onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final activeColor = accentColor ?? colorScheme.primary;
    final inactiveColor = colorScheme.onSurface.withAlpha(150);
    final color = isActive ? activeColor : inactiveColor;

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
            Icon(tab.icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              tab.label,
              style: AppTypography.caption(color: color).copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.path,
  });

  final IconData icon;
  final String label;
  final String path;
}
