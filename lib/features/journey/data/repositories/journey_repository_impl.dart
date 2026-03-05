/// Journey repository implementation.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/errors/api_exception.dart' show ApiException, NotFoundException, UnknownException;
import 'package:flutter_app/features/journey/data/models/journey_model.dart';
import 'package:flutter_app/features/journey/data/models/journey_summary_model.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_summary_entity.dart';
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
  Future<JourneySummaryEntity> getJourneySummary() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      JourneyEndpoints.summary,
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message ?? 'Failed to load journey summary');
    }

    final data = response.data!;
    if (data is! Map<String, dynamic>) {
      throw UnknownException(message: 'Invalid journey summary response');
    }

    return JourneySummaryModel.fromJson(data);
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
    const path = LessonsEndpoints.today;
    if (kDebugMode) {
      final url = '${_apiClient.baseUrl}$path';
      debugPrint('[Journey] getTodayLesson: GET $path  fullUrl=$url');
    }
    try {
      final cached = await CacheManager.get<Map<String, dynamic>>(
        box: CacheBoxes.content,
        key: CacheKeys.currentLesson,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (cached != null && cached.isNotEmpty) {
        if (kDebugMode) debugPrint('[Journey] getTodayLesson: using cache');
        _fetchAndCacheTodayLesson().catchError((_) {});
        return LessonModel.fromJson(cached);
      }
      return _fetchAndCacheTodayLesson();
    } on ApiException catch (e) {
      if (kDebugMode) {
        debugPrint('[Journey] getTodayLesson ApiException: ${e.runtimeType} statusCode=${e.statusCode} message=${e.message}');
      }
      if (e is NotFoundException) return null;
      rethrow;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Journey] getTodayLesson error: $e');
        debugPrint('[Journey] getTodayLesson stackTrace: $st');
      }
      return null;
    }
  }

  Future<LessonEntity?> _fetchAndCacheTodayLesson() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      LessonsEndpoints.today,
    );
    if (kDebugMode) {
      debugPrint('[Journey] _fetchAndCacheTodayLesson: status=${response.status} hasData=${response.data != null}');
      if (response.data != null) {
        final preview = response.data is Map
            ? (response.data as Map).length
            : response.data.toString().length;
        debugPrint('[Journey] _fetchAndCacheTodayLesson: dataLength=$preview');
      }
    }
    if (!response.status || response.data == null) return null;
    final data = response.data!;
    if (data is! Map<String, dynamic> || data.isEmpty) return null;
    try {
      final lesson = LessonModel.fromJson(data);
      await CacheManager.put(
        box: CacheBoxes.content,
        key: CacheKeys.currentLesson,
        data: lesson.toJson(),
        expiry: CacheDurations.homeData,
      );
      return lesson;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Journey] _fetchAndCacheTodayLesson parse error: $e');
        debugPrint('[Journey] _fetchAndCacheTodayLesson stackTrace: $st');
      }
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
    await CacheManager.delete(
      box: CacheBoxes.content,
      key: CacheKeys.currentLesson,
    );
  }
}
