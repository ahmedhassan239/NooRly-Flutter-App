/// Closing reminder card — warm amber tint, moon icon, centered closing text.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';

class LessonReminderCard extends StatelessWidget {
  const LessonReminderCard({required this.block, super.key});
  final ReminderBlock block;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? AppColors.accentGold.withAlpha(18)
        : const Color(0xFFFFFBEB);
    final border = AppColors.accentGold.withAlpha(80);
    final textColor = isDark
        ? Colors.white.withAlpha(220)
        : const Color(0xFF78350F); // amber-900

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          children: [
            const Text('🌙', style: TextStyle(fontSize: 28)),
            const SizedBox(height: 10),
            if (block.title != null && block.title!.isNotEmpty) ...[
              Text(
                block.title!,
                textAlign: TextAlign.center,
                style: AppTypography.h3(color: AppColors.accentGold).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
            ],
            SelectableText(
              block.text,
              textAlign: TextAlign.center,
              style: AppTypography.body(color: textColor).copyWith(height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}
