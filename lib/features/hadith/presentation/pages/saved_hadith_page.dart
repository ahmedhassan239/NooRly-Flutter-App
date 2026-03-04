import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/features/hadith/presentation/widgets/save_hadith_button.dart';
import 'package:flutter_app/features/saved/data/saved_api.dart';
import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Saved Hadith page: list of saved hadith with search (local filter).
class SavedHadithPage extends ConsumerStatefulWidget {
  const SavedHadithPage({super.key});

  @override
  ConsumerState<SavedHadithPage> createState() => _SavedHadithPageState();
}

class _SavedHadithPageState extends ConsumerState<SavedHadithPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static bool _matchesSearch(SavedHadithItem item, String q) {
    if (q.isEmpty) return true;
    final lower = q.toLowerCase();
    final textAr = item.textAr ?? '';
    final textEn = item.textEn ?? '';
    final text = item.text ?? '';
    final collection = item.collectionName ?? item.collection ?? '';
    return textAr.toLowerCase().contains(lower) ||
        textEn.toLowerCase().contains(lower) ||
        text.toLowerCase().contains(lower) ||
        collection.toLowerCase().contains(lower);
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

    final listAsync = ref.watch(savedHadithListProvider);

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
                      hintText: 'Search hadith...',
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
                            child: _buildHadithCard(
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
                              'Could not load saved hadith',
                              style: AppTypography.body(
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            TextButton(
                              onPressed: () {
                                ref.invalidate(savedHadithListProvider);
                              },
                              child: const Text('Retry'),
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
                context.go('/hadith');
              }
            },
            icon: const Icon(LucideIcons.arrowLeft),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Saved Hadith',
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
              'Sign in to view saved hadith',
              style: AppTypography.body(
                color: colorScheme.onSurface.withAlpha(150),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your saved items are synced to your account.',
              style: AppTypography.caption(
                color: colorScheme.onSurface.withAlpha(120),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(LucideIcons.logIn),
              label: const Text('Sign In'),
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
                  ? 'No saved hadith yet'
                  : 'No hadith match your search',
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

  Widget _buildHadithCard(
    BuildContext context,
    WidgetRef ref,
    SavedHadithItem hadith,
    ColorScheme colorScheme,
  ) {
    final text =
        hadith.text ?? hadith.textEn ?? hadith.textAr ?? '';
    final source = hadith.collectionName != null
        ? '${hadith.collectionName}${hadith.hadithNumber != null ? ', ${hadith.hadithNumber}' : ''}'
        : (hadith.collection ?? '');

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
          if (hadith.textAr != null && hadith.textAr!.isNotEmpty)
            Text(
              hadith.textAr!,
              style: AppTypography.arabicH2(color: colorScheme.onSurface),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          if (hadith.textAr != null && hadith.textAr!.isNotEmpty)
            const SizedBox(height: AppSpacing.md),
          Text(
            '"$text"',
            style: AppTypography.bodySm(color: colorScheme.onSurface),
          ),
          if (source.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              '— $source',
              style: AppTypography.caption(
                color: colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              SaveHadithButton(hadithId: hadith.id, compact: true),
              const SizedBox(width: AppSpacing.sm),
              _buildActionButton(
                context: context,
                icon: LucideIcons.copy,
                label: 'Copy',
                colorScheme: colorScheme,
                onTap: () {
                  final toCopy = hadith.textAr != null
                      ? '${hadith.textAr}\n\n$text\n\n— $source'
                      : '$text\n\n— $source';
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
                label: 'Share',
                colorScheme: colorScheme,
                onTap: () {
                  ShareContentDialog.show(
                    context,
                    ShareableContent(
                      id: hadith.id.toString(),
                      arabic: hadith.textAr ?? '',
                      transliteration: '',
                      translation: text,
                      source: source,
                      title: 'Share Hadith',
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
