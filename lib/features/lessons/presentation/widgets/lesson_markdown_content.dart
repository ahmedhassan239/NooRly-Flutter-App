import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

/// Renders lesson content that is in Markdown format (stored in assets/data/lessons.json).
///
/// All 85 local lessons use Markdown:
///   # h1, ## h2, ### h3
///   **bold**, *italic*
///   - bullet lists
///   > blockquotes
///
/// The widget maps each element to the app's design-system typography so the
/// rendered output is consistent with the rest of the lesson screen.
class LessonMarkdownContent extends StatelessWidget {
  const LessonMarkdownContent({
    required this.markdown,
    required this.textColor,
    super.key,
  });

  final String markdown;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MarkdownBody(
      data: markdown,
      selectable: true,
      styleSheet: _buildStyleSheet(colorScheme),
      builders: {
        'blockquote': _BlockquoteBuilder(colorScheme: colorScheme),
      },
    );
  }

  MarkdownStyleSheet _buildStyleSheet(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final blockquoteFill = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.primaryLightBlue.withAlpha(20);
    final blockquoteTextAlpha = isDark ? 0.92 : 0.72;
    final base = TextStyle(
      color: textColor,
      fontSize: 16,
      height: 1.6,
      fontFamily: 'Poppins',
    );

    final headingBase = base.copyWith(fontWeight: FontWeight.w600, height: 1.3);

    return MarkdownStyleSheet(
      p: base,
      pPadding: const EdgeInsets.only(bottom: 12),
      h1: headingBase.copyWith(fontSize: 24),
      h1Padding: const EdgeInsets.only(top: 4, bottom: 8),
      h2: headingBase.copyWith(fontSize: 20),
      h2Padding: const EdgeInsets.only(top: 4, bottom: 8),
      h3: headingBase.copyWith(fontSize: 18),
      h3Padding: const EdgeInsets.only(top: 4, bottom: 6),
      strong: base.copyWith(fontWeight: FontWeight.w600),
      em: base.copyWith(fontStyle: FontStyle.italic),
      code: base.copyWith(
        fontFamily: 'monospace',
        fontSize: 14,
        backgroundColor: colorScheme.surfaceContainerHighest,
        color: colorScheme.primary,
      ),
      codeblockPadding: const EdgeInsets.all(12),
      codeblockDecoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withAlpha(80)),
      ),
      listBullet: base,
      listIndent: 20,
      listBulletPadding: const EdgeInsets.only(right: 8),
      // Blockquote is handled by the custom builder below
      blockquote: base.copyWith(
        color: colorScheme.onSurface.withValues(alpha: blockquoteTextAlpha),
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: BoxDecoration(
        color: blockquoteFill,
        borderRadius: BorderRadius.circular(4),
        border: Border(
          left: BorderSide(
            width: 4,
            color: colorScheme.primary.withValues(alpha: isDark ? 0.75 : 0.7),
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withAlpha(80),
          ),
        ),
      ),
      a: base.copyWith(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
    );
  }
}

/// Custom blockquote builder — gives a left-bordered callout card.
class _BlockquoteBuilder extends MarkdownElementBuilder {
  _BlockquoteBuilder({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final text = element.textContent.trim();
    final isDark = colorScheme.brightness == Brightness.dark;
    final fill = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.primaryLightBlue.withAlpha(20);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(4),
        border: Border(
          left: BorderSide(
            width: 4,
            color: colorScheme.primary.withValues(alpha: isDark ? 0.75 : 0.7),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: isDark ? 0.92 : 0.72),
          fontSize: 16,
          fontStyle: FontStyle.italic,
          height: 1.6,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
