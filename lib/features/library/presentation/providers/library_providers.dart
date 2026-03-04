/// Riverpod providers for Library (tabs, categories, collections).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/library/data/dto/category_dto.dart';
import 'package:flutter_app/features/library/data/dto/collection_details_dto.dart';
import 'package:flutter_app/features/library/data/dto/collection_dto.dart';
import 'package:flutter_app/features/library/data/dto/content_scope_dto.dart';
import 'package:flutter_app/features/library/data/dto/hadith_collection_details_response_dto.dart';
import 'package:flutter_app/features/library/data/dto/hadith_collection_dto.dart';
import 'package:flutter_app/features/library/data/hadith_repository_impl.dart';
import 'package:flutter_app/features/library/data/library_repository_impl.dart';
import 'package:flutter_app/features/library/domain/hadith_repository.dart';
import 'package:flutter_app/features/library/domain/library_repository.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LibraryRepositoryImpl(apiClient: apiClient);
});

/// Library tabs from API (content-scopes?context=library_tabs). No mock.
/// Kept alive so tab switch (context.go) does not refetch and lose state.
final libraryTabsProvider =
    FutureProvider<List<ContentScopeDto>>((ref) async {
  ref.keepAlive();
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.fetchLibraryTabs();
});

/// Currently selected tab: scope key (e.g. hadith, verses). Updated when user switches tab.
final selectedLibraryTabProvider = StateProvider<String>((ref) => '');

/// Categories for a scope. Family: scopeKey.
final libraryCategoriesProvider =
    FutureProvider.family<List<CategoryDto>, String>((ref, scopeKey) async {
  if (scopeKey.isEmpty) return [];
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.fetchCategories(scopeKey);
});

/// Adhkar tab categories from GET /categories?scope=adhkar. Kept alive so tab switch preserves data.
final libraryAdhkarCategoriesProvider =
    FutureProvider<List<CategoryDto>>((ref) async {
  ref.keepAlive();
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.fetchCategories('adhkar');
});

/// Collections for a category. Family: (scopeKey, categoryId).
final libraryCollectionsProvider =
    FutureProvider.family<List<CollectionDto>, ({String scopeKey, int categoryId})>(
  (ref, params) async {
    final repo = ref.watch(libraryRepositoryProvider);
    return repo.fetchCollections(params.scopeKey, params.categoryId);
  },
);

/// Collection detail. Family: (scopeKey, collectionId).
final libraryCollectionDetailsProvider =
    FutureProvider.family<CollectionDetailsDto?, ({String scopeKey, int collectionId})>(
  (ref, params) async {
    final repo = ref.watch(libraryRepositoryProvider);
    return repo.fetchCollectionDetails(params.scopeKey, params.collectionId);
  },
);

/// Client-side search query for filtering categories/collections by title.
final librarySearchQueryProvider = StateProvider<String>((ref) => '');

// ---------------------------------------------------------------------------
// Hadith tab (Library → categories → collections → collection details)
// ---------------------------------------------------------------------------

final hadithRepositoryProvider = Provider<HadithRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HadithRepositoryImpl(apiClient: apiClient);
});

/// All hadith collections from GET /library/hadith/collections (no categories). No mock.
/// Kept alive so tab switch preserves data.
final hadithCollectionsAllProvider =
    FutureProvider<List<HadithCollectionDto>>((ref) async {
  ref.keepAlive();
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.fetchHadithCollectionsAll();
});

/// Hadith categories. No mock. (Legacy; prefer hadithCollectionsAllProvider.)
final hadithCategoriesProvider =
    FutureProvider<List<CategoryDto>>((ref) async {
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.fetchHadithCategories();
});

/// Hadith collections for a category. Family: categoryId.
final hadithCollectionsByCategoryProvider =
    FutureProvider.family<List<HadithCollectionDto>, int>(
  (ref, categoryId) async {
    final repo = ref.watch(hadithRepositoryProvider);
    return repo.fetchHadithCollectionsByCategory(categoryId);
  },
);

/// Hadith collection detail (collection meta + hadiths). Family: collectionId.
final hadithCollectionDetailsProvider =
    FutureProvider.family<HadithCollectionDetailsResponseDto?, int>(
  (ref, collectionId) async {
    final repo = ref.watch(hadithRepositoryProvider);
    return repo.fetchHadithCollectionDetails(collectionId);
  },
);
