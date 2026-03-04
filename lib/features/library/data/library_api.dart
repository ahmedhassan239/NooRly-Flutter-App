/// Library API: tabs, categories, collections, collection details.
library;

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/features/library/data/dto/category_dto.dart';
import 'package:flutter_app/features/library/data/dto/collection_details_dto.dart';
import 'package:flutter_app/features/library/data/dto/collection_dto.dart';
import 'package:flutter_app/features/library/data/dto/content_scope_dto.dart';

/// Fetches library data from the backend (content scopes = tabs, categories, collections).
class LibraryApi {
  const LibraryApi(this._client);

  final ApiClient _client;

  /// GET content-scopes?context=library_tabs — returns tabs sorted by display_order.
  Future<List<ContentScopeDto>> fetchLibraryTabs() async {
    final res = await _client.get<List<ContentScopeDto>>(
      ContentScopeEndpoints.libraryTabs,
      fromJson: _parseList<ContentScopeDto>(
        (e) => ContentScopeDto.fromJson(e as Map<String, dynamic>),
      ),
    );
    return res.data ?? [];
  }

  /// GET library/{scopeKey}/categories — categories for a tab.
  /// For scopeKey 'adhkar' uses GET /categories?scope=adhkar (admin categories).
  Future<List<CategoryDto>> fetchCategories(String scopeKey) async {
    final String path;
    final Map<String, dynamic>? queryParams;
    if (scopeKey == 'adhkar') {
      path = CategoriesEndpoints.list;
      queryParams = {'scope': 'adhkar'};
    } else {
      path = LibraryEndpoints.categories(scopeKey);
      queryParams = null;
    }
    final res = await _client.get<List<CategoryDto>>(
      path,
      queryParameters: queryParams,
      fromJson: _parseList<CategoryDto>(
        (e) => _categoryFromJson(e as Map<String, dynamic>),
      ),
    );
    return res.data ?? [];
  }

  /// Normalize backend "name" to "title", "icon_key" to "icon", "icon_color" to "color".
  CategoryDto _categoryFromJson(Map<String, dynamic> json) {
    final m = Map<String, dynamic>.from(json);
    m['title'] ??= m['name'];
    m['icon'] ??= m['icon_key'];
    m['color'] ??= m['icon_color'];
    return CategoryDto.fromJson(m);
  }

  /// GET library/{scopeKey}/categories/{categoryId}/collections.
  Future<List<CollectionDto>> fetchCollections(
    String scopeKey,
    int categoryId,
  ) async {
    final res = await _client.get<List<CollectionDto>>(
      LibraryEndpoints.collections(scopeKey, categoryId),
      fromJson: _parseList<CollectionDto>(
        (e) => _collectionFromJson(e as Map<String, dynamic>),
      ),
    );
    return res.data ?? [];
  }

  CollectionDto _collectionFromJson(Map<String, dynamic> json) {
    final m = Map<String, dynamic>.from(json);
    m['title'] ??= m['name'] ?? '';
    return CollectionDto.fromJson(m);
  }

  /// GET library/{scopeKey}/collections/{collectionId}.
  Future<CollectionDetailsDto?> fetchCollectionDetails(
    String scopeKey,
    int collectionId,
  ) async {
    final res = await _client.get<CollectionDetailsDto>(
      LibraryEndpoints.collectionDetail(scopeKey, collectionId),
      fromJson: (data) => data is Map<String, dynamic>
          ? CollectionDetailsDto.fromJson(data)
          : throw FormatException('Expected object for collection detail'),
    );
    return res.data;
  }

  List<T> Function(dynamic) _parseList<T>(T Function(dynamic) fromJson) {
    return (data) {
      if (data is! List) return <T>[];
      return data.map((e) => fromJson(e)).toList();
    };
  }
}
