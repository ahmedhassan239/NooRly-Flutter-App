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

/// Cache key for journey per locale so switching language refetches.
String _journeyCacheKey(String localeCode) =>
    '${CacheKeys.journey}_${localeCode.replaceAll(RegExp(r'[^a-z]'), '')}';

/// Cache key for today lesson per locale.
String _currentLessonCacheKey(String localeCode) =>
    '${CacheKeys.currentLesson}_${localeCode.replaceAll(RegExp(r'[^a-z]'), '')}';

/// Implementation of [JourneyRepository].
class JourneyRepositoryImpl implements JourneyRepository {
  JourneyRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<JourneyEntity> getJourney({required String localeCode}) async {
    final cacheKey = _journeyCacheKey(localeCode);
    final lang = localeCode == 'ar' ? 'ar' : 'en';
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        JourneyEndpoints.journey,
        queryParameters: {'lang': lang},
      );

      if (!response.status) {
        final cached = await getCachedJourney(localeCode: localeCode);
        if (cached != null) return cached;
        throw UnknownException(message: response.message);
      }

      final raw = response.data;
      if (raw == null || raw is! Map<String, dynamic>) {
        final cached = await getCachedJourney(localeCode: localeCode);
        if (cached != null) return cached;
        throw UnknownException(message: 'Invalid journey response');
      }

      final journey = JourneyModel.fromJson(raw);

      await CacheManager.put(
        box: CacheBoxes.content,
        key: cacheKey,
        data: journey.toJson(),
        expiry: CacheDurations.homeData,
      );

      return journey;
    } on ApiException {
      final cached = await getCachedJourney(localeCode: localeCode);
      if (cached != null) return cached;
      rethrow;
    } catch (e, st) {
      if (kDebugMode) {
        print('[Journey] Error fetching journey: $e');
        print(st);
      }
      final cached = await getCachedJourney(localeCode: localeCode);
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<JourneySummaryEntity> getJourneySummary({required String localeCode}) async {
    final lang = localeCode == 'ar' ? 'ar' : 'en';
    final response = await _apiClient.get<Map<String, dynamic>>(
      JourneyEndpoints.summary,
      queryParameters: {'lang': lang},
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
  Future<LessonEntity?> getTodayLesson({required String localeCode}) async {
    const path = LessonsEndpoints.today;
    final lang = localeCode == 'ar' ? 'ar' : 'en';
    final cacheKey = _currentLessonCacheKey(localeCode);
    if (kDebugMode) {
      final url = '${_apiClient.baseUrl}$path';
      debugPrint('[Journey] getTodayLesson: GET $path  fullUrl=$url  lang=$lang');
    }
    try {
      final cached = await CacheManager.get<Map<String, dynamic>>(
        box: CacheBoxes.content,
        key: cacheKey,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (cached != null && cached.isNotEmpty) {
        if (kDebugMode) debugPrint('[Journey] getTodayLesson: using cache (locale=$localeCode)');
        _fetchAndCacheTodayLesson(localeCode: localeCode).catchError((_) {});
        return LessonModel.fromJson(cached);
      }
      return _fetchAndCacheTodayLesson(localeCode: localeCode);
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

  Future<LessonEntity?> _fetchAndCacheTodayLesson({required String localeCode}) async {
    final lang = localeCode == 'ar' ? 'ar' : 'en';
    final cacheKey = _currentLessonCacheKey(localeCode);
    final response = await _apiClient.get<Map<String, dynamic>>(
      LessonsEndpoints.today,
      queryParameters: {'lang': lang},
    );
    if (kDebugMode) {
      debugPrint('[Journey] _fetchAndCacheTodayLesson: status=${response.status} hasData=${response.data != null} lang=$lang');
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
        key: cacheKey,
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
  Future<JourneyEntity?> getCachedJourney({required String localeCode}) async {
    final cacheKey = _journeyCacheKey(localeCode);
    try {
      final cached = await CacheManager.get<Map<String, dynamic>>(
        box: CacheBoxes.content,
        key: cacheKey,
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
    for (final locale in ['en', 'ar']) {
      await CacheManager.delete(box: CacheBoxes.content, key: _journeyCacheKey(locale));
      await CacheManager.delete(box: CacheBoxes.content, key: _currentLessonCacheKey(locale));
    }
  }
}
