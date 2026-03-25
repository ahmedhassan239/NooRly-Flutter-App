/// Riverpod providers for saved items: unified toggle, lists, and auth-aware state.
/// Supported types: 'dua', 'hadith', 'verse', 'lesson', 'adhkar'
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/saved/data/saved_api.dart';
import 'package:flutter_app/features/saved/data/saved_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void _log(String msg) {
  if (kDebugMode) debugPrint('[SavedProviders] $msg');
}

/// Repository for save/unsave API. Used by toggle providers.
final savedRepositoryProvider = Provider<SavedRepository>((ref) => SavedRepository());

// =============================================================================
// Pending sets (prevent double-tap per type)
// =============================================================================

final _pendingHadithProvider = StateProvider<Set<String>>((ref) => {});
final _pendingVerseProvider = StateProvider<Set<String>>((ref) => {});
final _pendingAdhkarProvider = StateProvider<Set<String>>((ref) => {});
final _pendingDuaProvider = StateProvider<Set<String>>((ref) => {});
final _pendingLessonProvider = StateProvider<Set<String>>((ref) => {});

StateProvider<Set<String>> _pendingProviderForType(String type) {
  switch (type) {
    case 'hadith':
      return _pendingHadithProvider;
    case 'verse':
      return _pendingVerseProvider;
    case 'adhkar':
      return _pendingAdhkarProvider;
    case 'dua':
      return _pendingDuaProvider;
    case 'lesson':
      return _pendingLessonProvider;
    default:
      return _pendingHadithProvider;
  }
}

// =============================================================================
// Optimistic override maps (id -> isSaved) per type
// =============================================================================

final _overrideHadithProvider = StateProvider<Map<String, bool>>((ref) => {});
final _overrideVerseProvider = StateProvider<Map<String, bool>>((ref) => {});
final _overrideAdhkarProvider = StateProvider<Map<String, bool>>((ref) => {});
final _overrideDuaProvider = StateProvider<Map<String, bool>>((ref) => {});
final _overrideLessonProvider = StateProvider<Map<String, bool>>((ref) => {});

StateProvider<Map<String, bool>> _overrideProviderForType(String type) {
  switch (type) {
    case 'hadith':
      return _overrideHadithProvider;
    case 'verse':
      return _overrideVerseProvider;
    case 'adhkar':
      return _overrideAdhkarProvider;
    case 'dua':
      return _overrideDuaProvider;
    case 'lesson':
      return _overrideLessonProvider;
    default:
      return _overrideHadithProvider;
  }
}

// =============================================================================
// Saved IDs providers (fetched from API)
// =============================================================================

/// Set of saved hadith IDs from GET /saved?type=hadith.
final savedHadithIdsProvider = FutureProvider<Set<String>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return {};
  final result = await fetchSavedHadith(ref: ref, page: 1, perPage: 100);
  return result.items.map((e) => e.id.toString()).toSet();
});

/// Set of saved verse IDs from GET /saved?type=verse.
final savedVerseIdsProvider = FutureProvider<Set<String>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return {};
  final result = await fetchSavedVerses(ref: ref, page: 1, perPage: 100);
  return result.items.map((e) => e.id.toString()).toSet();
});

/// Set of saved adhkar IDs from GET /saved?type=adhkar.
final savedAdhkarIdsProvider = FutureProvider<Set<String>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return {};
  final result = await fetchSavedAdhkar(ref: ref, page: 1, perPage: 100);
  return result.items.map((e) => e.id.toString()).toSet();
});

/// Set of saved dua IDs from GET /saved?type=dua.
final savedDuaIdsProvider = FutureProvider<Set<String>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return {};
  final result = await fetchSavedDuas(ref: ref, page: 1, perPage: 100);
  return result.items.map((e) => e.id.toString()).toSet();
});

/// Set of saved lesson IDs from GET /saved?type=lesson.
final savedLessonIdsProvider = FutureProvider<Set<String>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return {};
  final result = await fetchSavedLessons(ref: ref, page: 1, perPage: 100);
  return result.items.map((e) => e.id.toString()).toSet();
});

FutureProvider<Set<String>> _idsProviderForType(String type) {
  switch (type) {
    case 'hadith':
      return savedHadithIdsProvider;
    case 'verse':
      return savedVerseIdsProvider;
    case 'adhkar':
      return savedAdhkarIdsProvider;
    case 'dua':
      return savedDuaIdsProvider;
    case 'lesson':
      return savedLessonIdsProvider;
    default:
      return savedHadithIdsProvider;
  }
}

