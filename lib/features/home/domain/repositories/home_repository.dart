/// Home repository interface.
library;

import 'package:flutter_app/features/home/domain/entities/home_entity.dart';

/// Home dashboard repository interface.
abstract class HomeRepository {
  /// Get home dashboard data.
  Future<HomeDashboardEntity> getDashboard();

  /// Get featured content.
  Future<List<FeaturedContentEntity>> getFeatured();

  /// Get cached dashboard data.
  Future<HomeDashboardEntity?> getCachedDashboard();

  /// Clear cached data.
  Future<void> clearCache();
}
