/// Lightweight inline Markdown renderer using [Text.rich].
///
/// Supports: ***bold italic*** / **bold** / *italic*
/// No external packages — zero overhead, fully native.
library;

import 'package:flutter/material.dart';

/// Renders a string that may contain `**bold**` and `*italic*` markers
/// as a [SelectableText] widget with proper [TextSpan]s.
class InlineText extends StatelessWidget {
  const InlineText(
    this.text, {
    required this.style,
    this.textAlign = TextAlign.start,
    super.key,
  });

  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(children: parseInline(text, style)),
      textAlign: textAlign,
    );
  }

  /// Parses inline `***bold italic***`, `**bold**`, `*italic*` markers.
  /// Returns a flat list of [InlineSpan]s suitable for [Text.rich].
  static List<InlineSpan> parseInline(String text, TextStyle base) {
    final spans = <InlineSpan>[];
    // Order matters: *** must be matched before ** and *.
    final re = RegExp(r'\*\*\*(.+?)\*\*\*|\*\*(.+?)\*\*|\*(.+?)\*');
    int cursor = 0;
    for (final m in re.allMatches(text)) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, m.start), style: base));
      }
      if (m.group(1) != null) {
        spans.add(TextSpan(
          text: m.group(1),
          style: base.copyWith(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ));
      } else if (m.group(2) != null) {
        spans.add(TextSpan(
          text: m.group(2),
          style: base.copyWith(fontWeight: FontWeight.w600),
        ));
      } else {
        spans.add(TextSpan(
          text: m.group(3),
          style: base.copyWith(fontStyle: FontStyle.italic),
        ));
      }
      cursor = m.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor), style: base));
    }
    return spans.isEmpty ? [TextSpan(text: text, style: base)] : spans;
  }
}
