/// Settings repository implementation.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/settings/data/models/settings_model.dart';
import 'package:flutter_app/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [SettingsRepository].
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required ApiClient apiClient,
    required SharedPreferences prefs,
  })  : _apiClient = apiClient,
        _prefs = prefs;

  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  static const _settingsKey = 'user_settings';

  @override
  Future<SettingsEntity> getSettings() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        SettingsEndpoints.settings,
      );

      if (!response.status || response.data == null) {
        return getLocalSettings();
      }

      final settings = SettingsModel.fromJson(response.data!);

      // Save to local
      await saveLocalSettings(settings.toEntity());

      return settings.toEntity();
    } on ApiException {
      return getLocalSettings();
    } catch (e) {
      if (kDebugMode) {
        print('[Settings] Error fetching settings: $e');
      }
      return getLocalSettings();
    }
  }

  @override
  Future<SettingsEntity> updateSettings(SettingsEntity settings) async {
    final model = SettingsModel(
      language: settings.language,
      themeMode: settings.themeMode,
      notificationsEnabled: settings.notificationsEnabled,
      prayerNotifications: settings.prayerNotifications,
      lessonReminders: settings.lessonReminders,
      dailyVerseNotification: settings.dailyVerseNotification,
      soundEnabled: settings.soundEnabled,
      vibrationEnabled: settings.vibrationEnabled,
      fontSize: settings.fontSize,
      arabicFontSize: settings.arabicFontSize,
    );

    // Save locally first
    await saveLocalSettings(settings);

    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        SettingsEndpoints.update,
        data: model.toJson(),
      );

      if (!response.status) {
        throw UnknownException(message: response.message);
      }

      if (response.data != null) {
        return SettingsModel.fromJson(response.data!).toEntity();
      }
    } catch (e) {
      if (kDebugMode) {
        print('[Settings] Error updating settings on server: $e');
      }
      // Settings saved locally, so don't throw
    }

    return settings;
  }

  @override
  Future<NotificationSettingsEntity> getNotificationSettings() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        SettingsEndpoints.notifications,
      );

      if (!response.status || response.data == null) {
        return const NotificationSettingsEntity();
      }

      return NotificationSettingsModel.fromJson(response.data!);
    } catch (e) {
      if (kDebugMode) {
        print('[Settings] Error fetching notification settings: $e');
      }
      return const NotificationSettingsEntity();
    }
  }

  @override
  Future<NotificationSettingsEntity> updateNotificationSettings(
    NotificationSettingsEntity settings,
  ) async {
    final model = NotificationSettingsModel(
      enabled: settings.enabled,
      prayerTimes: settings.prayerTimes,
      lessonReminders: settings.lessonReminders,
      dailyVerse: settings.dailyVerse,
      weeklyProgress: settings.weeklyProgress,
      sound: settings.sound,
      vibration: settings.vibration,
      quietHoursEnabled: settings.quietHoursEnabled,
      quietHoursStart: settings.quietHoursStart,
      quietHoursEnd: settings.quietHoursEnd,
    );

    final response = await _apiClient.put<Map<String, dynamic>>(
      SettingsEndpoints.updateNotifications,
      data: model.toJson(),
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }

    if (response.data != null) {
      return NotificationSettingsModel.fromJson(response.data!);
    }

    return settings;
  }

  @override
  Future<SettingsEntity> getLocalSettings() async {
    final json = _prefs.getString(_settingsKey);
    if (json == null) {
      return const SettingsEntity();
    }

    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return SettingsModel.fromJson(data).toEntity();
    } catch (e) {
      if (kDebugMode) {
        print('[Settings] Error parsing local settings: $e');
      }
      return const SettingsEntity();
    }
  }

  @override
  Future<void> saveLocalSettings(SettingsEntity settings) async {
    final model = SettingsModel(
      language: settings.language,
      themeMode: settings.themeMode,
      notificationsEnabled: settings.notificationsEnabled,
      prayerNotifications: settings.prayerNotifications,
      lessonReminders: settings.lessonReminders,
      dailyVerseNotification: settings.dailyVerseNotification,
      soundEnabled: settings.soundEnabled,
      vibrationEnabled: settings.vibrationEnabled,
      fontSize: settings.fontSize,
      arabicFontSize: settings.arabicFontSize,
    );

    await _prefs.setString(_settingsKey, jsonEncode(model.toJson()));
  }
}
