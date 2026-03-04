
import 'package:flutter/material.dart';

abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

abstract class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  
  static const double defaultRadius = md;
}

abstract class AppShadows {
  static const List<BoxShadow> xs = [
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> sm = [
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.07), blurRadius: 6, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 15, offset: Offset(0, 10)),
  ];
  
  static const List<BoxShadow> primary = [
    BoxShadow(color: Color.fromRGBO(30, 64, 175, 0.2), blurRadius: 12, offset: Offset(0, 4)),
  ];
  
  static const List<BoxShadow> coral = [
    BoxShadow(color: Color.fromRGBO(251, 146, 60, 0.25), blurRadius: 12, offset: Offset(0, 4)),
  ];
}
