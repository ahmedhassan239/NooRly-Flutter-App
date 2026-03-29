import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System Typography
///
/// All text styles extracted from Tailwind config.
/// Font families: Inter (default), PlayfairDisplay (headings).
class AppTypography {
  AppTypography._();

  // Font Families - Bundled fonts
  static const String defaultFontFamily = 'Inter';
  static const String headingFontFamily = 'PlayfairDisplay';

  static String get baseFontFamily => defaultFontFamily;
  static String get baseHeadingFamily => headingFontFamily;

  static TextStyle _applyPlayfairFont(TextStyle base) {
    return GoogleFonts.playfairDisplay(
      textStyle: base,
      fontWeight: base.fontWeight,
      fontSize: base.fontSize,
      height: base.height,
      color: base.color,
    );
  }

  static TextStyle _applyInterFont(TextStyle base) {
    return GoogleFonts.inter(
      textStyle: base,
      fontWeight: base.fontWeight,
      fontSize: base.fontSize,
      height: base.height,
      color: base.color,
    );
  }

  // Display Large - 32px / 600 weight (PlayfairDisplay)
  static TextStyle displayLg({Color? color}) => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
      ).let(_applyPlayfairFont);

  // Display Medium - 28px / 600 weight (PlayfairDisplay)
  static TextStyle displayMd({Color? color}) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
      ).let(_applyPlayfairFont);

  // H1 - 24px / 600 weight (PlayfairDisplay)
  static TextStyle h1({Color? color}) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
      ).let(_applyPlayfairFont);

  // H2 - 20px / 600 weight (PlayfairDisplay)
  static TextStyle h2({Color? color}) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      ).let(_applyPlayfairFont);

  // H3 - 18px / 600 weight (PlayfairDisplay)
  static TextStyle h3({Color? color}) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      ).let(_applyPlayfairFont);

  // Body - 16px / 400 weight (Inter)
  static TextStyle body({Color? color}) => TextStyle(
        fontFamily: null,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      ).let(_applyInterFont);

  // Body Small - 14px / 400 weight (Inter)
  static TextStyle bodySm({Color? color}) => TextStyle(
        fontFamily: null,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      ).let(_applyInterFont);

  // Caption - 12px / 400 weight (Inter)
  static TextStyle caption({Color? color}) => TextStyle(
        fontFamily: null,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      ).let(_applyInterFont);

  /// Arabic religious/body blocks — same as [body] (no separate Arabic font).
  static TextStyle arabicBody({Color? color}) => body(color: color);

  /// Same fonts as [h1]; keeps the heavier weight used for prominent Arabic blocks.
  static TextStyle arabicH1({Color? color}) =>
      h1(color: color).copyWith(fontWeight: FontWeight.w700);

  /// Same as [h2] (no separate Arabic font).
  static TextStyle arabicH2({Color? color}) => h2(color: color);

  /// Same as [h3] (no separate Arabic font).
  static TextStyle arabicH3({Color? color}) => h3(color: color);

  /// Label style for `AppButton` / elevated buttons.
  static TextStyle buttonLabel(BuildContext context, {Color? color}) {
    return _applyInterFont(
      TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: color,
      ),
    ).copyWith(letterSpacing: 0, wordSpacing: 0);
  }
}

extension _TextStyleX on TextStyle {
  TextStyle let(TextStyle Function(TextStyle) transform) => transform(this);
}
