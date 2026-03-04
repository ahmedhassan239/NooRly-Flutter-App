import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notification mute state notifier
class NotificationMuteNotifier extends StateNotifier<bool> {
  NotificationMuteNotifier() : super(false) {
    _loadMuteState();
  }

  static const String _muteKey = 'notifications_muted';

  Future<void> _loadMuteState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isMuted = prefs.getBool(_muteKey) ?? false;
      state = isMuted;
    } catch (e) {
      // Default to unmuted if there's an error
      state = false;
    }
  }

  Future<void> toggleMute() async {
    final newState = !state;
    state = newState;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_muteKey, newState);
    } catch (e) {
      // Ignore save errors
    }
  }

  Future<void> setMuted(bool muted) async {
    state = muted;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_muteKey, muted);
    } catch (e) {
      // Ignore save errors
    }
  }

  bool get isMuted => state;
}

/// Provider for notification mute state
final notificationMuteProvider =
    StateNotifierProvider<NotificationMuteNotifier, bool>(
  (ref) => NotificationMuteNotifier(),
);
