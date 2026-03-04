/// Home repository implementation.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/home/data/models/home_model.dart';
import 'package:flutter_app/features/home/domain/entities/home_entity.dart';
import 'package:flutter_app/features/home/domain/repositories/home_repository.dart';

/// Implementation of [HomeRepository].
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<HomeDashboardEntity> getDashboard() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        HomeEndpoints.dashboard,
      );

      if (!response.status || response.data == null) {
        // Try cached data
        final cached = await getCachedDashboard();
        if (cached != null) return cached;
        throw UnknownException(message: response.message);
      }

      final dashboard = HomeDashboardModel.fromJson(response.data!);

      // Cache the dashboard
      await CacheManager.put(
        box: CacheBoxes.content,
        key: CacheKeys.homeData,
        data: dashboard.toJson(),
        expiry: CacheDurations.homeData,
      );

      return dashboard.toEntity();
    } on ApiException {
      // Try cached data on API error
      final cached = await getCachedDashboard();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('[Home] Error fetching dashboard: $e');
      }
      final cached = await getCachedDashboard();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<List<FeaturedContentEntity>> getFeatured() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        HomeEndpoints.featured,
      );

      if (!response.status || response.data == null) {
        return [];
      }

      final data = response.data!;
      final items = (data['items'] as List<dynamic>?) ?? [];

      return items
          .map((e) => FeaturedContentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('[Home] Error fetching featured: $e');
      }
      return [];
    }
  }

  @override
  Future<HomeDashboardEntity?> getCachedDashboard() async {
    try {
      final cached = await CacheManager.get<Map<String, dynamic>>(
        box: CacheBoxes.content,
        key: CacheKeys.homeData,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (cached == null) return null;

      return HomeDashboardModel.fromJson(cached).toEntity();
    } catch (e) {
      if (kDebugMode) {
        print('[Home] Error reading cached dashboard: $e');
      }
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await CacheManager.delete(
      box: CacheBoxes.content,
      key: CacheKeys.homeData,
    );
  }
}
