/// Settings providers.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/app/theme_provider.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:flutter_app/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_app/features/settings/domain/repositories/settings_repository.dart';

/// Settings repository provider.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepositoryImpl(apiClient: apiClient, prefs: prefs);
});

/// Settings provider.
final settingsProvider = FutureProvider<SettingsEntity>((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.getSettings();
});

/// Settings notifier for managing settings state.
class SettingsNotifier extends StateNotifier<SettingsEntity> {
  SettingsNotifier(this._ref) : super(const SettingsEntity()) {
    _loadSettings();
  }

  final Ref _ref;

  Future<void> _loadSettings() async {
    final repository = _ref.read(settingsRepositoryProvider);
    state = await repository.getLocalSettings();
  }

  Future<void> setLanguage(String language) async {
    state = state.copyWith(language: language);
    await _saveAndSync();

    // Update app locale persistently
    await _ref.read(localeProvider.notifier).setLocale(Locale(language));
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _saveAndSync();

    // Update app theme
    _ref.read(themeModeProvider.notifier).setThemeMode(themeMode);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _saveAndSync();
  }

  Future<void> setPrayerNotifications(bool enabled) async {
    state = state.copyWith(prayerNotifications: enabled);
    await _saveAndSync();
  }

  Future<void> setLessonReminders(bool enabled) async {
    state = state.copyWith(lessonReminders: enabled);
    await _saveAndSync();
  }

  Future<void> setDailyVerseNotification(bool enabled) async {
    state = state.copyWith(dailyVerseNotification: enabled);
    await _saveAndSync();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _saveAndSync();
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    state = state.copyWith(vibrationEnabled: enabled);
    await _saveAndSync();
  }

  Future<void> setFontSize(FontSize fontSize) async {
    state = state.copyWith(fontSize: fontSize);
    await _saveAndSync();
  }

  Future<void> setArabicFontSize(ArabicFontSize fontSize) async {
    state = state.copyWith(arabicFontSize: fontSize);
    await _saveAndSync();
  }

  Future<void> _saveAndSync() async {
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.saveLocalSettings(state);

    // Sync to server in background
    repository.updateSettings(state).ignore();
  }

  Future<void> syncWithServer() async {
    final repository = _ref.read(settingsRepositoryProvider);
    state = await repository.updateSettings(state);
  }
}

/// Settings notifier provider.
final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, SettingsEntity>((ref) {
  return SettingsNotifier(ref);
});

/// Notification settings provider.
final notificationSettingsProvider =
    FutureProvider<NotificationSettingsEntity>((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.getNotificationSettings();
});

/// Notification settings notifier.
class NotificationSettingsNotifier
    extends StateNotifier<NotificationSettingsEntity> {
  NotificationSettingsNotifier(this._ref)
      : super(const NotificationSettingsEntity());

  final Ref _ref;

  Future<void> update(NotificationSettingsEntity settings) async {
    state = settings;
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.updateNotificationSettings(settings);
  }

  void toggleEnabled(bool enabled) {
    update(state.copyWith(enabled: enabled));
  }

  void togglePrayerTimes(bool enabled) {
    update(state.copyWith(prayerTimes: enabled));
  }

  void toggleLessonReminders(bool enabled) {
    update(state.copyWith(lessonReminders: enabled));
  }

  void toggleDailyVerse(bool enabled) {
    update(state.copyWith(dailyVerse: enabled));
  }

  void toggleSound(bool enabled) {
    update(state.copyWith(sound: enabled));
  }

  void toggleVibration(bool enabled) {
    update(state.copyWith(vibration: enabled));
  }
}

/// Notification settings notifier provider.
final notificationSettingsNotifierProvider = StateNotifierProvider<
    NotificationSettingsNotifier, NotificationSettingsEntity>((ref) {
  return NotificationSettingsNotifier(ref);
});
