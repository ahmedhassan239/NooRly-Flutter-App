/// Hadith remote repository implementation.
library;

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/content/data/models/content_model.dart';
import 'package:flutter_app/core/content/data/repositories/content_repository_impl.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart';

/// Hadith repository using remote API.
class HadithRemoteRepository extends BaseContentRepository<HadithEntity> {
  HadithRemoteRepository({
    required ApiClient apiClient,
  }) : super(
          apiClient: apiClient,
          contentType: ContentType.hadith,
          listEndpoint: HadithEndpoints.list,
          categoriesEndpoint: HadithEndpoints.categories,
          savedEndpoint: HadithEndpoints.saved,
          searchEndpoint: HadithEndpoints.search,
          cacheKey: CacheKeys.hadithList,
        );

  @override
  String getDetailEndpoint(String id) => HadithEndpoints.detail(id);

  @override
  String getCategoryEndpoint(String categoryId) =>
      HadithEndpoints.byCategory(categoryId);

  @override
  String getSaveEndpoint(String id) => HadithEndpoints.save(id);

  @override
  HadithEntity parseItem(Map<String, dynamic> json) {
    return HadithModel.fromJson(json);
  }
}
