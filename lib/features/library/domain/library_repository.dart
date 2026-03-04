/// Library repository interface (tabs, categories, collections).
library;

import 'package:flutter_app/features/library/data/dto/category_dto.dart';
import 'package:flutter_app/features/library/data/dto/collection_details_dto.dart';
import 'package:flutter_app/features/library/data/dto/collection_dto.dart';
import 'package:flutter_app/features/library/data/dto/content_scope_dto.dart';

abstract class LibraryRepository {
  Future<List<ContentScopeDto>> fetchLibraryTabs();
  Future<List<CategoryDto>> fetchCategories(String scopeKey);
  Future<List<CollectionDto>> fetchCollections(
    String scopeKey,
    int categoryId,
  );
  Future<CollectionDetailsDto?> fetchCollectionDetails(
    String scopeKey,
    int collectionId,
  );
}
