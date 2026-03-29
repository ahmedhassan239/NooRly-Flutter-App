import 'package:flutter/material.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';

/// Unified, locale-aware share image for Library (Duas, Adhkar, Hadith, Verses).
///
/// - [primaryBody] must already follow the active app language (use
///   [LocalizedReligiousContent.primaryBody] or equivalent).
/// - [sourcePlain] is the raw reference line; an em dash is prepended when non-empty.
/// - [badgeLabel] is a localized type label (e.g. [AppLocalizations.hadith]); if blank,
///   the badge row is omitted.
///
/// Wrapped in the same [RepaintBoundary] used for export so preview matches PNG.
class LibraryShareImageCard extends StatelessWidget {
  const LibraryShareImageCard({
    required this.badgeLabel,
    required this.primaryBody,
    required this.sourcePlain,
    super.key,
  });

  final String badgeLabel;
  final String primaryBody;
  final String sourcePlain;

  static const double _minHeight = 400;

  @override
  Widget build(BuildContext context) {
    final lc = Localizations.localeOf(context).languageCode;
    final dir = LocalizedReligiousContent.textDirectionFor(lc);
    final useArabic = LocalizedReligiousContent.useArabicTypography(lc);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? const [
              Color(0xFF0B1220),
              Color(0xFF152447),
              Color(0xFF1E1B4B),
            ]
          : const [
              AppColors.primary,
              Color(0xFF3730A3),
              Color(0xFF5B21B6),
            ],
      stops: const [0.0, 0.55, 1.0],
    );

    const bodyColor = Colors.white;
    final mutedColor = Colors.white.withValues(alpha: 0.82);
    final badge = badgeLabel.trim();

    final ref = sourcePlain.trim();
    final refLine = ref.isEmpty ? '' : '— $ref';

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: _minHeight),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.14),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xl + 4,
      ),
      child: Directionality(
        textDirection: dir,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (badge.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.28),
                  ),
                ),
                child: Text(
                  badge,
                  textAlign: TextAlign.center,
                  style: AppTypography.caption(color: bodyColor).copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text(
              primaryBody,
              textAlign: TextAlign.center,
              style: useArabic
                  ? AppTypography.arabicH1(color: bodyColor).copyWith(
                        fontSize: 30,
                        height: 2.0,
                        fontWeight: FontWeight.w500,
                      )
                  : AppTypography.body(color: bodyColor).copyWith(
                        fontSize: 22,
                        height: 1.65,
                        fontWeight: FontWeight.w500,
                      ),
            ),
            if (refLine.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                refLine,
                textAlign: TextAlign.center,
                style: AppTypography.bodySm(color: mutedColor).copyWith(
                  fontSize: 15,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
