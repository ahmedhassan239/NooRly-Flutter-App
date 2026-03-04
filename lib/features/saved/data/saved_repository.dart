/// Repository for saved items (adhkar, hadith, verse, dua, lesson).
/// Delegates to API layer; no business logic here.
/// Supported types: 'dua', 'hadith', 'verse', 'lesson', 'adhkar'
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/features/saved/data/saved_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void _log(String msg) {
  if (kDebugMode) debugPrint('[SavedRepository] $msg');
}

/// Handles save/unsave API calls. Use from providers only, not from UI.
class SavedRepository {
  SavedRepository();

  /// POST /api/v1/saved/{type}/{itemId}
  Future<void> save(Ref ref, String type, String itemId) async {
    _log('save($type, $itemId)');
    await saveItem(ref: ref, type: type, itemId: itemId);
  }

  /// DELETE /api/v1/saved/{type}/{itemId}
  Future<void> unsave(Ref ref, String type, String itemId) async {
    _log('unsave($type, $itemId)');
    await unsaveItem(ref: ref, type: type, itemId: itemId);
  }
}
