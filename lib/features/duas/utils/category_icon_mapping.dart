/// Unified NooRly icon mapping: one consistent visual style across the app.
///
/// Allowed icon set only: Mosque, Quran, Tasbih, Prayer, Kaaba, Crescent Moon.
/// Use [iconFromKey] for a null-safe IconData. Unknown keys fall back to [defaultCategoryIcon].
/// Content-type mapping: Quran content -> Quran; Prayer/supplication -> Prayer;
/// Dhikr -> Tasbih; Worship/general Islamic -> Mosque; Ramadan/seasons -> Crescent Moon;
/// Spiritual/general faith -> Kaaba.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

// --- Allowed icon set (Journey Week–style presentation: same size, padding, radius, neutral color) ---

/// Mosque – worship / general Islamic content
IconData get noorlyIconMosque => LucideIcons.landmark;

/// Quran – Quran content
IconData get noorlyIconQuran => LucideIcons.bookOpen;

/// Tasbih – Dhikr
IconData get noorlyIconTasbih => LucideIcons.repeat;

/// Prayer – prayer / supplication
IconData get noorlyIconPrayer => LucideIcons.hand;

/// Kaaba – spiritual / general faith themes
IconData get noorlyIconKaaba => LucideIcons.building2;

/// Crescent Moon – Ramadan / seasons
IconData get noorlyIconCrescentMoon => LucideIcons.moon;

/// Star – featured / special content
IconData get noorlyIconStar => LucideIcons.star;

/// Heart – love / favorites content
IconData get noorlyIconHeart => LucideIcons.heart;

/// Book – reading / general book
IconData get noorlyIconBook => LucideIcons.book;

/// Bookmark – saved / marked
IconData get noorlyIconBookmark => LucideIcons.bookmark;

/// Hands – helping / community (hand icon; handHelping not in lucide_icons)
IconData get noorlyIconHands => LucideIcons.hand;

/// Sparkles – highlights / featured
IconData get noorlyIconSparkles => LucideIcons.sparkles;

/// Sun – day / light
IconData get noorlyIconSun => LucideIcons.sun;

/// Moon Star – night / guidance
IconData get noorlyIconMoonStar => LucideIcons.moon;

/// Lantern – light / guidance (distinct from crescent)
IconData get noorlyIconLantern => LucideIcons.lamp;

/// Date Palm – nature / growth
IconData get noorlyIconDatePalm => LucideIcons.treeDeciduous;

/// Compass – direction / guidance
IconData get noorlyIconCompass => LucideIcons.compass;

/// Shield – protection / security
IconData get noorlyIconShield => LucideIcons.shield;

/// Lightbulb – idea / tip
IconData get noorlyIconLightbulb => LucideIcons.lightbulb;

/// Leaf – nature / growth
IconData get noorlyIconLeaf => LucideIcons.leaf;

/// Flag – milestone / marker
IconData get noorlyIconFlag => LucideIcons.flag;

/// Gem – premium / special
IconData get noorlyIconGem => LucideIcons.gem;

/// Message Circle – chat / discussion
IconData get noorlyIconMessageCircle => LucideIcons.messageCircle;

/// Default icon when key is missing or unknown (neutral, minimal).
IconData get defaultCategoryIcon => noorlyIconMosque;

// ---------------------------------------------------------------------------
// Emoji constants — exact visual tokens shown in backend/admin (journey_icons.php)
// ---------------------------------------------------------------------------

const String noorlyEmojiMosque        = '🕌';
const String noorlyEmojiQuran         = '📖';
const String noorlyEmojiTasbih        = '📿';
const String noorlyEmojiCrescent      = '🌙';
const String noorlyEmojiKaaba         = '🕋';
const String noorlyEmojiStar          = '⭐';
const String noorlyEmojiPrayer        = '🤲';
const String noorlyEmojiLantern       = '🏮';
const String noorlyEmojiDatePalm      = '🌴';
const String noorlyEmojiHeart         = '💚';
const String noorlyEmojiBook          = '📕';
const String noorlyEmojiBookmark      = '🔖';
const String noorlyEmojiHands         = '🙌';
const String noorlyEmojiSparkles      = '✨';
const String noorlyEmojiSun           = '☀️';
const String noorlyEmojiMoonStar      = '🌙';
const String noorlyEmojiCompass       = '🧭';
const String noorlyEmojiShield        = '🛡️';
const String noorlyEmojiLightbulb     = '💡';
const String noorlyEmojiLeaf          = '🍃';
const String noorlyEmojiFlag          = '🚩';
const String noorlyEmojiGem           = '💎';
const String noorlyEmojiMessageCircle = '💬';

/// Default emoji fallback.
const String defaultCategoryEmoji = noorlyEmojiMosque;

