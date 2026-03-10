/// Pull-quote card — gold left bar, italic large text, optional source.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';

class LessonQuoteCard extends StatelessWidget {
  const LessonQuoteCard({required this.block, super.key});
  final QuoteBlock block;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gold left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            // Quote content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    '"${block.text}"',
                    style: AppTypography.h3(color: colorScheme.onSurface).copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      height: 1.65,
                    ),
                  ),
                  if (block.source != null && block.source!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '— ${block.source}',
                      style: AppTypography.caption(
                        color: AppColors.accentGold,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
