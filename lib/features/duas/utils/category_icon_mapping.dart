/// Maps category icon keys from backend to Flutter IconData.
///
/// Use [iconFromKey] for a null-safe IconData. Handles missing keys gracefully.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Default icon when key is missing or unknown.
IconData get defaultCategoryIcon => LucideIcons.bookmark;

/// Returns IconData for a given backend icon key (e.g. "moon", "book", "bed").
/// Falls back to [defaultCategoryIcon] if key is null, empty, or unknown.
IconData iconFromKey(String? key) {
  if (key == null || key.isEmpty) return defaultCategoryIcon;
  final k = key.trim().toLowerCase().replaceAll(' ', '-');
  switch (k) {
    case 'bookmark':
      return LucideIcons.bookmark;
    case 'moon':
      return LucideIcons.moon;
    case 'sun':
      return LucideIcons.sun;
    case 'book':
      return LucideIcons.book;
    case 'book-open':
      return LucideIcons.bookOpen;
    case 'bed':
      return LucideIcons.bed;
    case 'utensils':
      return LucideIcons.utensils;
    case 'car':
      return LucideIcons.car;
    case 'shield':
      return LucideIcons.shield;
    case 'heart':
      return LucideIcons.heart;
    case 'star':
      return LucideIcons.star;
    case 'home':
      return LucideIcons.home;
    case 'hand':
      return LucideIcons.hand;
    case 'sparkles':
      return LucideIcons.sparkles;
    case 'compass':
      return LucideIcons.compass;
    case 'clock':
      return LucideIcons.clock;
    case 'quote':
      return LucideIcons.quote;
    case 'book-marked':
      return LucideIcons.bookMarked;
    case 'repeat':
      return LucideIcons.repeat;
    case 'scroll':
      return LucideIcons.scroll;
    case 'clipboard-list':
      return LucideIcons.clipboardList;
    case 'pray':
      return LucideIcons.hand;
    case 'dhikr':
      return LucideIcons.repeat;
    case 'diamond':
      return LucideIcons.gem;
    case 'mosque':
      return LucideIcons.landmark;
    default:
      return defaultCategoryIcon;
  }
}
