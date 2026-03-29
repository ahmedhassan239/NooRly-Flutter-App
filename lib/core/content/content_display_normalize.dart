/// Normalizes API / DB text for plain [Text] widgets.
///
/// Fixes:
/// - **Wide gaps between words**: Flutter draws every space/NBSP/em-space at full
///   advance; this collapses horizontal Unicode whitespace **per line** to a single
///   ASCII space (preserves newlines for paragraphs).
/// - **HTML leftovers**: `<br>`, empty `<p>`, block tags → newlines; numeric/name
///   entities including `&nbsp;` / `&#160;`.
/// - **Trailing punctuation spam** (e.g. `,,,,,,`).
///
/// Does **not** remove ZWJ/ZWNJ (U+200C/U+200D) — needed for Arabic shaping.
/// Callers still set [TextDirection] / alignment for RTL/LTR.
library;

/// Shared pipeline for religious / library body text shown in cards and detail screens.
abstract final class ContentDisplayNormalize {
  ContentDisplayNormalize._();

  /// Prepare [raw] for display in a [Text] widget (no HTML renderer).
  static String forDisplay(String? raw) {
    if (raw == null) return '';
    var s = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    s = s.replaceAll('\u2028', '\n');
    s = s.replaceAll('\u2029', '\n\n');
    s = s.replaceAll(RegExp(r'[\u000B\u000C]+'), '\n');

    // Decode entities first so escaped tags (`&lt;p&gt;`) and plain `&nbsp;` in JSON work.
    s = _decodeHtmlEntities(s);
    if (s.contains('<') && s.contains('>')) {
      s = _lightweightHtmlToPlain(s);
    }

    s = _normalizeHorizontalWhitespace(s);
    s = _collapseExcessiveBlankLines(s);
    s = s.trim();
    s = _stripTrailingPunctuationNoise(s);
    s = _collapseExcessiveBlankLines(s);
    return s.trim();
  }

  /// Replace common block/line HTML with newlines, decode entities, strip tags.
  static String _lightweightHtmlToPlain(String html) {
    var t = html;
    t = t.replaceAll(RegExp(r'<p[^>]*>\s*</p>', caseSensitive: false), '');
    t = t.replaceAll(
      RegExp(r'(?:<br\s*/?>\s*){3,}', caseSensitive: false),
      '<br><br>',
    );
    t = t.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    t = t.replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n\n');
    t = t.replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), '');
    t = t.replaceAll(RegExp(r'</div\s*>', caseSensitive: false), '\n');
    t = t.replaceAll(RegExp(r'<div[^>]*>', caseSensitive: false), '');
    t = t.replaceAll(RegExp(r'<[^>]+>'), '');
    return t;
  }

  static String _decodeHtmlEntities(String t) {
    var s = t;
    while (s.contains('&amp;')) {
      s = s.replaceAll('&amp;', '&');
    }
    s = s
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&thinsp;', ' ')
        .replaceAll('&emsp;', ' ')
        .replaceAll('&ensp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'");
    s = s.replaceAllMapped(
      RegExp(r'&#x([0-9a-fA-F]{1,6});'),
      (m) => _unicodeScalarFromHex(m.group(1)!),
    );
    s = s.replaceAllMapped(
      RegExp(r'&#(\d{1,7});'),
      (m) => _unicodeScalarFromDecimal(m.group(1)!),
    );
    return s;
  }

  static String _unicodeScalarFromHex(String hex) {
    final cp = int.tryParse(hex, radix: 16);
    return _codePointToChar(cp);
  }

  static String _unicodeScalarFromDecimal(String dec) {
    final cp = int.tryParse(dec);
    return _codePointToChar(cp);
  }

  static String _codePointToChar(int? cp) {
    if (cp == null || cp < 0 || cp > 0x10FFFF || (cp >= 0xD800 && cp <= 0xDFFF)) {
      return '\uFFFD';
    }
    return String.fromCharCode(cp);
  }

  /// Collapses horizontal whitespace within each line to a single ASCII space.
  /// Newlines are preserved (paragraph boundaries).
  static String _normalizeHorizontalWhitespace(String s) {
    if (s.isEmpty) return s;
    final lines = s.split('\n');
    final out = StringBuffer();
    for (var i = 0; i < lines.length; i++) {
      if (i > 0) out.write('\n');
      out.write(_collapseHorizontalSpaceInLine(lines[i]));
    }
    return out.toString();
  }

  static bool _isHorizontalSpaceRune(int r) {
    if (r == 0x20 || r == 0x09) return true;
    if (r == 0xA0) return true;
    if (r == 0x1680) return true;
    if (r >= 0x2000 && r <= 0x200A) return true;
    if (r == 0x202F || r == 0x205F) return true;
    if (r == 0x3000) return true;
    if (r == 0xFEFF) return true;
    return false;
  }

  static String _collapseHorizontalSpaceInLine(String line) {
    final runes = line.runes.toList();
    final out = <int>[];
    var pendingSpace = false;
    for (final r in runes) {
      if (_isHorizontalSpaceRune(r)) {
        pendingSpace = true;
      } else {
        if (pendingSpace && out.isNotEmpty) {
          out.add(0x20);
        }
        pendingSpace = false;
        out.add(r);
      }
    }
    while (out.isNotEmpty && out.first == 0x20) {
      out.removeAt(0);
    }
    while (out.isNotEmpty && out.last == 0x20) {
      out.removeLast();
    }
    return String.fromCharCodes(out);
  }

  /// At most one blank line between paragraphs (3+ newlines → 2).
  static String _collapseExcessiveBlankLines(String s) {
    return s.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  }

  /// Removes trailing runs of 2+ identical “noise” punctuation marks, and collapses
  /// 2+ trailing ASCII full stops to a single period (ellipsis cleanup).
  static String _stripTrailingPunctuationNoise(String input) {
    if (input.isEmpty) return input;
    var runes = input.runes.toList();

    void trimTrailingSpaces() {
      while (runes.isNotEmpty) {
        final r = runes.last;
        if (_isHorizontalSpaceRune(r)) {
          runes.removeLast();
        } else {
          break;
        }
      }
    }

    trimTrailingSpaces();

    bool isNoiseRune(int r) {
      return r == 0x2C || // ,
          r == 0x2E || // .
          r == 0x60C || // ، Arabic comma
          r == 0x61B || // ؛ Arabic semicolon
          r == 0x61F || // ؟ Arabic question
          r == 0x21 || // !
          r == 0x3F || // ?
          r == 0x3A || // :
          r == 0x3B || // ;
          r == 0x2026 || // …
          r == 0x2D || // -
          r == 0x2014; // —
    }

    while (runes.isNotEmpty) {
      trimTrailingSpaces();
      if (runes.isEmpty) break;

      final last = runes.last;
      if (!isNoiseRune(last)) break;

      var runLen = 0;
      for (var i = runes.length - 1; i >= 0 && runes[i] == last; i--) {
        runLen++;
      }

      if (last == 0x2E && runLen >= 2) {
        runes.removeRange(runes.length - runLen, runes.length);
        runes.add(0x2E);
        continue;
      }

      if (runLen >= 2) {
        runes.removeRange(runes.length - runLen, runes.length);
        continue;
      }

      break;
    }

    trimTrailingSpaces();
    return String.fromCharCodes(runes);
  }
}
