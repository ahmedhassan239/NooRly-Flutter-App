import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/duas_mock_data.dart';

/// Dua Text Preview Card
///
/// Displays the Dua content in a preview card format
/// for the Share Dialog text mode
class DuaTextPreview extends StatelessWidget {
  const DuaTextPreview({
    required this.dua,
    super.key,
  });

  final DuaData dua;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Arabic Text
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              dua.arabic,
              textAlign: TextAlign.center,
              style: AppTypography.arabicH1(color: colorScheme.onSurface)
                  .copyWith(fontSize: 28, height: 1.8),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Transliteration
          Text(
            dua.transliteration,
            textAlign: TextAlign.center,
            style: AppTypography.bodySm(color: colorScheme.primary)
                .copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Translation
          Text(
            '"${dua.translation}"',
            textAlign: TextAlign.center,
            style: AppTypography.body(
              color: colorScheme.onSurface.withValues(alpha: 0.9),
            ).copyWith(height: 1.6),
          ),
          const SizedBox(height: AppSpacing.md),
          // Footer
          Text(
            '— ${dua.source}',
            textAlign: TextAlign.center,
            style: AppTypography.bodySm(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ).copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
