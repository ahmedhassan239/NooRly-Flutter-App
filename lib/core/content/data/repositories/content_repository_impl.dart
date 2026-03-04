/// Generic content repository implementation.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/content/data/models/content_model.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart';
import 'package:flutter_app/core/content/domain/repositories/content_repository.dart';
import 'package:flutter_app/core/errors/api_exception.dart';

/// Base implementation of content repository.
///
/// Subclass this for specific content types (Duas, Hadith, etc.).
abstract class BaseContentRepository<T extends ContentEntity>
    implements ContentRepository<T> {
  BaseContentRepository({
    required ApiClient apiClient,
    required this.contentType,
    required this.listEndpoint,
    required this.categoriesEndpoint,
    required this.savedEndpoint,
    required this.searchEndpoint,
    required this.cacheKey,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final ContentType contentType;
  final String listEndpoint;
  final String categoriesEndpoint;
  final String savedEndpoint;
  final String searchEndpoint;
  final String cacheKey;

  /// Get detail endpoint for an item.
  String getDetailEndpoint(String id);

  /// Get category endpoint for a category.
  String getCategoryEndpoint(String categoryId);

  /// Get save endpoint for an item.
  String getSaveEndpoint(String id);

  /// Parse item from JSON.
  T parseItem(Map<String, dynamic> json);

  /// Parse items from JSON list.
  List<T> parseItems(List<dynamic> json) {
    return json.map((e) => parseItem(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<T>> getAll({int? page, int? perPage}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        listEndpoint,
        queryParameters: {
          if (page != null) 'page': page,
          if (perPage != null) 'per_page': perPage,
        },
      );

      if (!response.status || response.data == null) {
        final cached = await getCached();
        if (cached != null) return cached;
        throw UnknownException(message: response.message);
      }

      final data = response.data!;
      final items = parseItems((data['items'] ?? data['data'] ?? <dynamic>[]) as List<dynamic>);

      // Cache the items
      await _cacheItems(items);

      return items;
    } on ApiException {
      final cached = await getCached();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('[Content] Error fetching $contentType list: $e');
      }
      final cached = await getCached();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<T> getById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      getDetailEndpoint(id),
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    return parseItem(response.data!);
  }

  @override
  Future<List<T>> getByCategory(
    String categoryId, {
    int? page,
    int? perPage,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      getCategoryEndpoint(categoryId),
      queryParameters: {
        if (page != null) 'page': page,
        if (perPage != null) 'per_page': perPage,
      },
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    final data = response.data!;
    return parseItems((data['items'] ?? data['data'] ?? <dynamic>[]) as List<dynamic>);
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        categoriesEndpoint,
      );

      if (!response.status || response.data == null) {
        return [];
      }

      final data = response.data!;
      final categories = (data['items'] ?? data['data'] ?? data['categories'] ?? <dynamic>[]) as List<dynamic>;

      return categories
          .map((e) => CategoryModel.fromJson(
                e as Map<String, dynamic>,
                type: contentType,
              ).toEntity())
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('[Content] Error fetching $contentType categories: $e');
      }
      return [];
    }
  }

  @override
  Future<List<T>> getSaved() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      savedEndpoint,
    );

    if (!response.status || response.data == null) {
      return [];
    }

    final data = response.data!;
    return parseItems((data['items'] ?? data['data'] ?? <dynamic>[]) as List<dynamic>);
  }

  @override
  Future<void> save(String id) async {
    final response = await _apiClient.post<void>(
      getSaveEndpoint(id),
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }
  }

  @override
  Future<void> unsave(String id) async {
    final response = await _apiClient.delete<void>(
      getSaveEndpoint(id),
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }
  }

  @override
  Future<List<T>> search(String query, {int? page, int? perPage}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      searchEndpoint,
      queryParameters: {
        'q': query,
        if (page != null) 'page': page,
        if (perPage != null) 'per_page': perPage,
      },
    );

    if (!response.status || response.data == null) {
      return [];
    }

    final data = response.data!;
    return parseItems((data['items'] ?? data['data'] ?? <dynamic>[]) as List<dynamic>);
  }

  @override
  Future<List<T>?> getCached() async {
    try {
      final cached = await CacheManager.get<List<dynamic>>(
        box: CacheBoxes.content,
        key: cacheKey,
        fromJson: (json) => json as List<dynamic>,
      );

      if (cached == null) return null;

      return parseItems(cached);
    } catch (e) {
      if (kDebugMode) {
        print('[Content] Error reading cached $contentType: $e');
      }
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await CacheManager.delete(
      box: CacheBoxes.content,
      key: cacheKey,
    );
  }

  /// Cache items.
  Future<void> _cacheItems(List<T> items) async {
    try {
      final jsonList = items.map((e) {
        if (e is ContentModel) {
          return (e as ContentModel).toJson();
        }
        // For other types, create a basic JSON representation
        return {
          'id': e.id,
          'type': e.type.name,
          'arabic_text': e.arabicText,
          'translation': e.translation,
          'title': e.title,
          'category_id': e.categoryId,
        };
      }).toList();

      await CacheManager.put(
        box: CacheBoxes.content,
        key: cacheKey,
        data: jsonList,
        expiry: CacheDurations.contentList,
      );
    } catch (e) {
      if (kDebugMode) {
        print('[Content] Error caching $contentType: $e');
      }
    }
  }
}