/// Returns the emoji string for a given backend icon key.
/// Matches [journey_icons.php] exactly. Falls back to [defaultCategoryEmoji] for unknown keys.
String emojiFromKey(String? key) {
  if (key == null || key.isEmpty) return defaultCategoryEmoji;
  final k = key.trim().toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');
  switch (k) {
    case 'mosque':
    case 'landmark':
    case 'worship':
    case 'general':
      return noorlyEmojiMosque;
    case 'quran':
    case 'book_open':
    case 'scroll':
      return noorlyEmojiQuran;
    case 'book':
      return noorlyEmojiBook;
    case 'bookmark':
      return noorlyEmojiBookmark;
    case 'tasbih':
    case 'dhikr':
    case 'repeat':
      return noorlyEmojiTasbih;
    case 'prayer':
    case 'pray':
    case 'hand':
    case 'supplication':
      return noorlyEmojiPrayer;
    case 'hands':
      return noorlyEmojiHands;
    case 'kaaba':
    case 'building':
    case 'spiritual':
    case 'faith':
      return noorlyEmojiKaaba;
    case 'crescent':
    case 'crescent_moon':
    case 'moon':
    case 'ramadan':
      return noorlyEmojiCrescent;
    case 'moon_star':
    case 'moonstar':
      return noorlyEmojiMoonStar;
    case 'star':
      return noorlyEmojiStar;
    case 'heart':
    case 'love':
      return noorlyEmojiHeart;
    case 'sparkles':
      return noorlyEmojiSparkles;
    case 'lantern':
    case 'lamp':
      return noorlyEmojiLantern;
    case 'date_palm':
    case 'palm':
      return noorlyEmojiDatePalm;
    case 'sun':
      return noorlyEmojiSun;
    case 'compass':
      return noorlyEmojiCompass;
    case 'shield':
      return noorlyEmojiShield;
    case 'lightbulb':
    case 'light_bulb':
      return noorlyEmojiLightbulb;
    case 'leaf':
      return noorlyEmojiLeaf;
    case 'flag':
      return noorlyEmojiFlag;
    case 'gem':
      return noorlyEmojiGem;
    case 'message_circle':
    case 'messagecircle':
      return noorlyEmojiMessageCircle;
    default:
      return defaultCategoryEmoji;
  }
}

/// Returns IconData for a given backend icon key. Only the six allowed icons are supported;
/// aliases map into this set. Falls back to [defaultCategoryIcon] for null, empty, or unknown keys.
IconData iconFromKey(String? key) {
  if (key == null || key.isEmpty) return defaultCategoryIcon;
  final k = key.trim().toLowerCase().replaceAll(' ', '-');
  switch (k) {
    case 'mosque':
    case 'landmark':
    case 'worship':
    case 'general':
      return noorlyIconMosque;
    case 'quran':
    case 'book-open':
    case 'book-marked':
    case 'scroll':
      return noorlyIconQuran;
    case 'book':
      return noorlyIconBook;
    case 'bookmark':
      return noorlyIconBookmark;
    case 'hands':
      return noorlyIconHands;
    case 'sparkles':
      return noorlyIconSparkles;
    case 'sun':
      return noorlyIconSun;
    case 'moon_star':
    case 'moon-star':
    case 'moonstar':
      return noorlyIconMoonStar;
    case 'lantern':
    case 'lamp':
      return noorlyIconLantern;
    case 'date_palm':
    case 'date-palm':
    case 'palm':
      return noorlyIconDatePalm;
    case 'compass':
      return noorlyIconCompass;
    case 'shield':
      return noorlyIconShield;
    case 'lightbulb':
    case 'light-bulb':
      return noorlyIconLightbulb;
    case 'leaf':
      return noorlyIconLeaf;
    case 'flag':
      return noorlyIconFlag;
    case 'gem':
      return noorlyIconGem;
    case 'message_circle':
    case 'message-circle':
    case 'messagecircle':
      return noorlyIconMessageCircle;
    case 'tasbih':
    case 'dhikr':
    case 'repeat':
    case 'circle-dot':
    case 'circle':
      return noorlyIconTasbih;
    case 'prayer':
    case 'pray':
    case 'hand':
    case 'supplication':
      return noorlyIconPrayer;
    case 'kaaba':
    case 'building':
    case 'building2':
    case 'spiritual':
    case 'faith':
      return noorlyIconKaaba;
    case 'crescent':
    case 'crescent_moon':
    case 'crescent-moon':
    case 'moon':
    case 'ramadan':
    case 'seasons':
      return noorlyIconCrescentMoon;
    case 'star':
      return noorlyIconStar;
    case 'heart':
    case 'love':
      return noorlyIconHeart;
    default:
      return defaultCategoryIcon;
  }
}
