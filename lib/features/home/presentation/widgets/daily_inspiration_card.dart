import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/features/home/data/daily_inspiration_api.dart';
import 'package:flutter_app/features/home/presentation/widgets/home_card.dart';
import 'package:flutter_app/features/saved/presentation/widgets/save_button.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Daily Inspiration section: one random item from library (ayah, hadith, dhikr, dua).
/// Header row (title + "See All →") and card content with Arabic, translation, source, Save/Share/Listen.
class DailyInspirationCard extends StatelessWidget {
  const DailyInspirationCard({
    required this.inspiration,
    required this.onRetry,
    super.key,
  });

  /// Fetched from GET /api/v1/daily-inspiration (from database).
  final DailyInspirationDto? inspiration;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.heart,
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Text(
                  'Daily Inspiration',
                  style: AppTypography.h3(color: colorScheme.onSurface),
                ),
              ],
            ),
            TextButton(
              onPressed: () => context.push('/duas'),
              child: const Text('See All →'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (inspiration == null)
          _PlaceholderCard(
            colorScheme: colorScheme,
            onRetry: onRetry,
          )
        else
          _ContentCard(inspiration: inspiration!, colorScheme: colorScheme),
      ],
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.inspiration,
    required this.colorScheme,
  });

  final DailyInspirationDto inspiration;
  final ColorScheme colorScheme;

  String get _typeLabel =>
      inspiration.title ??
      _capitalize(inspiration.type);

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  @override
  Widget build(BuildContext context) {
    final lightBlueBg = AppColors.primaryLightBlue.withValues(alpha: 0.08);

    return HomeCard(
      backgroundColor: lightBlueBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _typeLabel,
                style: AppTypography.caption(color: colorScheme.primary)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (inspiration.arabic.isNotEmpty)
            Text(
              inspiration.arabic,
              style: AppTypography.arabicH2(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          const SizedBox(height: 12),
          Text(
            inspiration.translation,
            style: AppTypography.body(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          if (inspiration.reference.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '— ${inspiration.reference}',
              style: AppTypography.caption(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: SaveButton(
                    type: inspiration.saveButtonType,
                    itemId: inspiration.id.toString(),
                    compact: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InspirationActionButton(
                  icon: LucideIcons.share2,
                  label: 'Share',
                  onPressed: () {
                    ShareContentDialog.show(
                      context,
                      ShareableContent(
                        id: inspiration.type,
                        arabic: inspiration.arabic,
                        transliteration: '',
                        translation: inspiration.translation,
                        source: inspiration.reference,
                        title: _typeLabel,
                      ),
                    );
                  },
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InspirationActionButton(
                  icon: LucideIcons.volume2,
                  label: 'Listen',
                  onPressed: () {
                    // TODO(username): Integrate TTS or audio when available
                  },
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InspirationActionButton extends StatelessWidget {
  const _InspirationActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.caption(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ).copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({
    required this.colorScheme,
    required this.onRetry,
  });

  final ColorScheme colorScheme;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Daily Inspiration',
            style: AppTypography.caption(color: colorScheme.primary),
          ),
          const SizedBox(height: 12),
          Text(
            'No daily inspiration available right now.',
            style: AppTypography.body(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
