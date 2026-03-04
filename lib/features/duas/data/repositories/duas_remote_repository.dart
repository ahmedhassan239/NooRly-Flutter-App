/// Duas remote repository implementation.
library;

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/content/data/models/content_model.dart';
import 'package:flutter_app/core/content/data/repositories/content_repository_impl.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart';

/// Duas repository using remote API.
class DuasRemoteRepository extends BaseContentRepository<ContentEntity> {
  DuasRemoteRepository({
    required ApiClient apiClient,
  }) : super(
          apiClient: apiClient,
          contentType: ContentType.dua,
          listEndpoint: DuasEndpoints.list,
          categoriesEndpoint: DuasEndpoints.categories,
          savedEndpoint: DuasEndpoints.saved,
          searchEndpoint: DuasEndpoints.search,
          cacheKey: CacheKeys.duasList,
        );

  @override
  String getDetailEndpoint(String id) => DuasEndpoints.detail(id);

  @override
  String getCategoryEndpoint(String categoryId) =>
      DuasEndpoints.byCategory(categoryId);

  @override
  String getSaveEndpoint(String id) => DuasEndpoints.save(id);

  @override
  ContentEntity parseItem(Map<String, dynamic> json) {
    return ContentModel.fromJson(json, ContentType.dua).toEntity();
  }
}
