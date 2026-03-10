/// Hadith card — warm gold palette, Arabic text, English text, narrator footer.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';

// Warm gold palette (knowledge, wisdom feel for Hadith)
const _bg     = Color(0xFFFFFBEB); // amber-50
const _border = Color(0xFFD97706); // amber-600
const _label  = Color(0xFF92400E); // amber-800

class LessonHadithCard extends StatelessWidget {
  const LessonHadithCard({required this.block, super.key});
  final HadithBlock block;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.accentGold.withAlpha(18) : _bg;
    final labelColor = isDark ? AppColors.accentGold : _label;

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
                color: _border.withAlpha(isDark ? 40 : 22),
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
                        color: _border.withAlpha(30),
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
                      style: AppTypography.arabicH3(
                        color: isDark ? AppColors.accentGold : _border,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: _border.withAlpha(40), height: 1),
                    const SizedBox(height: 12),
                  ],
                  // English text
                  SelectableText(
                    '"${block.text}"',
                    style: AppTypography.body(
                      color: isDark
                          ? Colors.white.withAlpha(230)
                          : AppColors.foreground,
                    ).copyWith(height: 1.65, fontStyle: FontStyle.italic),
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
