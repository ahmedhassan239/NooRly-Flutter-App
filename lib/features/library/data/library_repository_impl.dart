/// Library repository implementation.
library;

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/features/library/data/dto/category_dto.dart';
import 'package:flutter_app/features/library/data/dto/collection_details_dto.dart';
import 'package:flutter_app/features/library/data/dto/collection_dto.dart';
import 'package:flutter_app/features/library/data/dto/content_scope_dto.dart';
import 'package:flutter_app/features/library/data/library_api.dart';
import 'package:flutter_app/features/library/domain/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl({required ApiClient apiClient})
      : _api = LibraryApi(apiClient);

  final LibraryApi _api;

  @override
  Future<List<ContentScopeDto>> fetchLibraryTabs() => _api.fetchLibraryTabs();

  @override
  Future<List<CategoryDto>> fetchCategories(String scopeKey) =>
      _api.fetchCategories(scopeKey);

  @override
  Future<List<CollectionDto>> fetchCollections(
    String scopeKey,
    int categoryId,
  ) =>
      _api.fetchCollections(scopeKey, categoryId);

  @override
  Future<CollectionDetailsDto?> fetchCollectionDetails(
    String scopeKey,
    int collectionId,
  ) =>
      _api.fetchCollectionDetails(scopeKey, collectionId);
}
