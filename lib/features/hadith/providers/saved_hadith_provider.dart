import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State notifier for managing saved hadith
class SavedHadithNotifier extends StateNotifier<List<String>> {
  SavedHadithNotifier() : super([]);

  bool isHadithSaved(String hadithId) {
    return state.contains(hadithId);
  }

  void toggleSaveHadith(String hadithId) {
    if (isHadithSaved(hadithId)) {
      unsaveHadith(hadithId);
    } else {
      saveHadith(hadithId);
    }
  }

  void saveHadith(String hadithId) {
    if (isHadithSaved(hadithId)) return;
    state = [...state, hadithId];
  }

  void unsaveHadith(String hadithId) {
    state = state.where((id) => id != hadithId).toList();
  }

  void clearAllSaved() {
    state = [];
  }
}

/// Provider for saved hadith
final savedHadithProvider =
    StateNotifierProvider<SavedHadithNotifier, List<String>>(
  (ref) => SavedHadithNotifier(),
);

/// Helper provider to check if a specific hadith is saved
final isHadithSavedProvider = Provider.family<bool, String>((ref, hadithId) {
  final savedHadith = ref.watch(savedHadithProvider);
  return savedHadith.contains(hadithId);
});
