/// Maps backend icon keys to emoji strings with section-specific fallbacks.
///
/// All functions return the same emoji token shown in backend/admin (journey_icons.php).
/// Use these for section card icons (NoorlySectionIcon / RoundedListCard).
/// Navigation tab icons use iconFromKey() from category_icon_mapping.dart instead.
library;

import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart'
    show emojiFromKey;

/// Fallback backend key per section.
const String kHadithCollectionIconFallback = 'mosque';
const String kVerseCollectionIconFallback  = 'quran';
const String kCategoryIconFallbackPrayer   = 'prayer';
const String kCategoryIconFallbackTasbih   = 'tasbih';

/// Returns the emoji for a backend icon key, or the [fallbackKey] emoji when
/// the key is null / empty / "none".
String emojiFromKeyWithFallback(String? key, String fallbackKey) {
  final k = key?.trim();
  if (k == null || k.isEmpty || k.toLowerCase() == 'none') {
    return emojiFromKey(fallbackKey);
  }
  return emojiFromKey(k);
}

/// Hadith collection icon emoji: backend key or 🕌 mosque.
String iconForHadithCollection(String? key) =>
    emojiFromKeyWithFallback(key, kHadithCollectionIconFallback);

/// Verse collection icon emoji: backend key or 📖 quran.
String iconForVerseCollection(String? key) =>
    emojiFromKeyWithFallback(key, kVerseCollectionIconFallback);

/// Category icon emoji: backend key or section fallback (🤲 prayer / 📿 tasbih).
String iconForCategory(String? key, {String fallbackKey = kCategoryIconFallbackPrayer}) =>
    emojiFromKeyWithFallback(key, fallbackKey);
