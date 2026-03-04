/// Legacy saved adhkar provider - delegates to unified saved providers.
/// Use [toggleSaveProvider] from saved_providers.dart for new code.
library;

import 'package:flutter_app/features/saved/presentation/providers/saved_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Legacy: Check if adhkar is saved using the unified IDs provider.
final isAdhkarSavedProvider = Provider.family<bool, String>((ref, adhkarId) {
  final overrideMap = ref.watch(_adhkarOverrideProvider);
  if (overrideMap.containsKey(adhkarId)) {
    return overrideMap[adhkarId] ?? false;
  }
  final idsAsync = ref.watch(savedAdhkarIdsProvider);
  return idsAsync.valueOrNull?.contains(adhkarId) ?? false;
});

final _adhkarOverrideProvider = StateProvider<Map<String, bool>>((ref) => {});

/// Legacy: Toggle save for adhkar. Use [toggleSaveProvider] from saved_providers.dart instead.
final toggleSaveAdhkarProvider =
    NotifierProvider<ToggleSaveAdhkarNotifier, void>(ToggleSaveAdhkarNotifier.new);

class ToggleSaveAdhkarNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<ToggleSaveResult> toggle(String itemId, bool currentIsSaved) async {
    return ref.read(toggleSaveProvider.notifier).toggle(
      type: 'adhkar',
      itemId: itemId,
      currentIsSaved: currentIsSaved,
    );
  }
}

/// Legacy: Optimistic override for adhkar save state.
final adhkarSaveOverrideProvider =
    StateNotifierProvider<AdhkarSaveOverrideNotifier, Map<String, bool>>(
  (ref) => AdhkarSaveOverrideNotifier(),
);

class AdhkarSaveOverrideNotifier extends StateNotifier<Map<String, bool>> {
  AdhkarSaveOverrideNotifier() : super({});

  void setOverride(String adhkarId, bool isSaved) {
    state = {...state, adhkarId: isSaved};
  }

  void clearOverride(String adhkarId) {
    final next = Map<String, bool>.from(state)..remove(adhkarId);
    state = next;
  }
}

/// Legacy: Pending set for adhkar.
final adhkarSavePendingProvider =
    StateNotifierProvider<AdhkarSavePendingNotifier, Set<String>>(
  (ref) => AdhkarSavePendingNotifier(),
);

class AdhkarSavePendingNotifier extends StateNotifier<Set<String>> {
  AdhkarSavePendingNotifier() : super({});

  void add(String adhkarId) => state = {...state, adhkarId};
  void remove(String adhkarId) {
    final next = Set<String>.from(state)..remove(adhkarId);
    state = next;
  }
}

/// Legacy: Local-only list (not used anymore).
class SavedAdhkarNotifier extends StateNotifier<List<String>> {
  SavedAdhkarNotifier() : super([]);

  bool isAdhkarSaved(String adhkarId) => state.contains(adhkarId);

  void toggleSaveAdhkar(String adhkarId) {
    if (isAdhkarSaved(adhkarId)) {
      unsaveAdhkar(adhkarId);
    } else {
      saveAdhkar(adhkarId);
    }
  }

  void saveAdhkar(String adhkarId) {
    if (isAdhkarSaved(adhkarId)) return;
    state = [...state, adhkarId];
  }

  void unsaveAdhkar(String adhkarId) {
    state = state.where((id) => id != adhkarId).toList();
  }

  void clearAllSaved() {
    state = [];
  }
}

final savedAdhkarProvider =
    StateNotifierProvider<SavedAdhkarNotifier, List<String>>(
  (ref) => SavedAdhkarNotifier(),
);
