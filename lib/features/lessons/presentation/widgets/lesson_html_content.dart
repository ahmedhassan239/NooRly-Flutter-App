import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

/// Renders lesson HTML content (from API) with callout styling aligned to the
/// backend Filament/Tiptap preview (`tiptap-extensions.css`).
///
/// **Important:** Do not set [Style.color] on every block/inline tag — that
/// overrides inline `style="color:…"` on nested `<span>`s in flutter_html.
/// Default body text color is applied on `body` only so colored/highlighted
/// spans from the editor are preserved.
///
/// Preprocessing rewrites `<blockquote>` to `<div class="callout …">` because
/// flutter_html’s blockquote box styling is unreliable; native `<div
/// class="callout callout-*">` from the API is left as-is and styled below.
///
/// Supported tags (non-exhaustive):
///   Block:  p, h1–h6, ul, ol, li, blockquote (rewritten), div.callout*
///   Inline: span (incl. inline color/background), strong, b, em, i, a, code,
///            br, u, mark
class LessonHtmlContent extends StatelessWidget {
  const LessonHtmlContent({
    required this.html,
    required this.textColor,
    super.key,
  });

  final String html;
  final Color textColor;

  // ── Callout palette (matches Backend/resources/css/tiptap-extensions.css) ──
  static const Color _calloutNoteBg = Color(0xFFF5F5F5);
  static const Color _calloutNoteBorder = Color(0xFF9CA3AF);
  // Info: blue (admin .callout-info)
  static const Color _calloutInfoBg = Color(0xFFE8F1FF);
  static const Color _calloutInfoBorder = Color(0xFF2563EB);
  static const Color _calloutWarnBg = Color(0xFFFFF7E6);
  static const Color _calloutWarnBorder = Color(0xFFCA8A04);
  static const Color _calloutOkBg = Color(0xFFE9F9EE);
  static const Color _calloutOkBorder = Color(0xFF16A34A);
  static const Color _calloutDangerBg = Color(0xFFFFECEC);
  static const Color _calloutDangerBorder = Color(0xFFDC2626);

