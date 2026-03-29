/// Generic Save/Saved button for all content types.
/// Auth-aware: shows login prompt if not authenticated.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_app/features/saved/presentation/widgets/compact_save_button_chrome.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Generic save button for any content type.
/// [type] must be one of: 'dua', 'hadith', 'verse', 'lesson', 'adhkar'
class SaveButton extends ConsumerWidget {
  const SaveButton({
    required this.type,
    required this.itemId,
    super.key,
    this.compact = false,
  });

  /// Content type: 'dua', 'hadith', 'verse', 'lesson', 'adhkar'
  final String type;

  /// Item ID (string or int, will be converted to string)
  final dynamic itemId;

  /// If true, use smaller padding and font.
  final bool compact;

  String get _itemIdStr => itemId.toString();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final isAuthenticated = auth.isAuthenticated;
    final isSaved = isItemSaved(ref, type, _itemIdStr) ?? false;
    final isPending = isItemPending(ref, type, _itemIdStr);
    final l10n = AppLocalizations.of(context)!;

    return CompactSaveButtonChrome(
      compact: compact,
      isSaved: isSaved,
      isPending: isPending,
      savedLabel: l10n.actionSaved,
      saveLabel: l10n.actionSave,
      onTap: isPending
          ? null
          : () => _onTap(context, ref, isAuthenticated, isSaved),
    );
  }

  Future<void> _onTap(
    BuildContext context,
    WidgetRef ref,
    bool isAuthenticated,
    bool currentIsSaved,
  ) async {
    if (!isAuthenticated) {
      _showLoginPrompt(context);
      return;
    }

    final notifier = ref.read(toggleSaveProvider.notifier);
    final result = await notifier.toggle(
      type: type,
      itemId: _itemIdStr,
      currentIsSaved: currentIsSaved,
    );

    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;
    switch (result) {
      case ToggleSaveResult.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentIsSaved ? l10n.removedFromSaved : l10n.savedToFavorites,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      case ToggleSaveResult.notAuthenticated:
        _showLoginPrompt(context);
        break;
      case ToggleSaveResult.failure:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.couldNotUpdateSavedState),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      case ToggleSaveResult.skipped:
        break;
    }
  }

  void _showLoginPrompt(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.loginRequired),
        content: Text(l10n.pleaseSignInToSave),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/login');
            },
            child: Text(l10n.actionSignIn),
          ),
        ],
      ),
    );
  }
}