// =============================================================================
// Saved list providers (full hydrated items for Saved pages)
// =============================================================================

/// Unified list of all saved items for Saved (All) tab. GET /saved?type=all.
final savedAllListProvider = FutureProvider<SavedAllListResult>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) {
    return const SavedAllListResult(items: [], pagination: SavedAllPagination());
  }
  return fetchSavedAll(ref: ref, page: 1, perPage: 50);
});

/// Full list of saved hadith for Saved Hadith page.
final savedHadithListProvider = FutureProvider<List<SavedHadithItem>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return [];
  final result = await fetchSavedHadith(ref: ref, page: 1, perPage: 100);
  if (!result.hasMore) return result.items;
  final all = <SavedHadithItem>[...result.items];
  int page = 2;
  bool hasMore = result.hasMore;
  while (hasMore && page <= 10) {
    final next = await fetchSavedHadith(ref: ref, page: page, perPage: 100);
    all.addAll(next.items);
    hasMore = next.hasMore;
    page++;
  }
  return all;
});

/// Full list of saved verses for Saved Verses page.
final savedVerseListProvider = FutureProvider<List<SavedVerseItem>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return [];
  final result = await fetchSavedVerses(ref: ref, page: 1, perPage: 100);
  if (!result.hasMore) return result.items;
  final all = <SavedVerseItem>[...result.items];
  int page = 2;
  bool hasMore = result.hasMore;
  while (hasMore && page <= 10) {
    final next = await fetchSavedVerses(ref: ref, page: page, perPage: 100);
    all.addAll(next.items);
    hasMore = next.hasMore;
    page++;
  }
  return all;
});

/// Full list of saved adhkar for Saved Adhkar page.
final savedAdhkarListProvider = FutureProvider<List<SavedAdhkarItem>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return [];
  final result = await fetchSavedAdhkar(ref: ref, page: 1, perPage: 100);
  if (!result.hasMore) return result.items;
  final all = <SavedAdhkarItem>[...result.items];
  int page = 2;
  bool hasMore = result.hasMore;
  while (hasMore && page <= 10) {
    final next = await fetchSavedAdhkar(ref: ref, page: page, perPage: 100);
    all.addAll(next.items);
    hasMore = next.hasMore;
    page++;
  }
  return all;
});

/// Full list of saved duas for Saved Duas page.
final savedDuaListProvider = FutureProvider<List<SavedDuaItem>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return [];
  final result = await fetchSavedDuas(ref: ref, page: 1, perPage: 100);
  if (!result.hasMore) return result.items;
  final all = <SavedDuaItem>[...result.items];
  int page = 2;
  bool hasMore = result.hasMore;
  while (hasMore && page <= 10) {
    final next = await fetchSavedDuas(ref: ref, page: page, perPage: 100);
    all.addAll(next.items);
    hasMore = next.hasMore;
    page++;
  }
  return all;
});

/// Full list of saved lessons for Saved Lessons page.
final savedLessonListProvider = FutureProvider<List<SavedLessonItem>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return [];
  final result = await fetchSavedLessons(ref: ref, page: 1, perPage: 100);
  if (!result.hasMore) return result.items;
  final all = <SavedLessonItem>[...result.items];
  int page = 2;
  bool hasMore = result.hasMore;
  while (hasMore && page <= 10) {
    final next = await fetchSavedLessons(ref: ref, page: page, perPage: 100);
    all.addAll(next.items);
    hasMore = next.hasMore;
    page++;
  }
  return all;
});

// =============================================================================
// Effective isSaved check (API ids + optimistic override)
// =============================================================================

/// Check if item is saved (API + override). Use for UI display.
/// Returns null if still loading.
bool? isItemSaved(WidgetRef ref, String type, String itemId) {
  final overrideMap = ref.watch(_overrideProviderForType(type));
  if (overrideMap.containsKey(itemId)) {
    return overrideMap[itemId];
  }
  final idsAsync = ref.watch(_idsProviderForType(type));
  return idsAsync.valueOrNull?.contains(itemId);
}

/// Check if item is currently being toggled (loading state).
bool isItemPending(WidgetRef ref, String type, String itemId) {
  final pending = ref.watch(_pendingProviderForType(type));
  return pending.contains(itemId);
}

// =============================================================================
// Unified toggle save notifier
// =============================================================================

enum ToggleSaveResult { success, skipped, notAuthenticated, failure }

/// Unified toggle save notifier. Works for all content types.
class ToggleSaveNotifier extends Notifier<void> {
  @override
  void build() {}

