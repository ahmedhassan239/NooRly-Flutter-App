/// Quran verse card — emerald palette, Arabic text, translation, reference.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';

// Emerald palette (calm, sacred feel for Quran verses) — light mode
const _bgLight = Color(0xFFECFDF5); // emerald-50
const _border = Color(0xFF059669); // emerald-600
const _labelLight = Color(0xFF065F46); // emerald-800

class LessonVerseCard extends StatelessWidget {
  const LessonVerseCard({required this.block, super.key});
  final VerseBlock block;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark
        ? Color.alphaBlend(
            _border.withValues(alpha: 0.14),
            colorScheme.surfaceContainerHighest,
          )
        : _bgLight;
    final borderColor = _border.withValues(alpha: isDark ? 0.42 : 0.6);
    final labelColor = isDark ? const Color(0xFF6EE7B7) : _labelLight;
    final arabicColor = isDark ? const Color(0xFF34D399) : _border;
    final secondaryText = colorScheme.onSurface.withValues(alpha: 0.74);
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
                color: _border.withValues(alpha: isDark ? 0.18 : 0.1),
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
                      style: AppTypography.arabicH2(color: arabicColor),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // Transliteration (optional)
                  if (block.transliteration != null) ...[
                    SelectableText(
                      block.transliteration!,
                      style: AppTypography.bodySm(
                        color: isDark ? secondaryText : _labelLight.withValues(alpha: 0.75),
                      ).copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Translation (only if different from Arabic to avoid duplication)
                  if (block.translation.trim().isNotEmpty &&
                      (block.arabic == null ||
                          block.arabic!.trim() != block.translation.trim()))
                    SelectableText(
                      '"${block.translation}"',
                      style: AppTypography.body(color: bodyText).copyWith(
                        height: 1.65,
                        fontStyle: FontStyle.italic,
                      ),
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
