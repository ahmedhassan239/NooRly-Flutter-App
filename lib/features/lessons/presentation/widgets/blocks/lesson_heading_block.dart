library;
import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';

class LessonHeadingBlock extends StatelessWidget {
  const LessonHeadingBlock({required this.block, super.key});
  final HeadingBlock block;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    final style = switch (block.level) {
      1 => AppTypography.h1(color: color),
      2 => AppTypography.h2(color: color),
      _ => AppTypography.h3(color: color),
    };
    final topPad = switch (block.level) { 1 => 24.0, 2 => 20.0, _ => 16.0 };

    return Padding(
      padding: EdgeInsets.only(top: topPad, bottom: 8),
      child: SelectableText(block.text, style: style),
    );
  }
}
