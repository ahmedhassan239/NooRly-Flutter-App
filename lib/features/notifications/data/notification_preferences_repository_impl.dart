/// Notification preferences repository implementation.
///
/// - Reads/writes to API via ApiClient
/// - Caches locally in SharedPreferences
library;

import 'dart:convert';

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kPrefsKey = 'notification_preferences_v1';
const _kPrefsEndpoint = '/notifications/preferences';

class NotificationPreferencesRepositoryImpl
    implements NotificationPreferencesRepository {
  const NotificationPreferencesRepositoryImpl({
    required ApiClient apiClient,
    required SharedPreferences prefs,
  })  : _apiClient = apiClient,
        _prefs = prefs;

  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  @override
  Future<NotificationPreferencesEntity> getPreferences() async {
    final response = await _apiClient.get<Map<String, dynamic>>(_kPrefsEndpoint);
    if (response.status && response.data != null) {
      final entity = NotificationPreferencesEntity.fromJson(response.data!);
      await saveLocalPreferences(entity);
      return entity;
    }
    return await getLocalPreferences();
  }

  @override
  Future<NotificationPreferencesEntity> updatePreferences(
    NotificationPreferencesEntity prefs,
  ) async {
    await saveLocalPreferences(prefs);
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        _kPrefsEndpoint,
        data: prefs.toJson(),
      );
      if (response.status && response.data != null) {
        final updated = NotificationPreferencesEntity.fromJson(response.data!);
        await saveLocalPreferences(updated);
        return updated;
      }
    } catch (_) {
      // Return local copy if API fails
    }
    return prefs;
  }

  @override
  Future<NotificationPreferencesEntity> getLocalPreferences() async {
    final raw = _prefs.getString(_kPrefsKey);
    if (raw == null || raw.isEmpty) {
      return const NotificationPreferencesEntity();
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return NotificationPreferencesEntity.fromJson(map);
    } catch (_) {
      return const NotificationPreferencesEntity();
    }
  }

  @override
  Future<void> saveLocalPreferences(NotificationPreferencesEntity prefs) async {
    await _prefs.setString(_kPrefsKey, jsonEncode(prefs.toJson()));
  }
}
