import 'package:flutter/material.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/notifications/data/notification_inbox_api.dart';
import 'package:flutter_app/features/notifications/providers/notification_inbox_provider.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Lists server-driven in-app notifications (e.g. admin campaigns). Tapping marks read; optional route deep link.
class NotificationInboxPage extends ConsumerWidget {
  const NotificationInboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final auth = ref.watch(authProvider);

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.notificationInboxTitle)),
        body: Center(child: Text(l10n.notificationInboxSignIn)),
      );
    }

    final asyncItems = ref.watch(notificationInboxProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.notificationInboxTitle),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: asyncItems.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl2),
                child: Text(
                  l10n.notificationInboxEmpty,
                  style: AppTypography.body(color: colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(notificationInboxProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _InboxTile(
                  item: item,
                  colorScheme: colorScheme,
                  onTap: () async {
                    final client = ref.read(apiClientProvider);
                    if (!item.isRead) {
                      try {
                        await markNotificationInboxRead(client, item.id);
                        ref.invalidate(notificationInboxProvider);
                      } catch (_) {}
                    }
                    if (context.mounted &&
                        item.route != null &&
                        item.route!.isNotEmpty) {
                      context.push(item.route!);
                    }
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.toString(), textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () => ref.invalidate(notificationInboxProvider),
                  child: Text(l10n.actionRetry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InboxTile extends StatelessWidget {
  const _InboxTile({
    required this.item,
    required this.colorScheme,
    required this.onTap,
  });

  final NotificationInboxItem item;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: item.isRead
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title.isEmpty ? '—' : item.title,
                        style: AppTypography.h3(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (!item.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                if (item.body.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.body,
                    style: AppTypography.bodySm(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (item.route != null && item.route!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.route!,
                    style: AppTypography.caption(
                      color: colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
