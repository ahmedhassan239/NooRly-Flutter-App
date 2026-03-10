/// Reflection question card — pen icon, muted surface, italic prompt.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LessonReflectionCard extends StatelessWidget {
  const LessonReflectionCard({required this.block, super.key});
  final ReflectionBlock block;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: colorScheme.outline.withAlpha(60)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              LucideIcons.edit3,
              size: 20,
              color: colorScheme.primary.withAlpha(180),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reflect',
                    style: AppTypography.caption(color: colorScheme.primary).copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    block.prompt,
                    style: AppTypography.body(
                      color: colorScheme.onSurface.withAlpha(210),
                    ).copyWith(fontStyle: FontStyle.italic, height: 1.65),
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
