/// Journey repository implementation.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/errors/api_exception.dart' show ApiException, NotFoundException, UnknownException;
import 'package:flutter_app/features/journey/data/models/journey_model.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';
import 'package:flutter_app/features/journey/domain/repositories/journey_repository.dart';

/// Implementation of [JourneyRepository].
class JourneyRepositoryImpl implements JourneyRepository {
  JourneyRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<JourneyEntity> getJourney() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        JourneyEndpoints.journey,
      );

      if (!response.status) {
        final cached = await getCachedJourney();
        if (cached != null) return cached;
        throw UnknownException(message: response.message);
      }

      final raw = response.data;
      if (raw == null || raw is! Map<String, dynamic>) {
        final cached = await getCachedJourney();
        if (cached != null) return cached;
        throw UnknownException(message: 'Invalid journey response');
      }

      final journey = JourneyModel.fromJson(raw);

      // Cache the journey
      await CacheManager.put(
        box: CacheBoxes.content,
        key: CacheKeys.journey,
        data: journey.toJson(),
        expiry: CacheDurations.homeData,
      );

      return journey;
    } on ApiException {
      final cached = await getCachedJourney();
      if (cached != null) return cached;
      rethrow;
    } catch (e, st) {
      if (kDebugMode) {
        print('[Journey] Error fetching journey: $e');
        print(st);
      }
      final cached = await getCachedJourney();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<LessonEntity> getLesson(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      LessonsEndpoints.detail(id),
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    return LessonModel.fromJson(response.data!);
  }

  @override
  Future<LessonEntity?> getTodayLesson() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        LessonsEndpoints.today,
      );
      if (!response.status || response.data == null) return null;
      final data = response.data!;
      if (data.isEmpty) return null;
      return LessonModel.fromJson(data);
    } on ApiException catch (e) {
      if (e is NotFoundException) return null;
      rethrow;
    } catch (e) {
      if (kDebugMode) print('[Journey] getTodayLesson error: $e');
      return null;
    }
  }

  @override
  Future<void> completeLesson(String lessonId) async {
    final response = await _apiClient.post<void>(
      JourneyEndpoints.completeLesson(lessonId),
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }

    // Invalidate journey cache
    await clearCache();
  }

  @override
  Future<List<LessonSummaryEntity>> getSavedLessons() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      JourneyEndpoints.saved,
    );

    if (!response.status || response.data == null) {
      return [];
    }

    final data = response.data!;
    final items = (data['items'] ?? data['data'] ?? []) as List;

    return items
        .map((e) => LessonSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveLesson(String lessonId) async {
    final response = await _apiClient.post<void>(
      '/journey/lessons/$lessonId/save',
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }
  }

  @override
  Future<void> unsaveLesson(String lessonId) async {
    final response = await _apiClient.delete<void>(
      '/journey/lessons/$lessonId/save',
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }
  }

  @override
  Future<JourneyEntity?> getCachedJourney() async {
    try {
      final cached = await CacheManager.get<Map<String, dynamic>>(
        box: CacheBoxes.content,
        key: CacheKeys.journey,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (cached == null) return null;

      return JourneyModel.fromJson(cached);
    } catch (e) {
      if (kDebugMode) {
        print('[Journey] Error reading cached journey: $e');
      }
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await CacheManager.delete(
      box: CacheBoxes.content,
      key: CacheKeys.journey,
    );
  }
}
