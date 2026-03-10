/// Callout / tip card — tinted left-border card for 4 variants.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/inline_text.dart';

class LessonCalloutCard extends StatelessWidget {
  const LessonCalloutCard({required this.block, super.key});
  final CalloutBlock block;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (bg, border, icon) = _palette(block.variant, isDark);
    final textColor = isDark
        ? Colors.white.withAlpha(220)
        : const Color(0xFF1F2937);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border(left: BorderSide(width: 4, color: border)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Optional title row
            if (block.title != null && block.title!.isNotEmpty) ...[
              Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    block.title!,
                    style: AppTypography.bodySm(color: border).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ] else ...[
              Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                ],
              ),
              const SizedBox(height: 2),
            ],
            InlineText(
              block.text,
              style: AppTypography.body(color: textColor).copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  static (Color bg, Color border, String icon) _palette(
    CalloutVariant variant,
    bool isDark,
  ) {
    return switch (variant) {
      CalloutVariant.tip => (
          isDark ? const Color(0xFF059669).withAlpha(20) : const Color(0xFFECFDF5),
          const Color(0xFF059669),
          '💡',
        ),
      CalloutVariant.info => (
          isDark ? const Color(0xFF3B82F6).withAlpha(20) : const Color(0xFFEFF6FF),
          const Color(0xFF3B82F6),
          'ℹ️',
        ),
      CalloutVariant.warning => (
          isDark ? const Color(0xFFD97706).withAlpha(20) : const Color(0xFFFFFBEB),
          const Color(0xFFD97706),
          '⚠️',
        ),
      CalloutVariant.success => (
          isDark ? const Color(0xFF10B981).withAlpha(20) : const Color(0xFFF0FDF4),
          const Color(0xFF10B981),
          '✅',
        ),
    };
  }
}
