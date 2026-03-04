/// Generic content repository interface.
library;

import 'package:flutter_app/core/api/api_response.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart';

/// Generic content repository interface.
///
/// Used for Duas, Hadith, Verses, and Adhkar.
abstract class ContentRepository<T extends ContentEntity> {
  /// Get all items.
  Future<List<T>> getAll({int? page, int? perPage});

  /// Get item by ID.
  Future<T> getById(String id);

  /// Get items by category.
  Future<List<T>> getByCategory(String categoryId, {int? page, int? perPage});

  /// Get all categories.
  Future<List<CategoryEntity>> getCategories();

  /// Get saved/favorite items.
  Future<List<T>> getSaved();

  /// Save/favorite an item.
  Future<void> save(String id);

  /// Unsave/unfavorite an item.
  Future<void> unsave(String id);

  /// Search items.
  Future<List<T>> search(String query, {int? page, int? perPage});

  /// Get cached items.
  Future<List<T>?> getCached();

  /// Clear cache.
  Future<void> clearCache();
}

/// Paginated content result.
class PaginatedContentResult<T> {
  const PaginatedContentResult({
    required this.items,
    this.pagination,
  });

  final List<T> items;
  final ApiPagination? pagination;

  bool get hasMore => pagination?.hasMore ?? false;
}
