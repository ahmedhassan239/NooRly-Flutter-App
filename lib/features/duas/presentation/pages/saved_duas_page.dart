import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/saved/data/saved_api.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Saved Duas page: list of saved duas (hydrated from GET /saved?type=dua).
/// Matches the design: back arrow, "Saved Duas" title, subtitle count,
/// each card shows title (bold), arabic text, source — with a chevron right.
class SavedDuasPage extends ConsumerWidget {
  const SavedDuasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final auth = ref.watch(authProvider);

    if (!auth.isAuthenticated) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  _buildHeader(context, colorScheme, null),
                  Expanded(child: _buildLoginRequired(context, colorScheme)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final listAsync = ref.watch(savedDuaListProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(
                  context,
                  colorScheme,
                  listAsync.valueOrNull?.length,
                ),
                Expanded(
                  child: listAsync.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return _buildEmpty(context, colorScheme);
                      }
                      return RefreshIndicator(
                        onRefresh: () async =>
                            ref.invalidate(savedDuaListProvider),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) => _buildDuaCard(
                            context,
                            items[index],
                            colorScheme,
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.alertCircle,
                              size: 48,
                              color: colorScheme.error,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              AppLocalizations.of(context)!.savedCouldNotLoad,
                              textAlign: TextAlign.center,
                              style: AppTypography.body(
                                color: colorScheme.onSurface.withAlpha(180),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextButton(
                              onPressed: () =>
                                  ref.invalidate(savedDuaListProvider),
                              child: Text(AppLocalizations.of(context)!.actionRetry),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    int? count,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withAlpha(80)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/duas');
              }
            },
            icon: const Icon(LucideIcons.arrowLeft),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.savedCardDuas,
                style: AppTypography.h2(color: colorScheme.onSurface),
              ),
              if (count != null)
                Text(
                  AppLocalizations.of(context)!.savedCountLabel(count),
                  style: AppTypography.caption(
                    color: colorScheme.onSurface.withAlpha(130),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRequired(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.logIn,
              size: 64,
              color: colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppLocalizations.of(context)!.savedSignInToView,
              style: AppTypography.body(
                color: colorScheme.onSurface.withAlpha(150),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppLocalizations.of(context)!.savedSyncedToAccount,
              style: AppTypography.caption(
                color: colorScheme.onSurface.withAlpha(120),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(LucideIcons.logIn),
              label: Text(AppLocalizations.of(context)!.actionSignIn),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.bookmark,
              size: 64,
              color: colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppLocalizations.of(context)!.savedNoItems,
              style: AppTypography.body(
                color: colorScheme.onSurface.withAlpha(150),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppLocalizations.of(context)!.savedEmptyHint,
              style: AppTypography.caption(
                color: colorScheme.onSurface.withAlpha(120),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Card matching the design: title (bold), arabic text, source — chevron right.
  Widget _buildDuaCard(
    BuildContext context,
    SavedDuaItem dua,
    ColorScheme colorScheme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final rawTitle = dua.title ?? dua.titleAr ?? dua.source;
    final title = rawTitle != null && rawTitle.isNotEmpty
        ? rawTitle
        : (dua.text != null && dua.text!.trim().isNotEmpty
            ? (dua.text!.trim().length > 35 ? '${dua.text!.trim().substring(0, 35)}…' : dua.text!.trim())
            : l10n.savedTypeDua);
    final arabic = dua.textAr ?? '';
    final source = dua.source ?? '';

    return InkWell(
      onTap: () => context.push('/duas/${dua.id}'),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colorScheme.outline.withAlpha(100)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodySm(color: colorScheme.onSurface)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (arabic.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      arabic,
                      style: AppTypography.arabicBody(
                        color: colorScheme.onSurface.withAlpha(200),
                      ),
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (source.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      source,
                      style: AppTypography.caption(
                        color: colorScheme.onSurface.withAlpha(120),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: colorScheme.onSurface.withAlpha(100),
            ),
          ],
        ),
      ),
    );
  }
}
