import 'package:flutter/material.dart';
import 'package:flutter_app/core/content/library_reference_format.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/duas_mock_data.dart';

/// Dua Image Card Widget
///
/// A shareable image card displaying the Dua content
/// Used for generating shareable images
class DuaImageCard extends StatelessWidget {
  const DuaImageCard({
    required this.dua,
    super.key,
  });

  final DuaData dua;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

    // Use lighter background for image to ensure good contrast
    final cardBackground = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    final bodyColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final footerColor = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 400),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Directionality(
        textDirection: dir,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              primary,
              textAlign: TextAlign.center,
              style: useArabic
                  ? AppTypography.arabicH1(color: bodyColor)
                      .copyWith(fontSize: 32, height: 2.0)
                  : AppTypography.body(color: bodyColor)
                      .copyWith(fontSize: 22, height: 1.7),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '— $sourceLine',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm(color: footerColor)
                  .copyWith(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
