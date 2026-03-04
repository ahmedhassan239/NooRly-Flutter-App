/// Remote config repository implementation.
///
/// Fetches from GET /app-config. Response shape: { status, message, data }
/// where data = { settings: { key: value }, home_sections: [ ... ] }.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/remote_config/data/models/app_config_model.dart';
import 'package:flutter_app/features/remote_config/domain/entities/app_config_entity.dart';
import 'package:flutter_app/features/remote_config/domain/repositories/remote_config_repository.dart';

/// Implementation of [RemoteConfigRepository].
class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  RemoteConfigRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// TTL for config cache (refresh at least this often).
  /// Could also refresh at [daily_content_refresh_hour] once per day.
  static const Duration _configTtl = CacheDurations.remoteConfig;

  @override
  Future<AppConfigEntity> getAppConfig() async {
    if (kDebugMode) {
      print('[RemoteConfig] Refresh started: GET ${ConfigEndpoints.appConfig}');
    }
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ConfigEndpoints.appConfig,
      );

      if (!response.status || response.data == null) {
        final cached = await getCachedConfig();
        if (cached != null) return cached;
        throw UnknownException(message: response.message);
      }

      final data = response.data!;
      final config = AppConfigModel.fromJson(data);
      final entity = config.toEntity();

      if (kDebugMode) {
        final settings = data['settings'] as Map<String, dynamic>?;
        final keys = settings?.keys.toList() ?? [];
        print('[RemoteConfig] Parsed keys: $keys');
        print('[RemoteConfig] features_enabled => ${entity.featuresEnabled}');
        print('[RemoteConfig] maintenance_mode => ${entity.maintenanceMode}');
      }

      await CacheManager.put(
        box: CacheBoxes.appConfig,
        key: CacheKeys.remoteConfig,
        data: config.toJson(),
        expiry: _configTtl,
      );

      if (kDebugMode) {
        print('[RemoteConfig] Refresh finished: cached with TTL ${_configTtl.inMinutes}m');
      }
      return entity;
    } on ApiException {
      final cached = await getCachedConfig();
      if (cached != null) {
        if (kDebugMode) print('[RemoteConfig] Network error, using cached config');
        return cached;
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('[RemoteConfig] Error fetching config: $e');
      }
      final cached = await getCachedConfig();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<AppConfigEntity?> getCachedConfig() async {
    try {
      final cached = await CacheManager.get<Map<String, dynamic>>(
        box: CacheBoxes.appConfig,
        key: CacheKeys.remoteConfig,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (cached == null) return null;

      if (kDebugMode) {
        print('[RemoteConfig] Loaded config from cache');
      }
      return AppConfigModel.fromJson(cached).toEntity();
    } catch (e) {
      if (kDebugMode) {
        print('[RemoteConfig] Error reading cached config: $e');
      }
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await CacheManager.delete(
      box: CacheBoxes.appConfig,
      key: CacheKeys.remoteConfig,
    );
  }
}
