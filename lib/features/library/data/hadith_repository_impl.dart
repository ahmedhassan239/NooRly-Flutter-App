/// Hadith repository implementation.
library;

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/features/library/data/dto/category_dto.dart';
import 'package:flutter_app/features/library/data/dto/hadith_collection_details_response_dto.dart';
import 'package:flutter_app/features/library/data/dto/hadith_collection_dto.dart';
import 'package:flutter_app/features/library/data/hadith_api.dart';
import 'package:flutter_app/features/library/domain/hadith_repository.dart';

class HadithRepositoryImpl implements HadithRepository {
  HadithRepositoryImpl({required ApiClient apiClient})
      : _api = HadithApi(apiClient);

  final HadithApi _api;

  @override
  Future<List<HadithCollectionDto>> fetchHadithCollectionsAll() =>
      _api.fetchHadithCollectionsAll();

  @override
  Future<List<CategoryDto>> fetchHadithCategories() =>
      _api.fetchHadithCategories();

  @override
  Future<List<HadithCollectionDto>> fetchHadithCollectionsByCategory(
    int categoryId,
  ) =>
      _api.fetchHadithCollectionsByCategory(categoryId);

  @override
  Future<HadithCollectionDetailsResponseDto?> fetchHadithCollectionDetails(
    int collectionId,
  ) =>
      _api.fetchHadithCollectionDetails(collectionId);
}
