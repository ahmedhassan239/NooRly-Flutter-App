/// Settings repository interface.
library;

import 'package:flutter_app/features/settings/domain/entities/settings_entity.dart';

/// Settings repository interface.
abstract class SettingsRepository {
  /// Get user settings.
  Future<SettingsEntity> getSettings();

  /// Update user settings.
  Future<SettingsEntity> updateSettings(SettingsEntity settings);

  /// Get notification settings.
  Future<NotificationSettingsEntity> getNotificationSettings();

  /// Update notification settings.
  Future<NotificationSettingsEntity> updateNotificationSettings(
    NotificationSettingsEntity settings,
  );

  /// Get local settings (from SharedPreferences).
  Future<SettingsEntity> getLocalSettings();

  /// Save local settings.
  Future<void> saveLocalSettings(SettingsEntity settings);
}
