/// Saved Hadith API: GET list, POST/DELETE save. No mock.
library;

import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lightweight DTO for saved hadith item (from GET /saved?type=hadith).
class SavedHadithItem {
  const SavedHadithItem({required this.id});
  final int id;

  static SavedHadithItem fromJson(Map<String, dynamic> json) {
    return SavedHadithItem(
      id: (json['id'] as num).toInt(),
    );
  }
}

dynamic _dataFromResponse(dynamic body) {
  if (body == null) return null;
  if (body is Map<String, dynamic> && body.containsKey('data')) {
    return body['data'];
  }
  return body;
}

/// GET /api/v1/saved?type=hadith — returns list of saved hadith (data.data.items).
final savedHadithListProvider =
    FutureProvider<List<SavedHadithItem>>((ref) async {
  final client = ref.watch(apiClientProvider);
  final path = SavedEndpoints.list;
  final res = await client.dio.get<dynamic>(
    path,
    queryParameters: {'type': 'hadith'},
  );
  final data = _dataFromResponse(res.data);
  if (data is! Map<String, dynamic>) return [];
  final items = data['items'] as List<dynamic>? ?? [];
  return items
      .whereType<Map<String, dynamic>>()
      .map((e) => SavedHadithItem.fromJson(e))
      .toList();
});

/// Set of saved hadith IDs derived from savedHadithListProvider.
final savedHadithIdsProvider = Provider<Set<int>>((ref) {
  final list = ref.watch(savedHadithListProvider);
  return list.when(
    data: (items) => items.map((e) => e.id).toSet(),
    loading: () => {},
    error: (_, __) => {},
  );
});

/// Toggles save state for a hadith: POST (save) or DELETE (unsave), then invalidates list.
class ToggleSaveHadithNotifier {
  ToggleSaveHadithNotifier(this._ref);
  final Ref _ref;

  Future<void> toggle(int hadithId) async {
    final ids = _ref.read(savedHadithIdsProvider);
    final isSaved = ids.contains(hadithId);
    final client = _ref.read(apiClientProvider);
    final path = SavedEndpoints.save('hadith', hadithId.toString());

    if (isSaved) {
      await client.dio.delete<dynamic>(path);
    } else {
      await client.dio.post<dynamic>(path);
    }
    _ref.invalidate(savedHadithListProvider);
  }
}

final toggleSaveHadithProvider = Provider<ToggleSaveHadithNotifier>((ref) {
  return ToggleSaveHadithNotifier(ref);
});
