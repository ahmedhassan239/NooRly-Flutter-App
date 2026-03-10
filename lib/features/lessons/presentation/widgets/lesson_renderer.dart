/// Top-level lesson content renderer.
///
/// Receives a flat list of [LessonBlock]s and builds the correct widget for
/// each type. This is the only place in the UI that knows about block types.
///
/// Performance notes:
/// - Every block widget is [StatelessWidget] → no rebuild overhead.
/// - The column is built eagerly because the parent [SingleChildScrollView]
///   already virtualises the scroll. For very long lessons (50+ blocks) this
///   could be switched to a [SliverList] + [CustomScrollView] combination.
/// - Each block widget uses [const] constructors wherever possible.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/inline_text.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/lesson_callout_card.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/lesson_hadith_card.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/lesson_heading_block.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/lesson_list_block.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/lesson_paragraph_block.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/lesson_quote_card.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/lesson_reflection_card.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/lesson_reminder_card.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/lesson_step_card.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/blocks/lesson_verse_card.dart';
import 'package:flutter_app/features/lessons/presentation/widgets/lesson_html_content.dart';

export 'package:flutter_app/features/lessons/presentation/widgets/blocks/inline_text.dart';

class LessonRenderer extends StatelessWidget {
  const LessonRenderer({required this.blocks, super.key});

  final List<LessonBlock> blocks;

  @override
  Widget build(BuildContext context) {
    if (blocks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final block in blocks) _buildBlock(block),
      ],
    );
  }

  Widget _buildBlock(LessonBlock block) => switch (block) {
        final ParagraphBlock   b => LessonParagraphBlock(block: b),
        final HeadingBlock     b => LessonHeadingBlock(block: b),
        final ListBlock        b => LessonListBlock(block: b),
        final VerseBlock       b => LessonVerseCard(block: b),
        final HadithBlock      b => LessonHadithCard(block: b),
        final CalloutBlock     b => LessonCalloutCard(block: b),
        final StepBlock        b => LessonStepCard(block: b),
        final QuoteBlock       b => LessonQuoteCard(block: b),
        final ReflectionBlock  b => LessonReflectionCard(block: b),
        final ReminderBlock    b => LessonReminderCard(block: b),
        DividerBlock()           => const _SectionDivider(),
        // Legacy fallback: backend still sends raw HTML without `blocks` key.
        // Rendered via flutter_html until backend migrates to structured blocks.
        final HtmlBlock b => Builder(
            builder: (ctx) => LessonHtmlContent(
              html: b.html,
              textColor: Theme.of(ctx).colorScheme.onSurface,
            ),
          ),
      };
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Divider(
        color: Theme.of(context).colorScheme.outline.withAlpha(60),
        thickness: 1,
      ),
    );
  }
}

// Re-export so callers only need to import lesson_renderer.dart
// ignore: unused_element
Widget _unusedInlineTextExport() => const InlineText('', style: TextStyle());
