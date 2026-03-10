/// Quran verse card — emerald palette, Arabic text, translation, reference.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';

// Emerald palette (calm, sacred feel for Quran verses)
const _bg     = Color(0xFFECFDF5); // emerald-50
const _border = Color(0xFF059669); // emerald-600
const _label  = Color(0xFF065F46); // emerald-800

class LessonVerseCard extends StatelessWidget {
  const LessonVerseCard({required this.block, super.key});
  final VerseBlock block;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.accentGreen.withAlpha(20) : _bg;
    final labelColor = isDark ? AppColors.accentGreen : _label;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: _border.withAlpha(60)),
          boxShadow: [
            BoxShadow(
              color: _border.withAlpha(18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _border.withAlpha(isDark ? 40 : 25),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
              ),
              child: Row(
                children: [
                  const Text('📖', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    'Quran',
                    style: AppTypography.caption(color: labelColor).copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Arabic text
                  if (block.arabic != null && block.arabic!.isNotEmpty) ...[
                    SelectableText(
                      block.arabic!,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: AppTypography.arabicH2(
                        color: isDark
                            ? AppColors.accentGreen
                            : _border,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // Transliteration (optional)
                  if (block.transliteration != null) ...[
                    SelectableText(
                      block.transliteration!,
                      style: AppTypography.bodySm(
                        color: _label.withAlpha(isDark ? 180 : 160),
                      ).copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Translation
                  if (block.translation.isNotEmpty)
                    SelectableText(
                      '"${block.translation}"',
                      style: AppTypography.body(
                        color: isDark
                            ? Colors.white.withAlpha(230)
                            : AppColors.foreground,
                      ).copyWith(height: 1.65, fontStyle: FontStyle.italic),
                    ),
                  const SizedBox(height: 12),
                  // Reference
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      '— ${block.reference}',
                      style: AppTypography.caption(color: labelColor).copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
