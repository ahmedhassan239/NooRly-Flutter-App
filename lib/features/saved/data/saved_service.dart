/// Reusable service for toggling saved state (adhkar, hadith, verse, dua, lesson).
/// Prevents duplicate requests and uses POST/DELETE /saved API.
library;

import 'package:flutter_app/features/saved/data/saved_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Keys for in-flight requests to prevent double-tap and duplicate requests.
String _toggleKey(String type, String itemId) => '$type:$itemId';

/// Service for toggling saved state. Use [toggleSavedItem] from UI.
class SavedService {
  SavedService._();

  static final Set<String> _inFlight = {};

  /// Toggles saved state for an item.
  /// - [ref] — Riverpod ref (e.g. WidgetRef or Ref from provider).
  /// - [type] — Item type: 'adhkar', 'hadith', 'verse', 'dua', 'lesson'.
  /// - [itemId] — Item id (string).
  /// - [currentlySaved] — Current is_saved; if true calls DELETE, else POST.
  ///
  /// Returns true if the request was started and completed successfully.
  /// Returns false if a request for this type+id is already in progress (no duplicate).
  /// Throws on API error (caller should handle and show message).
  static Future<bool> toggleSavedItem(
    Ref ref,
    String type,
    String itemId,
    bool currentlySaved,
  ) async {
    final key = _toggleKey(type, itemId);
    if (_inFlight.contains(key)) return false;
    _inFlight.add(key);
    try {
      if (currentlySaved) {
        await unsaveItem(ref: ref, type: type, itemId: itemId);
      } else {
        await saveItem(ref: ref, type: type, itemId: itemId);
      }
      return true;
    } finally {
      _inFlight.remove(key);
    }
  }

  /// Check if a toggle request is in progress for type+itemId (e.g. for loading UI).
  static bool isToggleInProgress(String type, String itemId) {
    return _inFlight.contains(_toggleKey(type, itemId));
  }
}
