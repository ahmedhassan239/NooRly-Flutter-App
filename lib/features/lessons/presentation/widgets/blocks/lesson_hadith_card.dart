/// Hadith card — warm gold palette, Arabic text, English text, narrator footer.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';

// Warm gold palette (knowledge, wisdom feel for Hadith) — light mode
const _bgLight = Color(0xFFFFFBEB); // amber-50
const _border = Color(0xFFD97706); // amber-600
const _labelLight = Color(0xFF92400E); // amber-800

class LessonHadithCard extends StatelessWidget {
  const LessonHadithCard({required this.block, super.key});
  final HadithBlock block;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark
        ? Color.alphaBlend(
            _border.withValues(alpha: 0.12),
            colorScheme.surfaceContainerHighest,
          )
        : _bgLight;
    final borderColor = _border.withValues(alpha: isDark ? 0.42 : 0.6);
    final labelColor = isDark ? const Color(0xFFFBBF24) : _labelLight;
    final arabicColor = isDark ? const Color(0xFFFCD34D) : _border;
    final bodyText = colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: _border.withValues(alpha: isDark ? 0.12 : 0.07),
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
                color: _border.withValues(alpha: isDark ? 0.16 : 0.09),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
              ),
              child: Row(
                children: [
                  const Text('📜', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    'Hadith',
                    style: AppTypography.caption(color: labelColor).copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                  if (block.grade != null && block.grade!.isNotEmpty) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _border.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        block.grade!,
                        style: AppTypography.caption(color: labelColor),
                      ),
                    ),
                  ],
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
                      style: AppTypography.arabicH3(color: arabicColor),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: _border.withValues(alpha: 0.35), height: 1),
                    const SizedBox(height: 12),
                  ],
                  // English text
                  SelectableText(
                    '"${block.text}"',
                    style: AppTypography.body(color: bodyText).copyWith(
                      height: 1.65,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Narrator
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      '— ${block.narrator}',
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
