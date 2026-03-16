/// Maps backend content icon keys to Flutter assets (SVG) or IconData.
/// Used by Ramadan Guide (SVG) and Help Now (Icon).
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Ramadan Guide SVG assets (only these exist under assets/icons/ramadan/).
const String _ramadanMoon = 'assets/icons/ramadan/icon_crescent_moon.svg';
const String _ramadanSun = 'assets/icons/ramadan/icon_sun.svg';
const String _ramadanWarning = 'assets/icons/ramadan/icon_warning.svg';
const String _ramadanHands = 'assets/icons/ramadan/icon_praying_hands.svg';
const String _ramadanSparkles = 'assets/icons/ramadan/icon_sparkles.svg';

/// Returns Ramadan guide SVG asset path for icon key, or null (then use [iconDataFromKey]).
String? ramadanSvgAssetFromKey(String? key) {
  if (key == null || key.isEmpty) return _ramadanMoon;
  final k = key.trim().toLowerCase().replaceAll('-', '_');
  switch (k) {
    case 'moon':
      return _ramadanMoon;
    case 'sun':
      return _ramadanSun;
    case 'warning':
      return _ramadanWarning;
    case 'hands':
    case 'praying_hands':
      return _ramadanHands;
    case 'sparkle':
    case 'sparkles':
      return _ramadanSparkles;
    default:
      return _ramadanMoon;
  }
}

/// Returns IconData for Help Now (and fallback when no SVG). Keys: mosque, heart, clipboard, question, family, support, user, people, refresh, etc.
IconData iconDataFromKey(String? key) {
  if (key == null || key.isEmpty) return noorlyIconMosque;
  final k = key.trim().toLowerCase().replaceAll('-', '_');
  switch (k) {
    case 'mosque':
    case 'landmark':
      return LucideIcons.landmark;
    case 'heart':
      return LucideIcons.heart;
    case 'clipboard':
    case 'clipboard_list':
      return LucideIcons.clipboardList;
    case 'question':
    case 'help':
      return LucideIcons.helpCircle;
    case 'family':
      return LucideIcons.users;
    case 'support':
      return LucideIcons.heartHandshake;
    case 'user':
      return LucideIcons.user;
    case 'people':
      return LucideIcons.users;
    case 'refresh':
      return LucideIcons.refreshCw;
    case 'moon':
      return LucideIcons.moon;
    case 'sun':
      return LucideIcons.sun;
    case 'warning':
      return LucideIcons.alertTriangle;
    case 'hands':
      return LucideIcons.hand;
    case 'sparkles':
      return LucideIcons.sparkles;
    case 'food':
      return LucideIcons.utensils;
    case 'strength':
      return LucideIcons.dumbbell;
    case 'star':
      return LucideIcons.star;
    case 'money':
      return LucideIcons.coins;
    case 'celebration':
      return LucideIcons.partyPopper;
    default:
      return noorlyIconMosque;
  }
}

/// Color for Ramadan accordion icon badges (warm palette).
Color ramadanIconColorFromKey(String? key) {
  if (key == null || key.isEmpty) return const Color(0xFFE8A317);
  final k = key.trim().toLowerCase();
  switch (k) {
    case 'warning':
      return const Color(0xFFF5A623);
    case 'hands':
      return const Color(0xFFE8B923);
    case 'sparkles':
    case 'sparkle':
      return const Color(0xFFF7E5A3);
    default:
      return const Color(0xFFE8A317);
  }
}
