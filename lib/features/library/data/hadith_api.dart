/// Hadith library API: categories, collections by category, collection details.
/// All responses wrapped as { status, message, data }; client passes data to fromJson.
library;

import 'package:flutter/foundation.dart';

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/features/library/data/dto/category_dto.dart';
import 'package:flutter_app/features/library/data/dto/hadith_collection_details_response_dto.dart';
import 'package:flutter_app/features/library/data/dto/hadith_collection_dto.dart';

class HadithApi {
  const HadithApi(this._client);

  final ApiClient _client;

  /// GET /api/v1/library/hadith/collections -> List<HadithCollectionDto> from data (all collections, no category).
  Future<List<HadithCollectionDto>> fetchHadithCollectionsAll() async {
    final path = LibraryHadithEndpoints.collections;
    final url = '${ApiConfig.baseUrl}$path';
    if (kDebugMode) {
      debugPrint('[HadithApi] GET $url');
    }
    final res = await _client.get<List<HadithCollectionDto>>(
      path,
      fromJson: (data) => _parseCollections(data),
    );
    if (kDebugMode) {
      debugPrint(
        '[HadithApi] GET $url -> status: ${res.status}, '
        'count: ${res.data?.length ?? 0}, body: ${res.data}',
      );
    }
    return res.data ?? [];
  }

  /// GET /api/v1/library/hadith/categories -> List<CategoryDto> from data
  Future<List<CategoryDto>> fetchHadithCategories() async {
    final path = LibraryHadithEndpoints.categories;
    final url = '${ApiConfig.baseUrl}$path';
    if (kDebugMode) {
      debugPrint('[HadithApi] GET $url');
    }
    final res = await _client.get<List<CategoryDto>>(
      path,
      fromJson: (data) => _parseCategories(data),
    );
    if (kDebugMode) {
      debugPrint(
        '[HadithApi] GET $url -> status: ${res.status}, '
        'count: ${res.data?.length ?? 0}, body: ${res.data}',
      );
    }
    return res.data ?? [];
  }

  List<CategoryDto> _parseCategories(dynamic data) {
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final m = Map<String, dynamic>.from(e);
          m['title'] ??= m['name'];
          return CategoryDto.fromJson(m);
        })
        .toList();
  }

  /// GET /api/v1/library/hadith/categories/{id}/collections -> List<HadithCollectionDto> from data
  Future<List<HadithCollectionDto>> fetchHadithCollectionsByCategory(
    int categoryId,
  ) async {
    final path = LibraryHadithEndpoints.collectionsByCategory(categoryId);
    final url = '${ApiConfig.baseUrl}$path';
    if (kDebugMode) {
      debugPrint('[HadithApi] GET $url');
    }
    final res = await _client.get<List<HadithCollectionDto>>(
      path,
      fromJson: (data) => _parseCollections(data),
    );
    if (kDebugMode) {
      debugPrint(
        '[HadithApi] GET $url -> status: ${res.status}, '
        'count: ${res.data?.length ?? 0}, body: ${res.data}',
      );
    }
    return res.data ?? [];
  }

  List<HadithCollectionDto> _parseCollections(dynamic data) {
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final m = Map<String, dynamic>.from(e);
          m['title'] ??= m['name'] ?? '';
          return HadithCollectionDto.fromJson(m);
        })
        .toList();
  }

  /// GET /api/v1/library/hadith/collections/{id} -> HadithCollectionDetailsResponseDto from data
  Future<HadithCollectionDetailsResponseDto?> fetchHadithCollectionDetails(
    int collectionId,
  ) async {
    final path = LibraryHadithEndpoints.collection(collectionId);
    final url = '${ApiConfig.baseUrl}$path';
    if (kDebugMode) {
      debugPrint('[HadithApi] GET $url');
    }
    final res = await _client.get<HadithCollectionDetailsResponseDto>(
      path,
      fromJson: (data) => data is Map<String, dynamic>
          ? HadithCollectionDetailsResponseDto.fromJson(data)
          : throw FormatException('Expected object for collection detail'),
    );
    if (kDebugMode) {
      debugPrint(
        '[HadithApi] GET $url -> status: ${res.status}, '
        'hadiths: ${res.data?.hadiths.length ?? 0}, body: ${res.data}',
      );
    }
    return res.data;
  }
}
