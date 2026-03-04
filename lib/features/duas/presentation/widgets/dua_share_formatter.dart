import 'package:flutter_app/features/duas/presentation/duas_mock_data.dart';

/// Dua Share Formatter
///
/// Utility class for formatting Dua content for sharing
class DuaShareFormatter {
  DuaShareFormatter._();

  /// Format Dua as shareable text
  ///
  /// Returns formatted text with:
  /// - Arabic text
  /// - Transliteration
  /// - English translation
  /// - Source
  static String formatText(DuaData dua) {
    final buffer = StringBuffer();

    // Arabic
    buffer.writeln(dua.arabic);
    buffer.writeln();

    // Transliteration
    buffer.writeln(dua.transliteration);
    buffer.writeln();

    // Translation
    buffer.writeln('"${dua.translation}"');
    buffer.writeln();

    // Source
    buffer.writeln('— ${dua.source}');

    return buffer.toString();
  }
}