  /// Toggle save for [itemId] of [type]. [currentIsSaved] is the current UI state.
  /// Returns result: success, skipped (double-tap), notAuthenticated, or failure.
  Future<ToggleSaveResult> toggle({
    required String type,
    required String itemId,
    required bool currentIsSaved,
  }) async {
    final auth = ref.read(authProvider);
    if (!auth.isAuthenticated) {
      _log('toggle($type, $itemId): not authenticated');
      return ToggleSaveResult.notAuthenticated;
    }

    final pendingProvider = _pendingProviderForType(type);
    final overrideProvider = _overrideProviderForType(type);
    final pending = ref.read(pendingProvider);

    if (pending.contains(itemId)) {
      _log('toggle($type, $itemId): skipped (already pending)');
      return ToggleSaveResult.skipped;
    }

    // Add to pending
    ref.read(pendingProvider.notifier).state = {...pending, itemId};

    // Optimistic update
    final overrides = ref.read(overrideProvider);
    ref.read(overrideProvider.notifier).state = {...overrides, itemId: !currentIsSaved};

    final repo = ref.read(savedRepositoryProvider);

    try {
      if (currentIsSaved) {
        _log('toggle($type, $itemId): unsaving...');
        await repo.unsave(ref, type, itemId);
      } else {
        _log('toggle($type, $itemId): saving...');
        await repo.save(ref, type, itemId);
      }

      // Invalidate relevant providers
      _invalidateProvidersForType(type);

      _log('toggle($type, $itemId): success');
      return ToggleSaveResult.success;
    } catch (e) {
      _log('toggle($type, $itemId): failure - $e');
      // Rollback optimistic update
      ref.read(overrideProvider.notifier).state = {...overrides, itemId: currentIsSaved};
      return ToggleSaveResult.failure;
    } finally {
      // Remove from pending
      final currentPending = ref.read(pendingProvider);
      ref.read(pendingProvider.notifier).state = 
          currentPending.where((id) => id != itemId).toSet();
    }
  }

  void _invalidateProvidersForType(String type) {
    ref.invalidate(savedAllListProvider);
    switch (type) {
      case 'hadith':
        ref.invalidate(savedHadithIdsProvider);
        ref.invalidate(savedHadithListProvider);
        break;
      case 'verse':
        ref.invalidate(savedVerseIdsProvider);
        ref.invalidate(savedVerseListProvider);
        break;
      case 'adhkar':
        ref.invalidate(savedAdhkarIdsProvider);
        ref.invalidate(savedAdhkarListProvider);
        break;
      case 'dua':
        ref.invalidate(savedDuaIdsProvider);
        ref.invalidate(savedDuaListProvider);
        break;
      case 'lesson':
        ref.invalidate(savedLessonIdsProvider);
        ref.invalidate(savedLessonListProvider);
        break;
    }
  }
}

final toggleSaveProvider = NotifierProvider<ToggleSaveNotifier, void>(
  ToggleSaveNotifier.new,
);

// =============================================================================
// Legacy compatibility: hadith toggle controller
// =============================================================================

class SavedHadithToggleNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> toggle(String itemId) async {
    final ids = await ref.read(savedHadithIdsProvider.future);
    final isSaved = ids.contains(itemId);
    final notifier = ref.read(toggleSaveProvider.notifier);
    await notifier.toggle(type: 'hadith', itemId: itemId, currentIsSaved: isSaved);
  }
}

final savedHadithToggleControllerProvider =
    AsyncNotifierProvider<SavedHadithToggleNotifier, void>(
  SavedHadithToggleNotifier.new,
);

// =============================================================================
// Clear all saved state on logout
// =============================================================================

/// Call this on logout to clear all optimistic overrides.
void clearAllSavedState(WidgetRef ref) {
  ref.read(_overrideHadithProvider.notifier).state = {};
  ref.read(_overrideVerseProvider.notifier).state = {};
  ref.read(_overrideAdhkarProvider.notifier).state = {};
  ref.read(_overrideDuaProvider.notifier).state = {};
  ref.read(_overrideLessonProvider.notifier).state = {};
  ref.invalidate(savedHadithIdsProvider);
  ref.invalidate(savedHadithListProvider);
  ref.invalidate(savedVerseIdsProvider);
  ref.invalidate(savedVerseListProvider);
  ref.invalidate(savedAdhkarIdsProvider);
  ref.invalidate(savedAdhkarListProvider);
  ref.invalidate(savedDuaIdsProvider);
  ref.invalidate(savedDuaListProvider);
  ref.invalidate(savedLessonIdsProvider);
  ref.invalidate(savedLessonListProvider);
  ref.invalidate(savedAllListProvider);
}
