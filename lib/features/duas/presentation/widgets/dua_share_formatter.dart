import 'package:flutter_app/core/content/library_reference_format.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/features/duas/presentation/duas_mock_data.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

/// Dua Share Formatter
///
/// Utility class for formatting Dua content for sharing
class DuaShareFormatter {
  DuaShareFormatter._();

  /// Single-language text for the current app locale ([languageCode] e.g. from
  /// `Localizations.localeOf(context).languageCode`).
  static String formatText(
    DuaData dua,
    String languageCode,
    AppLocalizations l10n,
  ) {
    final sourceLine = formatLooseReligiousSourceLine(
      l10n,
      languageCode,
      dua.source,
      sourceAr: dua.sourceAr,
    );
    return LocalizedReligiousContent.composePlainText(
      languageCode: languageCode,
      arabic: dua.arabic,
      translation: dua.translation,
      source: sourceLine,
    );
  }
}
