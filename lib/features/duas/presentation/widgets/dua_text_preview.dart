import 'package:flutter/material.dart';
import 'package:flutter_app/core/content/library_reference_format.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
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
    final lc = Localizations.localeOf(context).languageCode;
    final dir = LocalizedReligiousContent.textDirectionFor(lc);
    final primary = LocalizedReligiousContent.primaryBody(
      languageCode: lc,
      arabic: dua.arabic,
      translation: dua.translation,
    );
    final useArabic = LocalizedReligiousContent.useArabicTypography(lc);
    final l10n = AppLocalizations.of(context)!;
    final sourceLine = formatLooseReligiousSourceLine(
      l10n,
      lc,
      dua.source,
      sourceAr: dua.sourceAr,
    );

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
      child: Directionality(
        textDirection: dir,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              primary,
              textAlign: TextAlign.center,
              style: useArabic
                  ? AppTypography.arabicH1(color: colorScheme.onSurface)
                      .copyWith(fontSize: 28, height: 1.8)
                  : AppTypography.body(
                      color: colorScheme.onSurface.withValues(alpha: 0.9),
                    ).copyWith(height: 1.6, fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '— $sourceLine',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ).copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
