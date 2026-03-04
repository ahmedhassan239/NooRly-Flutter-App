import 'package:flutter/material.dart';

/// Design System Typography
///
/// All text styles extracted from Tailwind config
/// Font families: Inter (default), PlayfairDisplay (headings), Amiri (Arabic)
class AppTypography {
  AppTypography._();

  // Font Families - Bundled fonts
  static const String defaultFontFamily = 'Inter';
  static const String headingFontFamily = 'PlayfairDisplay';
  static const String arabicFontFamily = 'Amiri';

  // Display Large - 32px / 600 weight (PlayfairDisplay)
  static TextStyle displayLg({Color? color}) => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
      );

  // Display Medium - 28px / 600 weight (PlayfairDisplay)
  static TextStyle displayMd({Color? color}) => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
      );

  // H1 - 24px / 600 weight (PlayfairDisplay)
  static TextStyle h1({Color? color}) => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
      );

  // H2 - 20px / 600 weight (PlayfairDisplay)
  static TextStyle h2({Color? color}) => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );

  // H3 - 18px / 600 weight (PlayfairDisplay)
  static TextStyle h3({Color? color}) => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      );

  // Body - 16px / 400 weight (Inter)
  static TextStyle body({Color? color}) => TextStyle(
        fontFamily: defaultFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  // Body Small - 14px / 400 weight (Inter)
  static TextStyle bodySm({Color? color}) => TextStyle(
        fontFamily: defaultFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  // Caption - 12px / 400 weight (Inter)
  static TextStyle caption({Color? color}) => TextStyle(
        fontFamily: defaultFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      );

  // Arabic Text Styles (with Amiri font and increased line height)
  static TextStyle arabicBody({Color? color}) => TextStyle(
        fontFamily: arabicFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.75, // Increased for Arabic readability
        color: color,
      );

  static TextStyle arabicH1({Color? color}) => TextStyle(
        fontFamily: arabicFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.75,
        color: color,
      );

  static TextStyle arabicH2({Color? color}) => TextStyle(
        fontFamily: arabicFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.75,
        color: color,
      );

  static TextStyle arabicH3({Color? color}) => TextStyle(
        fontFamily: arabicFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.75,
        color: color,
      );
}
