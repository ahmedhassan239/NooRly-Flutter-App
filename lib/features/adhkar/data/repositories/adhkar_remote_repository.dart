/// Adhkar remote repository implementation.
library;

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/content/data/models/content_model.dart';
import 'package:flutter_app/core/content/data/repositories/content_repository_impl.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart';

/// Adhkar repository using remote API.
class AdhkarRemoteRepository extends BaseContentRepository<DhikrEntity> {
  AdhkarRemoteRepository({
    required ApiClient apiClient,
  }) : super(
          apiClient: apiClient,
          contentType: ContentType.dhikr,
          listEndpoint: AdhkarEndpoints.list,
          categoriesEndpoint: AdhkarEndpoints.categories,
          savedEndpoint: AdhkarEndpoints.saved,
          searchEndpoint: '/adhkar/search', // Not in endpoints, add if needed
          cacheKey: CacheKeys.adhkarList,
        );

  @override
  String getDetailEndpoint(String id) => AdhkarEndpoints.detail(id);

  @override
  String getCategoryEndpoint(String categoryId) =>
      AdhkarEndpoints.byCategory(categoryId);

  @override
  String getSaveEndpoint(String id) => AdhkarEndpoints.save(id);

  @override
  DhikrEntity parseItem(Map<String, dynamic> json) {
    return DhikrModel.fromJson(json);
  }
}
