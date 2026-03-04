import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State notifier for managing saved verses
class SavedVersesNotifier extends StateNotifier<List<String>> {
  SavedVersesNotifier() : super([]);

  bool isVerseSaved(String verseId) {
    return state.contains(verseId);
  }

  void toggleSaveVerse(String verseId) {
    if (isVerseSaved(verseId)) {
      unsaveVerse(verseId);
    } else {
      saveVerse(verseId);
    }
  }

  void saveVerse(String verseId) {
    if (isVerseSaved(verseId)) return;
    state = [...state, verseId];
  }

  void unsaveVerse(String verseId) {
    state = state.where((id) => id != verseId).toList();
  }

  void clearAllSaved() {
    state = [];
  }
}

/// Provider for saved verses
final savedVersesProvider =
    StateNotifierProvider<SavedVersesNotifier, List<String>>(
  (ref) => SavedVersesNotifier(),
);

/// Helper provider to check if a specific verse is saved
final isVerseSavedProvider = Provider.family<bool, String>((ref, verseId) {
  final savedVerses = ref.watch(savedVersesProvider);
  return savedVerses.contains(verseId);
});
