import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

/// Renders lesson HTML content (from API) with callout styling.
///
/// The backend editor outputs <blockquote> for all callout/verse blocks.
/// flutter_html's border/backgroundColor support for blockquote is unreliable
/// in beta. We therefore *preprocess* the HTML: all <blockquote> elements are
/// rewritten to <div class="callout callout-info"> before rendering, which maps
/// to the well-tested class-selector styling path below.
///
/// Supported tags after preprocessing:
///   Block:  p, h1-h3, ul, ol, li, div.callout[-info/-warning/-success]
///   Inline: strong, b, em, i, a, code, br
class LessonHtmlContent extends StatelessWidget {
  const LessonHtmlContent({
    required this.html,
    required this.textColor,
    super.key,
  });

  final String html;
  final Color textColor;

  // ── Callout palette (matches backend brand: teal for verse/info blocks) ───
  // Info / verse / quote: emerald teal (backend uses #0F766E)
  static const Color _calloutInfoBg     = Color(0xFFECFDF5); // emerald-50
  static const Color _calloutInfoBorder = Color(0xFF0F766E); // teal-700
  // Warning: amber
  static const Color _calloutWarnBg     = Color(0xFFFFFBEB); // amber-50
  static const Color _calloutWarnBorder = Color(0xFFB45309); // amber-700
  // Success: green
  static const Color _calloutOkBg       = Color(0xFFF0FDF4); // green-50
  static const Color _calloutOkBorder   = Color(0xFF16A34A); // green-600

  // ── HTML preprocessing ────────────────────────────────────────────────────

  /// Rewrites <blockquote>…</blockquote> to
  /// <div class="callout callout-info">…</div>.
  ///
  /// Rationale: the backend editor uses <blockquote> for all callout/verse
  /// blocks. flutter_html's border rendering for blockquote is unreliable in
  /// the beta version, but class-based div styling works correctly.
  static String _preprocessHtml(String raw) {
    // Replace opening <blockquote> tags (with or without attributes).
    // Any existing class on the blockquote is carried over inside the div.
    var processed = raw.replaceAllMapped(
      RegExp(r'<blockquote([^>]*)>', caseSensitive: false),
      (m) {
        final attrs = m.group(1)?.trim() ?? '';
        // Preserve any variant hint the backend may add (callout-warning, etc.)
        if (attrs.contains('callout-warning')) {
          return '<div class="callout callout-warning">';
        }
        if (attrs.contains('callout-success')) {
          return '<div class="callout callout-success">';
        }
        return '<div class="callout callout-info">';
      },
    );
    // Replace closing tags.
    processed = processed.replaceAll(
      RegExp(r'</blockquote>', caseSensitive: false),
      '</div>',
    );
    return processed;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Html(
      data: _preprocessHtml(html),
      style: {
        // ── Root ────────────────────────────────────────────────────────────
        'body': Style(margin: Margins.zero, padding: HtmlPaddings.zero),

        // ── Body text ───────────────────────────────────────────────────────
        'p': Style(
          margin: Margins.only(bottom: 12),
          fontSize: FontSize(16),
          lineHeight: const LineHeight(1.6),
          color: textColor,
        ),

        // ── Headings ────────────────────────────────────────────────────────
        'h1': Style(
          fontSize: FontSize(24),
          fontWeight: FontWeight.w600,
          color: textColor,
          margin: Margins.only(top: 4, bottom: 8),
        ),
        'h2': Style(
          fontSize: FontSize(20),
          fontWeight: FontWeight.w600,
          color: textColor,
          margin: Margins.only(top: 4, bottom: 8),
        ),
        'h3': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w600,
          color: textColor,
          margin: Margins.only(top: 4, bottom: 6),
        ),

        // ── Lists ────────────────────────────────────────────────────────────
        'ul': Style(
          margin: Margins.only(bottom: 12),
          padding: HtmlPaddings.only(left: 20),
        ),
        'ol': Style(
          margin: Margins.only(bottom: 12),
          padding: HtmlPaddings.only(left: 20),
        ),
        'li': Style(
          fontSize: FontSize(16),
          lineHeight: const LineHeight(1.6),
          color: textColor,
          margin: Margins.only(bottom: 4),
        ),

        // ── Inline ───────────────────────────────────────────────────────────
        'strong': Style(fontWeight: FontWeight.w600, color: textColor),
        'b':      Style(fontWeight: FontWeight.w600, color: textColor),
        'em':     Style(fontStyle: FontStyle.italic,  color: textColor),
        'i':      Style(fontStyle: FontStyle.italic,  color: textColor),
        'a': Style(
          color: colorScheme.primary,
          textDecoration: TextDecoration.underline,
        ),
        'code': Style(
          fontFamily: 'monospace',
          fontSize: FontSize(14),
          backgroundColor: colorScheme.surfaceContainerHighest,
          color: colorScheme.primary,
          padding: HtmlPaddings.symmetric(horizontal: 4, vertical: 2),
        ),

        // ── Callout blocks ───────────────────────────────────────────────────
        // <blockquote> is rewritten to these divs by _preprocessHtml above.
        // Padding/margin come from .callout; color/border from the variant.
        'div.callout': Style(
          padding: HtmlPaddings.symmetric(horizontal: 16, vertical: 14),
          margin: Margins.symmetric(vertical: 12),
        ),

        // Info / verse (emerald teal — matches backend #0F766E)
        'div.callout-info': Style(
          backgroundColor: _calloutInfoBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutInfoBorder),
          ),
        ),

        // Warning (amber)
        'div.callout-warning': Style(
          backgroundColor: _calloutWarnBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutWarnBorder),
          ),
        ),

        // Success (green)
        'div.callout-success': Style(
          backgroundColor: _calloutOkBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutOkBorder),
          ),
        ),

        // Reset margins on paragraphs inside callout divs.
        'div.callout p': Style(
          margin: Margins.only(bottom: 6),
          fontSize: FontSize(16),
          lineHeight: const LineHeight(1.65),
          color: textColor,
        ),

        // Headings inside callouts keep the teal color from inline styles.
        'div.callout h2': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w700,
          color: _calloutInfoBorder,
          margin: Margins.only(bottom: 8),
        ),
        'div.callout h3': Style(
          fontSize: FontSize(16),
          fontWeight: FontWeight.w700,
          color: _calloutInfoBorder,
          margin: Margins.only(bottom: 6),
        ),
        'div.callout strong': Style(
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      },
    );
  }
}
