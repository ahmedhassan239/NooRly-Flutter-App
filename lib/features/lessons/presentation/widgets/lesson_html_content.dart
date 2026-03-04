import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

/// Renders lesson HTML content (from API) with callout styling.
/// Callouts use classes: .callout .callout-info | .callout-warning | .callout-success.
class LessonHtmlContent extends StatelessWidget {
  const LessonHtmlContent({
    required this.html,
    required this.textColor,
    super.key,
  });

  final String html;
  final Color textColor;

  /// Callout colors aligned with backend public/css/callout.css
  static const Color _calloutInfoBg = Color(0xFFE8F1FF);
  static const Color _calloutInfoBorder = Color(0xFF2563EB);
  static const Color _calloutWarningBg = Color(0xFFFFF7E6);
  static const Color _calloutWarningBorder = Color(0xFFCA8A04);
  static const Color _calloutSuccessBg = Color(0xFFE9F9EE);
  static const Color _calloutSuccessBorder = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      style: {
        'body': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        'p': Style(
          margin: Margins.only(bottom: 12),
          fontSize: FontSize(16),
          color: textColor,
        ),
        'div.callout': Style(
          padding: HtmlPaddings.symmetric(horizontal: 14, vertical: 12),
          margin: Margins.symmetric(vertical: 10),
        ),
        'div.callout-info': Style(
          backgroundColor: _calloutInfoBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutInfoBorder),
          ),
        ),
        'div.callout-warning': Style(
          backgroundColor: _calloutWarningBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutWarningBorder),
          ),
        ),
        'div.callout-success': Style(
          backgroundColor: _calloutSuccessBg,
          border: const Border(
            left: BorderSide(width: 4, color: _calloutSuccessBorder),
          ),
        ),
        'div.callout p': Style(margin: Margins.zero),
        'h1': Style(
          fontSize: FontSize(24),
          fontWeight: FontWeight.w600,
          color: textColor,
          margin: Margins.only(bottom: 8),
        ),
        'h2': Style(
          fontSize: FontSize(20),
          fontWeight: FontWeight.w600,
          color: textColor,
          margin: Margins.only(bottom: 8),
        ),
        'h3': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w600,
          color: textColor,
          margin: Margins.only(bottom: 8),
        ),
      },
    );
  }
}
