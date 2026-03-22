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

/// Returns bundled Ramadan SVG path for legacy keys only.
/// Unknown keys return null so callers can use API [icon_url] or [ramadanGuideLucideFromKey].
String? ramadanSvgAssetFromKey(String? key) {
  if (key == null || key.isEmpty) return _ramadanMoon;
  final k = key.trim().toLowerCase().replaceAll('-', '_');
  switch (k) {
    case 'moon':
    case 'star':
    case 'ramadhan_night_icon':
      return _ramadanMoon;
    case 'sun':
    case 'ramadhan_day_icon':
      return _ramadanSun;
    case 'warning':
    case 'halal_icon':
    case 'firecrackers_icon':
      return _ramadanWarning;
    case 'hands':
    case 'praying_hands':
    case 'pray_icon':
      return _ramadanHands;
    case 'sparkle':
    case 'sparkles':
    case 'eid_icon':
    case 'islmaic_festival_icon':
    case 'celebration':
      return _ramadanSparkles;
    default:
      return null;
  }
}

/// Lucide fallback for Ramadan guide rows when [icon_url] / bundled SVG are unavailable.
IconData ramadanGuideLucideFromKey(String? key) {
  if (key == null || key.isEmpty) return LucideIcons.moon;
  final k = key.trim().toLowerCase().replaceAll('-', '_');
  switch (k) {
    case 'moon':
    case 'star':
    case 'ramadhan_night_icon':
      return LucideIcons.moon;
    case 'sun':
    case 'ramadhan_day_icon':
      return LucideIcons.sun;
    case 'warning':
    case 'halal_icon':
    case 'firecrackers_icon':
      return LucideIcons.alertTriangle;
    case 'hands':
    case 'pray_icon':
    case 'praying_hands':
      return LucideIcons.hand;
    case 'sparkle':
    case 'sparkles':
    case 'eid_icon':
    case 'islmaic_festival_icon':
    case 'celebration':
      return LucideIcons.sparkles;
    case 'mosque':
    case 'mosque_icon':
    case 'mosque_icons':
      return LucideIcons.landmark;
    case 'food':
    case 'meal_bowl_icon':
      return LucideIcons.utensils;
    case 'strength':
    case 'muslim_man_icon':
      return LucideIcons.user;
    case 'money':
    case 'zakat_icon':
      return LucideIcons.coins;
    case 'refresh':
    case 'app_islamic_icon':
      return LucideIcons.bookOpen;
    default:
      return LucideIcons.moonStar;
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
  final k = key.trim().toLowerCase().replaceAll('_', '-');
  switch (k) {
    case 'warning':
    case 'halal-icon':
    case 'firecrackers-icon':
      return const Color(0xFFF5A623);
    case 'hands':
    case 'pray-icon':
      return const Color(0xFFE8B923);
    case 'sparkles':
    case 'sparkle':
    case 'eid-icon':
    case 'islmaic-festival-icon':
      return const Color(0xFFF7E5A3);
    case 'zakat-icon':
      return const Color(0xFF059669);
    case 'mosque-icon':
    case 'mosque-icons':
      return const Color(0xFF1E40AF);
    default:
      return const Color(0xFFE8A317);
  }
}
