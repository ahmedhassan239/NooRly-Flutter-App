/// Remote config repository interface.
library;

import 'package:flutter_app/features/remote_config/domain/entities/app_config_entity.dart';

/// Remote configuration repository interface.
abstract class RemoteConfigRepository {
  /// Fetch app configuration from server.
  Future<AppConfigEntity> getAppConfig();

  /// Get cached app configuration.
  Future<AppConfigEntity?> getCachedConfig();

  /// Clear cached configuration.
  Future<void> clearCache();
}
