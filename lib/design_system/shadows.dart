import 'package:flutter/material.dart';

/// Design System Shadows
///
/// BoxShadow definitions from Tailwind config
class AppShadows {
  AppShadows._();

  // Standard shadows
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0D000000), // rgba(0, 0, 0, 0.05)
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0F000000), // rgba(0, 0, 0, 0.06)
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x12000000), // rgba(0, 0, 0, 0.07)
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0, 0, 0, 0.1)
      offset: Offset(0, 10),
      blurRadius: 15,
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x26000000), // rgba(0, 0, 0, 0.15)
      offset: Offset(0, 20),
      blurRadius: 25,
    ),
  ];

  // Special shadows with color
  static const List<BoxShadow> primary = [
    BoxShadow(
      color: Color(0x331E40AF), // rgba(30, 64, 175, 0.2) - Primary blue
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  static const List<BoxShadow> coral = [
    BoxShadow(
      color: Color(0x40FB923C), // rgba(251, 146, 60, 0.25) - Coral
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  // Commonly used
  static const List<BoxShadow> card = md;
  static const List<BoxShadow> button = sm;
  static const List<BoxShadow> dialog = lg;
}
