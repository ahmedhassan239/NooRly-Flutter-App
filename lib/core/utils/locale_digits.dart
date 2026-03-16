/// Helpers for locale-aware display: Eastern Arabic numerals for Arabic locale.
library;

/// Eastern Arabic numeral characters (٠-٩).
const String _easternArabicDigits = '٠١٢٣٤٥٦٧٨٩';

/// Returns true when [languageCode] is Arabic (e.g. 'ar').
bool isArabicLocale(String languageCode) {
  return languageCode == 'ar';
}

/// Replaces Western digits (0-9) in [text] with Eastern Arabic (٠-٩)
/// when [languageCode] is 'ar'. Otherwise returns [text] unchanged.
String toLocaleDigits(String text, String languageCode) {
  if (!isArabicLocale(languageCode)) return text;
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final c = text[i];
    if (c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39) {
      buffer.write(_easternArabicDigits[int.parse(c)]);
    } else {
      buffer.write(c);
    }
  }
  return buffer.toString();
}
