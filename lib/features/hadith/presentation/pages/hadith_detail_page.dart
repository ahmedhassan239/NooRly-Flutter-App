import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/bottom_nav.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/features/hadith/presentation/hadith_mock_data.dart';
import 'package:flutter_app/features/hadith/presentation/widgets/save_hadith_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HadithDetailPage extends ConsumerWidget {
  const HadithDetailPage({required this.hadithId, super.key});

  final String hadithId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hadith = HadithMockDataExtension.getHadithById(hadithId);
    final colorScheme = Theme.of(context).colorScheme;

    if (hadith == null) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.bookX, size: 64, color: colorScheme.onSurface.withAlpha(100)),
              const SizedBox(height: 16),
              Text(
                'Hadith not found',
                style: AppTypography.h2(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/hadith'),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final hadithIdInt = int.tryParse(hadithId) ?? 0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(context, colorScheme),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: _buildHadithContent(context, ref, hadith, hadithIdInt, colorScheme),
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

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withAlpha(128)),
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
            'Hadith',
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithContent(
    BuildContext context,
    WidgetRef ref,
    HadithData hadith,
    int hadithIdInt,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hadith label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accentCoral.withAlpha(25),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            'Hadith',
            style: AppTypography.caption(color: AppColors.accentCoral)
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Arabic text
        Text(
          hadith.arabic,
          style: AppTypography.arabicH1(color: colorScheme.onSurface),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: AppSpacing.lg),
        // Transliteration
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.primary.withAlpha(25),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Text(
            hadith.transliteration,
            style: AppTypography.body(color: colorScheme.primary)
                .copyWith(fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Translation
        Text(
          'Translation',
          style: AppTypography.h3(color: colorScheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          hadith.translation,
          style: AppTypography.body(color: colorScheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Source
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: colorScheme.outline.withAlpha(128)),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.bookOpen,
                size: 18,
                color: colorScheme.onSurface.withAlpha(150),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Source: ${hadith.source}',
                style: AppTypography.bodySm(color: colorScheme.onSurface),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        // Action buttons
        _buildActionButtons(context, ref, hadith, hadithIdInt, colorScheme),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    HadithData hadith,
    int hadithIdInt,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SaveHadithButton(hadithId: hadithIdInt),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: LucideIcons.copy,
                label: 'Copy',
                colorScheme: colorScheme,
                onTap: () {
                  final textToCopy = '${hadith.arabic}\n\n${hadith.transliteration}\n\n"${hadith.translation}"\n\n- ${hadith.source}';
                  Clipboard.setData(ClipboardData(text: textToCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Copied to clipboard! ✓'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: LucideIcons.share2,
                label: 'Share',
                colorScheme: colorScheme,
                onTap: () {
                  ShareContentDialog.show(
                    context,
                    ShareableContent(
                      id: hadith.id,
                      arabic: hadith.arabic,
                      transliteration: hadith.transliteration,
                      translation: hadith.translation,
                      source: hadith.source,
                      title: 'Share Hadith',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: LucideIcons.volume2,
                label: 'Listen',
                colorScheme: colorScheme,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Audio playback coming soon 🔊'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary.withAlpha(25)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isActive
                ? colorScheme.primary.withAlpha(50)
                : colorScheme.outline.withAlpha(100),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurface.withAlpha(150),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.bodySm(
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(150),
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
