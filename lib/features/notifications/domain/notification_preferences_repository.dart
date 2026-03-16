/// Abstract repository for notification preferences.
library;

import 'notification_preferences_entity.dart';

abstract class NotificationPreferencesRepository {
  Future<NotificationPreferencesEntity> getPreferences();
  Future<NotificationPreferencesEntity> updatePreferences(
    NotificationPreferencesEntity prefs,
  );
  Future<NotificationPreferencesEntity> getLocalPreferences();
  Future<void> saveLocalPreferences(NotificationPreferencesEntity prefs);
}
