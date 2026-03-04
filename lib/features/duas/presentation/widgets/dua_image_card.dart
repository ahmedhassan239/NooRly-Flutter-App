import 'package:flutter/material.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use lighter background for image to ensure good contrast
    final cardBackground = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    final arabicColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final transliterationColor = isDark
        ? const Color(0xFF60A5FA)
        : const Color(0xFF3B82F6);
    final translationColor = isDark
        ? const Color(0xFFE5E7EB)
        : const Color(0xFF374151);
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Arabic Text
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              dua.arabic,
              textAlign: TextAlign.center,
              style: AppTypography.arabicH1(color: arabicColor)
                  .copyWith(fontSize: 32, height: 2.0),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Transliteration
          Text(
            dua.transliteration,
            textAlign: TextAlign.center,
            style: AppTypography.bodySm(color: transliterationColor)
                .copyWith(fontSize: 18, height: 1.6, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Translation
          Text(
            '"${dua.translation}"',
            textAlign: TextAlign.center,
            style: AppTypography.body(color: translationColor)
                .copyWith(fontSize: 20, height: 1.7),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Footer
          Text(
            '— ${dua.source}',
            textAlign: TextAlign.center,
            style: AppTypography.bodySm(color: footerColor)
                .copyWith(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
