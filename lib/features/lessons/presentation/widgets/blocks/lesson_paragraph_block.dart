library;
import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/inline_text.dart';

class LessonParagraphBlock extends StatelessWidget {
  const LessonParagraphBlock({required this.block, super.key});
  final ParagraphBlock block;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InlineText(
        block.text,
        style: AppTypography.body(color: color).copyWith(height: 1.7),
      ),
    );
  }
}