  /// Maps `<blockquote …>` to `<div class="callout callout-*">` using class
  /// hints from the editor (callout-warning, callout-info, etc.).
  static String _preprocessHtml(String raw) {
    final processed = raw.replaceAllMapped(
      RegExp('<blockquote([^>]*)>', caseSensitive: false),
      (m) {
        final attrs = m.group(1)?.trim() ?? '';
        if (attrs.contains('callout-danger')) {
          return '<div class="callout callout-danger">';
        }
        if (attrs.contains('callout-warning')) {
          return '<div class="callout callout-warning">';
        }
        if (attrs.contains('callout-success')) {
          return '<div class="callout callout-success">';
        }
        if (attrs.contains('callout-note')) {
          return '<div class="callout callout-note">';
        }
        if (attrs.contains('callout-info')) {
          return '<div class="callout callout-info">';
        }
        // Default blockquote → info-style panel (verse / general quote)
        return '<div class="callout callout-info">';
      },
    ).replaceAll(
      RegExp('</blockquote>', caseSensitive: false),
      '</div>',
    );
    return processed;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color tintBg(Color light, Color darkTint) =>
        isDark ? darkTint.withValues(alpha: 0.22) : light;

    final noteBg = tintBg(_calloutNoteBg, const Color(0xFF9CA3AF));
    final infoBg = tintBg(_calloutInfoBg, const Color(0xFF2563EB));
    final warnBg = tintBg(_calloutWarnBg, const Color(0xFFCA8A04));
    final okBg = tintBg(_calloutOkBg, const Color(0xFF16A34A));
    final dangerBg = tintBg(_calloutDangerBg, const Color(0xFFDC2626));

    final noteHeading =
        isDark ? const Color(0xFFE5E7EB) : const Color(0xFF4B5563);
    final infoHeading =
        isDark ? const Color(0xFF93C5FD) : _calloutInfoBorder;
    final warnHeading =
        isDark ? const Color(0xFFFCD34D) : _calloutWarnBorder;
    final okHeading =
        isDark ? const Color(0xFF86EFAC) : _calloutOkBorder;
    final dangerHeading =
        isDark ? const Color(0xFFFCA5A5) : _calloutDangerBorder;

    final markBg = isDark
        ? colorScheme.primary.withValues(alpha: 0.35)
        : const Color(0xFFFEF08A); // yellow-200

    return Html(
      data: _preprocessHtml(html),
      style: {
        // Default text color for the whole fragment — children with inline
        // `color:` keep their own color from the HTML parser.
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: textColor,
          fontSize: FontSize(16),
          lineHeight: const LineHeight(1.6),
        ),

        // Block text — no [color] so <span style="color:…"> wins.
        'p': Style(
          margin: Margins.only(bottom: 12),
          fontSize: FontSize(16),
          lineHeight: const LineHeight(1.6),
        ),

        'h1': Style(
          fontSize: FontSize(24),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 4, bottom: 8),
        ),
        'h2': Style(
          fontSize: FontSize(20),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 4, bottom: 8),
        ),
        'h3': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 4, bottom: 6),
        ),
        'h4': Style(
          fontSize: FontSize(17),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 4, bottom: 6),
        ),
        'h5': Style(
          fontSize: FontSize(16),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 4, bottom: 4),
        ),
        'h6': Style(
          fontSize: FontSize(15),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 4, bottom: 4),
        ),

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
          margin: Margins.only(bottom: 4),
        ),

        // Inline — font styling only; color inherits / inline wins.
        'span': Style(),
        'strong': Style(fontWeight: FontWeight.w600),
        'b': Style(fontWeight: FontWeight.w600),
        'em': Style(fontStyle: FontStyle.italic),
        'i': Style(fontStyle: FontStyle.italic),
        'u': Style(textDecoration: TextDecoration.underline),
        'mark': Style(
          backgroundColor: markBg,
          padding: HtmlPaddings.symmetric(horizontal: 2, vertical: 1),
        ),
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

        // Tiptap embed chips (hadith / ayah) — admin uses subtle tinted pills.
        'span.tiptap-embed-chip': Style(
          display: Display.inlineBlock,
          padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 2),
          margin: Margins.only(left: 2, right: 2),
          backgroundColor: isDark
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.9)
              : colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.35),
          ),
          fontSize: FontSize(13),
          lineHeight: const LineHeight(1.35),
        ),
        'span.tiptap-embed-chip--hadith': Style(
          backgroundColor: isDark
              ? const Color(0xFF22C55E).withValues(alpha: 0.18)
              : const Color(0xFF22C55E).withValues(alpha: 0.10),
          border: Border.all(
            color: const Color(0xFF22C55E).withValues(alpha: 0.35),
          ),
        ),
        'span.tiptap-embed-chip--ayah': Style(
          backgroundColor: isDark
              ? const Color(0xFF3B82F6).withValues(alpha: 0.18)
              : const Color(0xFF3B82F6).withValues(alpha: 0.10),
          border: Border.all(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
          ),
        ),

        // ── Callout blocks (div + blockquote fallback) ───────────────────────
        'div.callout': Style(
          padding: HtmlPaddings.symmetric(horizontal: 16, vertical: 14),
          margin: Margins.symmetric(vertical: 12),
        ),

        'div.callout-note': Style(
          backgroundColor: noteBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutNoteBorder),
          ),
        ),
        'div.callout-info': Style(
          backgroundColor: infoBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutInfoBorder),
          ),
        ),
        'div.callout-warning': Style(
          backgroundColor: warnBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutWarnBorder),
          ),
        ),
        'div.callout-success': Style(
          backgroundColor: okBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutOkBorder),
          ),
        ),
        'div.callout-danger': Style(
          backgroundColor: dangerBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutDangerBorder),
          ),
        ),

        // Paragraphs inside callouts — no forced color.
        'div.callout p': Style(
          margin: Margins.only(bottom: 6),
          fontSize: FontSize(16),
          lineHeight: const LineHeight(1.65),
        ),
        'div.callout strong': Style(fontWeight: FontWeight.w700),
        'div.callout b': Style(fontWeight: FontWeight.w700),

        // Headings inside callouts — variant accent colors.
        'div.callout-note h2': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w700,
          color: noteHeading,
          margin: Margins.only(bottom: 8),
        ),
        'div.callout-note h3': Style(
          fontSize: FontSize(16),
          fontWeight: FontWeight.w700,
          color: noteHeading,
          margin: Margins.only(bottom: 6),
        ),
        'div.callout-info h2': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w700,
          color: infoHeading,
          margin: Margins.only(bottom: 8),
        ),
        'div.callout-info h3': Style(
          fontSize: FontSize(16),
          fontWeight: FontWeight.w700,
          color: infoHeading,
          margin: Margins.only(bottom: 6),
        ),
        'div.callout-warning h2': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w700,
          color: warnHeading,
          margin: Margins.only(bottom: 8),
        ),
        'div.callout-warning h3': Style(
          fontSize: FontSize(16),
          fontWeight: FontWeight.w700,
          color: warnHeading,
          margin: Margins.only(bottom: 6),
        ),
        'div.callout-success h2': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w700,
          color: okHeading,
          margin: Margins.only(bottom: 8),
        ),
        'div.callout-success h3': Style(
          fontSize: FontSize(16),
          fontWeight: FontWeight.w700,
          color: okHeading,
          margin: Margins.only(bottom: 6),
        ),
        'div.callout-danger h2': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w700,
          color: dangerHeading,
          margin: Margins.only(bottom: 8),
        ),
        'div.callout-danger h3': Style(
          fontSize: FontSize(16),
          fontWeight: FontWeight.w700,
          color: dangerHeading,
          margin: Margins.only(bottom: 6),
        ),

        // Rare: unparsed blockquote — match info panel.
        'blockquote': Style(
          margin: Margins.symmetric(vertical: 12),
          padding: HtmlPaddings.symmetric(horizontal: 16, vertical: 14),
          backgroundColor: infoBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutInfoBorder),
          ),
        ),
      },
    );
  }
}
