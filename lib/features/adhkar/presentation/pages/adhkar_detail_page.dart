import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/bottom_nav.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/features/adhkar/presentation/adhkar_mock_data.dart';
import 'package:flutter_app/features/adhkar/presentation/widgets/save_adhkar_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdhkarDetailPage extends ConsumerWidget {
  const AdhkarDetailPage({required this.adhkarId, super.key});

  final String adhkarId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adhkar = AdhkarMockDataExtension.getAdhkarById(adhkarId);
    final colorScheme = Theme.of(context).colorScheme;

    if (adhkar == null) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.bookX, size: 64, color: colorScheme.onSurface.withAlpha(100)),
              const SizedBox(height: 16),
              Text(
                'Adhkar not found',
                style: AppTypography.h2(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/adhkar'),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

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
                    child: _buildAdhkarContent(context, ref, adhkar, colorScheme),
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
                context.go('/adhkar');
              }
            },
            icon: const Icon(LucideIcons.arrowLeft),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Dhikr',
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildAdhkarContent(
    BuildContext context,
    WidgetRef ref,
    AdhkarData adhkar,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dhikr badge and repetition
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                'Dhikr',
                style: AppTypography.caption(color: AppColors.primary)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: colorScheme.primary.withAlpha(50)),
              ),
              child: Text(
                'Say ${adhkar.repetition}x',
                style: AppTypography.bodySm(color: colorScheme.primary)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Arabic text
        Text(
          adhkar.arabic,
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
            adhkar.transliteration,
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
          adhkar.translation,
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
                'Source: ${adhkar.source}',
                style: AppTypography.bodySm(color: colorScheme.onSurface),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        // Action buttons
        _buildActionButtons(context, ref, adhkar, colorScheme),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    AdhkarData adhkar,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SaveAdhkarButton(adhkarId: adhkar.id),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: LucideIcons.copy,
                label: 'Copy',
                colorScheme: colorScheme,
                onTap: () {
                  final textToCopy = '${adhkar.arabic}\n\n${adhkar.transliteration}\n\n"${adhkar.translation}"\n\n— ${adhkar.source}';
                  Clipboard.setData(ClipboardData(text: textToCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied to clipboard!'),
                      duration: Duration(seconds: 2),
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
                      id: adhkar.id,
                      arabic: adhkar.arabic,
                      transliteration: adhkar.transliteration,
                      translation: adhkar.translation,
                      source: adhkar.source,
                      title: 'Share Adhkar',
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
                    const SnackBar(
                      content: Text('Audio playback coming soon'),
                      duration: Duration(seconds: 2),
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
