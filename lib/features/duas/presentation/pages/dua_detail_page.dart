import 'package:flutter/material.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/core/content/providers/content_providers.dart' as content_providers;
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Detail page for a single dua.
class DuaDetailPage extends ConsumerWidget {
  const DuaDetailPage({required this.duaId, super.key});

  final String duaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final duaAsync = ref.watch(content_providers.duaDetailProvider(duaId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.savedTypeDua),
        leading: IconButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/saved'),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: duaAsync.when(
        data: (dua) {
          final languageCode = ref.watch(localeControllerProvider).languageCode;
          final text = LocalizedReligiousContent.primaryBody(
            languageCode: languageCode,
            arabic: dua.arabicText,
            translation: dua.translation ?? '',
          );
          final useArabic = LocalizedReligiousContent.useArabicTypography(languageCode);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((dua.title ?? '').trim().isNotEmpty)
                  Text(
                    dua.title!.trim(),
                    style: AppTypography.h3(color: colorScheme.onSurface),
                  ),
                if ((dua.title ?? '').trim().isNotEmpty) const SizedBox(height: AppSpacing.md),
                Text(
                  text,
                  style: useArabic
                      ? AppTypography.arabicBody(color: colorScheme.onSurface)
                      : AppTypography.body(color: colorScheme.onSurface),
                  textDirection: useArabic ? TextDirection.rtl : TextDirection.ltr,
                ),
                if ((dua.source ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '— ${dua.source!.trim()}',
                    style: AppTypography.caption(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.alertCircle, color: colorScheme.error, size: 40),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.savedCouldNotLoad,
                  textAlign: TextAlign.center,
                  style: AppTypography.body(color: colorScheme.onSurface),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => ref.invalidate(content_providers.duaDetailProvider(duaId)),
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
