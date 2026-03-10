library;
import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/inline_text.dart';

class LessonListBlock extends StatelessWidget {
  const LessonListBlock({required this.block, super.key});
  final ListBlock block;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bodyStyle = AppTypography.body(color: colorScheme.onSurface).copyWith(height: 1.6);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(block.items.length, (i) {
          final marker = block.ordered
              ? '${i + 1}.'
              : '•';
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    marker,
                    style: bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: InlineText(block.items[i], style: bodyStyle),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
