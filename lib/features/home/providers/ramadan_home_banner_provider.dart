import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether the Ramadan promo banner on Home should be shown.
///
/// Dismissal is stored in [SharedPreferences]. It resets automatically when the
/// Gregorian calendar year changes so the banner can appear again in a new year
/// (approx. next Ramadan cycle without hard-coding Hijri).
class RamadanHomeBannerNotifier extends StateNotifier<bool> {
  RamadanHomeBannerNotifier(this._prefs) : super(_computeVisible(_prefs)) {
    _clearStaleDismissalIfNeeded();
  }

  final SharedPreferences _prefs;

  static const String _keyDismissed = 'home_ramadan_banner_dismissed';
  static const String _keyYear = 'home_ramadan_banner_dismissed_gregorian_year';

  static bool _computeVisible(SharedPreferences prefs) {
    final dismissed = prefs.getBool(_keyDismissed) ?? false;
    if (!dismissed) return true;
    final year = prefs.getInt(_keyYear);
    final nowY = DateTime.now().year;
    if (year != nowY) return true;
    return false;
  }

  void _clearStaleDismissalIfNeeded() {
    final dismissed = _prefs.getBool(_keyDismissed) ?? false;
    final year = _prefs.getInt(_keyYear);
    final nowY = DateTime.now().year;
    if (dismissed && year != null && year != nowY) {
      _prefs.remove(_keyDismissed);
      _prefs.remove(_keyYear);
    }
  }

  Future<void> dismiss() async {
    if (!state) return;
    state = false;
    try {
      await _prefs.setBool(_keyDismissed, true);
      await _prefs.setInt(_keyYear, DateTime.now().year);
    } catch (_) {
      // If save fails, keep UI dismissed for this session only.
    }
  }
}

final ramadanHomeBannerVisibleProvider =
    StateNotifierProvider<RamadanHomeBannerNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return RamadanHomeBannerNotifier(prefs);
});
