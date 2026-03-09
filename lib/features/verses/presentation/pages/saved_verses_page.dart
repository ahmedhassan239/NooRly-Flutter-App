import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/features/saved/data/saved_api.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_app/features/verses/presentation/widgets/save_verse_button.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Saved Verses page: list of saved verses with search (local filter).
class SavedVersesPage extends ConsumerStatefulWidget {
  const SavedVersesPage({super.key});

  @override
  ConsumerState<SavedVersesPage> createState() => _SavedVersesPageState();
}

class _SavedVersesPageState extends ConsumerState<SavedVersesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static bool _matchesSearch(SavedVerseItem item, String q) {
    if (q.isEmpty) return true;
    final lower = q.toLowerCase();
    final textAr = item.textAr ?? '';
    final textEn = item.textEn ?? '';
    final text = item.text ?? '';
    final ref = item.reference ?? '';
    final nameEn = (item.surahNameEn ?? '').toLowerCase();
    final nameAr = item.surahNameAr ?? '';
    return textAr.toLowerCase().contains(lower) ||
        textEn.toLowerCase().contains(lower) ||
        text.toLowerCase().contains(lower) ||
        ref.toLowerCase().contains(lower) ||
        nameEn.contains(lower) ||
        nameAr.contains(lower);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final auth = ref.watch(authProvider);
    final isAuthenticated = auth.isAuthenticated;

    if (!isAuthenticated) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  _buildHeader(context, colorScheme),
                  Expanded(child: _buildLoginRequired(context, colorScheme)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final listAsync = ref.watch(savedVerseListProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(context, colorScheme),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) =>
                        setState(() => _query = value.trim()),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      prefixIcon: const Icon(LucideIcons.search, size: 20),
                      hintText: AppLocalizations.of(context)!.searchVerses,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: listAsync.when(
                    data: (items) {
                      final filtered = items
                          .where((e) => _matchesSearch(e, _query))
                          .toList();
                      if (filtered.isEmpty) {
                        return _buildEmpty(context, colorScheme, items.isEmpty);
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.xl,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: _buildVerseCard(
                              context,
                              ref,
                              filtered[index],
                              colorScheme,
                            ),
                          );
                        },
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
                              style: AppTypography.body(
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            TextButton(
                              onPressed: () {
                                ref.invalidate(savedVerseListProvider);
                              },
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
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withAlpha(128),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/verses');
              }
            },
            icon: const Icon(LucideIcons.arrowLeft),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppLocalizations.of(context)!.savedCardVerses,
            style: AppTypography.h2(color: colorScheme.onSurface),
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

  Widget _buildEmpty(
    BuildContext context,
    ColorScheme colorScheme,
    bool noSavedAtAll,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              noSavedAtAll
                  ? LucideIcons.heart
                  : LucideIcons.search,
              size: 64,
              color: colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              noSavedAtAll
                  ? AppLocalizations.of(context)!.savedNoItems
                  : AppLocalizations.of(context)!.savedNoSearchResults,
              style: AppTypography.body(
                color: colorScheme.onSurface.withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerseCard(
    BuildContext context,
    WidgetRef ref,
    SavedVerseItem verse,
    ColorScheme colorScheme,
  ) {
    final text = verse.text ?? verse.textEn ?? verse.textAr ?? '';
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final refStr = verse.referenceDisplay(isArabic);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colorScheme.outline.withAlpha(128),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  'Verse',
                  style: AppTypography.caption(
                    color: colorScheme.primary,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          if (verse.textAr != null && verse.textAr!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              verse.textAr!,
              style: AppTypography.arabicH2(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ],
          if (verse.textAr != null && verse.textAr!.isNotEmpty)
            const SizedBox(height: AppSpacing.md),
          Text(
            '"$text"',
            style: AppTypography.bodySm(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          if (refStr.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                '— $refStr',
                style: AppTypography.caption(
                  color: colorScheme.onSurface.withAlpha(150),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SaveVerseButton(verseId: verse.id, compact: true),
              const SizedBox(width: AppSpacing.sm),
              _buildActionButton(
                context: context,
                icon: LucideIcons.copy,
                label: 'Copy',
                colorScheme: colorScheme,
                onTap: () {
                  final toCopy = verse.textAr != null
                      ? '${verse.textAr}\n\n$text\n\n— $refStr'
                      : '$text\n\n— $refStr';
                  Clipboard.setData(ClipboardData(text: toCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied to clipboard!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildActionButton(
                context: context,
                icon: LucideIcons.share2,
                label: AppLocalizations.of(context)!.actionShare,
                colorScheme: colorScheme,
                onTap: () {
                  ShareContentDialog.show(
                    context,
                    ShareableContent(
                      id: verse.id.toString(),
                      arabic: verse.textAr ?? '',
                      transliteration: '',
                      translation: text,
                      source: refStr,
                      title: 'Share Verse',
                    ),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildActionButton(
                context: context,
                icon: LucideIcons.volume2,
                label: AppLocalizations.of(context)!.actionListen,
                colorScheme: colorScheme,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Listen — coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: colorScheme.outline.withAlpha(100),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: colorScheme.onSurface.withAlpha(150),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.caption(
                color: colorScheme.onSurface.withAlpha(150),
              ).copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
