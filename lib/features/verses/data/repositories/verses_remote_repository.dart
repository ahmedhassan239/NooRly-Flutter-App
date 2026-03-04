/// Verses remote repository implementation.
library;

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/content/data/models/content_model.dart';
import 'package:flutter_app/core/content/data/repositories/content_repository_impl.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart';

/// Verses repository using remote API.
class VersesRemoteRepository extends BaseContentRepository<VerseEntity> {
  VersesRemoteRepository({
    required ApiClient apiClient,
  }) : super(
          apiClient: apiClient,
          contentType: ContentType.verse,
          listEndpoint: VersesEndpoints.list,
          categoriesEndpoint: VersesEndpoints.categories,
          savedEndpoint: VersesEndpoints.saved,
          searchEndpoint: VersesEndpoints.search,
          cacheKey: CacheKeys.versesList,
        );

  @override
  String getDetailEndpoint(String id) => VersesEndpoints.detail(id);

  @override
  String getCategoryEndpoint(String categoryId) =>
      VersesEndpoints.byCategory(categoryId);

  @override
  String getSaveEndpoint(String id) => VersesEndpoints.save(id);

  @override
  VerseEntity parseItem(Map<String, dynamic> json) {
    return VerseModel.fromJson(json);
  }
}
