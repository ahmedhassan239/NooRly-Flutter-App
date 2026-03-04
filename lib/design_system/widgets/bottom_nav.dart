import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/remote_config/providers/remote_config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Bottom Navigation Bar
///
/// Tabs: Home, Library, Journey, Prayer, Profile. Visibility is feature-gated
/// by remote config [features_enabled] (e.g. prayer_times, lessons, duas, hadith, quran, adhkar).
class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  static const List<_NavItem> _navItems = [
    _NavItem(icon: LucideIcons.home, label: 'Home', path: '/home', featureSlug: null),
    _NavItem(icon: LucideIcons.library, label: 'Library', path: '/library', featureSlug: 'library'),
    _NavItem(icon: LucideIcons.bookOpen, label: 'Journey', path: '/journey', featureSlug: 'lessons'),
    _NavItem(icon: LucideIcons.clock, label: 'Prayer', path: '/prayer-times', featureSlug: 'prayer_times'),
    _NavItem(icon: LucideIcons.user, label: 'Profile', path: '/profile', featureSlug: null),
  ];

  bool _isActive(String currentPath, String navPath) {
    if (navPath == '/journey') {
      return currentPath == '/journey' || currentPath.startsWith('/lesson');
    }
    if (navPath == '/library') {
      // Library tab is active for unified library and legacy content hub paths
      return currentPath.startsWith('/library') ||
          currentPath.startsWith('/duas') ||
          currentPath.startsWith('/hadith') ||
          currentPath.startsWith('/verses') ||
          currentPath.startsWith('/adhkar');
    }
    if (navPath == '/prayer-times') {
      // Prayer tab is active for prayer-related pages
      return currentPath == '/prayer-times' ||
          currentPath.startsWith('/prayer');
    }
    if (navPath == '/profile') {
      // Profile tab is active for profile-related pages
      return currentPath == '/profile' ||
          currentPath.startsWith('/settings') ||
          currentPath.startsWith('/edit-profile');
    }
    return currentPath == navPath;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).uri.path;
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final libraryEnabled = ref.watch(isLibraryFeatureEnabledProvider);

    final visibleItems = _navItems.where((item) {
      if (item.featureSlug == null) return true;
      if (item.featureSlug == 'library') return libraryEnabled;
      return ref.watch(isFeatureEnabledProvider(item.featureSlug!));
    }).toList();

    return Material(
      color: brightness == Brightness.dark
          ? colorScheme.surface
          : colorScheme.surface.withValues(alpha: 0.95),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colorScheme.outline.withAlpha(128)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: visibleItems.map((item) {
                final isActive = _isActive(currentPath, item.path);
                return _NavButton(
                  item: item,
                  isActive: isActive,
                  colorScheme: colorScheme,
                  onTap: () => context.go(item.path),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.isActive,
    required this.colorScheme,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                item.icon,
                size: 20,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppTypography.caption(
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.path,
    this.featureSlug,
  });

  final IconData icon;
  final String label;
  final String path;
  /// Feature slug from remote config (e.g. prayer_times, lessons). null = always show.
  final String? featureSlug;
}
