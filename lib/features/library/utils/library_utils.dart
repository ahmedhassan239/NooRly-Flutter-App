/// Library helpers: hex color parsing and icon mapping.
library;

import 'package:flutter/material.dart';

import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/widgets/backend_remote_icon.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart';
import 'package:flutter_app/features/library/data/dto/content_scope_dto.dart';

/// Parses "#RRGGBB" (or "#AARRGGBB") to [Color]. Returns [fallback] if invalid.
Color parseHexColor(String? hex, [Color? fallback]) {
  final c = AppColors.fromHex(hex);
  return c ?? fallback ?? const Color(0xFF8B5CF6);
}

/// Maps backend icon key to [IconData]. Safe fallback for unknown keys.
/// @deprecated Use [resolveContentScopeEmoji] for Library tabs to match backend/admin visual.
IconData iconKeyToIconData(String? key) => iconFromKey(key);

/// Fallback icon key per Library scope when API icon is null.
/// Used as safety net; primary source is the API icon field.
String scopeKeyToFallbackIconKey(String scopeKey) {
  switch (scopeKey.toLowerCase()) {
    case 'duas':
      return 'prayer';
    case 'adhkar':
      return 'tasbih';
    case 'hadith':
      return 'mosque';
    case 'verses':
      return 'quran';
    default:
      return 'bookmark';
  }
}

/// Resolves icon key for a Content Scope: uses API icon if present, else fallback by scope key.
String resolveContentScopeIconKey(String? apiIcon, String scopeKey) {
  if (apiIcon != null && apiIcon.isNotEmpty) {
    return apiIcon;
  }
  return scopeKeyToFallbackIconKey(scopeKey);
}

/// Resolves the emoji visual for a Content Scope tab.
/// Returns the exact emoji shown in backend/admin (e.g. 🤲, 📖, 💚).
/// Uses API icon if present, else fallback by scope key.
String resolveContentScopeEmoji(String? apiIcon, String scopeKey) {
  final iconKey = resolveContentScopeIconKey(apiIcon, scopeKey);
  return emojiFromKey(iconKey);
}

/// Emoji for the Library "Saved" row/card for [scopeKey].
///
/// Matches the selected tab in [LibraryShellScreen] by using the same resolution
/// as [resolveContentScopeEmoji] for the matching [ContentScopeDto] from the API.
/// When [tabs] is null/empty or the scope is missing, uses [resolveContentScopeEmoji](null, scopeKey).
String savedCardEmojiForLibraryScope(
  String scopeKey,
  List<ContentScopeDto>? tabs,
) {
  if (tabs != null) {
    for (final t in tabs) {
      if (t.key.toLowerCase() == scopeKey.toLowerCase()) {
        return resolveContentScopeEmoji(t.icon, t.key);
      }
    }
  }
  return resolveContentScopeEmoji(null, scopeKey);
}

/// Backend `icon_url` for a library tab scope when the API sends it.
String? contentScopeIconUrlForKey(
  List<ContentScopeDto>? tabs,
  String scopeKey,
) {
  if (tabs == null) return null;
  for (final t in tabs) {
    if (t.key.toLowerCase() == scopeKey.toLowerCase()) {
      final u = t.iconUrl?.trim();
      if (u != null && u.isNotEmpty) return u;
    }
  }
  return null;
}

/// Small leading glyph for library tab rows: remote icon when [iconUrl] is set.
Widget libraryTabLeading({
  required String emoji,
  String? iconUrl,
}) {
  final u = iconUrl?.trim();
  if (u != null && u.isNotEmpty) {
    final resolved = ApiConfig.resolvePublicUrl(u) ?? u;
    return BackendRemoteIcon(
      url: resolved,
      size: 16,
      fallback: Text(emoji, style: const TextStyle(fontSize: 14)),
    );
  }
  return Text(emoji, style: const TextStyle(fontSize: 14));
}
