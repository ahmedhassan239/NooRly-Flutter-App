import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/features/duas/presentation/duas_mock_data.dart';

/// State notifier for managing saved duas
class SavedDuasNotifier extends StateNotifier<List<String>> {
  SavedDuasNotifier() : super([]);

  bool isDuaSaved(String duaId) {
    return state.contains(duaId);
  }

  void toggleSaveDua(String duaId) {
    if (isDuaSaved(duaId)) {
      unsaveDua(duaId);
    } else {
      saveDua(duaId);
    }
  }

  void saveDua(String duaId) {
    if (isDuaSaved(duaId)) return;
    state = [...state, duaId];
  }

  void unsaveDua(String duaId) {
    state = state.where((id) => id != duaId).toList();
  }

  void clearAllSaved() {
    state = [];
  }
}

/// Provider for saved duas
final savedDuasProvider =
    StateNotifierProvider<SavedDuasNotifier, List<String>>(
  (ref) => SavedDuasNotifier(),
);

/// Helper provider to check if a specific dua is saved
final isDuaSavedProvider = Provider.family<bool, String>((ref, duaId) {
  final savedDuas = ref.watch(savedDuasProvider);
  return savedDuas.contains(duaId);
});
