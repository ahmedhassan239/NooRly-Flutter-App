/// Library Hadith API (categories → collections → hadiths). No mock data.
library;

import 'package:flutter/foundation.dart';

import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryHadithCategory {
  const LibraryHadithCategory({
    required this.id,
    required this.name,
    this.slug,
    this.description,
  });
  final int id;
  final String name;
  final String? slug;
  final String? description;

  static LibraryHadithCategory fromJson(Map<String, dynamic> json) {
    return LibraryHadithCategory(
      id: (json['id'] as num).toInt(),
      name: (json['title'] ?? json['name'] ?? '') as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
    );
  }
}

class LibraryHadithCollectionItem {
  const LibraryHadithCollectionItem({
    required this.id,
    required this.title,
    this.slug,
    this.displayOrder,
    this.itemsCount,
    this.icon,
    this.iconUrl,
  });
  final int id;
  final String title;
  final String? slug;
  final int? displayOrder;
  final int? itemsCount;
  final String? icon;
  final String? iconUrl;

  static LibraryHadithCollectionItem fromJson(Map<String, dynamic> json) {
    return LibraryHadithCollectionItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt(),
      itemsCount: (json['items_count'] as num?)?.toInt(),
      icon: json['icon'] as String?,
      iconUrl: json['icon_url'] as String? ?? json['iconUrl'] as String?,
    );
  }
}

class LibraryHadithItem {
  const LibraryHadithItem({
    required this.id,
    this.collection,
    this.collectionName,
    this.collectionNameAr,
    this.hadithNumber,
    this.chapterNumber,
    this.textAr,
    this.textEn,
    this.text,
  });
  final int id;
  final String? collection;
  final String? collectionName;
  final String? collectionNameAr;
  final dynamic hadithNumber;
  final dynamic chapterNumber;
  final String? textAr;
  final String? textEn;
  final String? text;

  static LibraryHadithItem fromJson(Map<String, dynamic> json) {
    return LibraryHadithItem(
      id: (json['id'] as num).toInt(),
      collection: json['collection'] as String?,
      collectionName: json['collection_name'] as String?,
      collectionNameAr: json['collection_name_ar'] as String?,
      hadithNumber: json['hadith_number'],
      chapterNumber: json['chapter_number'],
      textAr: json['text_ar'] as String?,
      textEn: json['text_en'] as String?,
      text: json['text'] as String?,
    );
  }
}

/// Fetches all hadith collections from GET /api/v1/library/hadith/collections (no categories).
/// Response is wrapped: { status, message, data }; we parse data only.
/// Kept alive so tab switch preserves data.
final libraryHadithCollectionsAllProvider =
    FutureProvider<List<LibraryHadithCollectionItem>>((ref) async {
  ref.keepAlive();
  final client = ref.watch(apiClientProvider);
  final path = LibraryHadithEndpoints.collectionsAll;
  final url = '${ApiConfig.baseUrl}$path';
  if (kDebugMode) {
    debugPrint('[LibraryHadithApi] GET $url');
  }
  final res = await client.dio.get<dynamic>(path);
  if (kDebugMode) {
    debugPrint(
      '[LibraryHadithApi] GET $url -> statusCode: ${res.statusCode}, '
      'body: ${res.data}',
    );
  }
  final data = _dataFromResponse(res.data);
  final list = data as List<dynamic>? ?? [];
  return list
      .whereType<Map<String, dynamic>>()
      .map((e) => LibraryHadithCollectionItem.fromJson(e))
      .toList();
});

/// Fetches hadith collections for a category from GET /library/hadith/categories/{id}/collections.
/// Legacy Hadith hub uses this; Library Hadith tab uses hadithCollectionsByCategoryProvider.
final libraryHadithCollectionsProvider =
    FutureProvider.family<List<LibraryHadithCollectionItem>, int>((ref, id) async {
  final client = ref.watch(apiClientProvider);
  final res = await client.dio.get<dynamic>(LibraryHadithEndpoints.collectionsByCategory(id));
  final data = _dataFromResponse(res.data);
  final list = data as List<dynamic>? ?? [];
  return list
      .whereType<Map<String, dynamic>>()
      .map((e) => LibraryHadithCollectionItem.fromJson(e))
      .toList();
});

class LibraryHadithCollectionDetail {
  const LibraryHadithCollectionDetail({
    required this.collection,
    required this.hadiths,
  });
  final LibraryHadithCollectionItem collection;
  final List<LibraryHadithItem> hadiths;
}

final libraryHadithCollectionDetailProvider =
    FutureProvider.family<LibraryHadithCollectionDetail?, int>((ref, id) async {
  final client = ref.watch(apiClientProvider);
  final res = await client.dio.get<dynamic>(LibraryHadithEndpoints.collection(id));
  final data = _dataFromResponse(res.data);
  if (data is! Map<String, dynamic>) return null;
  final coll = data['collection'] as Map<String, dynamic>?;
  final list = data['hadiths'] as List<dynamic>? ?? [];
  if (coll == null) return null;
  return LibraryHadithCollectionDetail(
    collection: LibraryHadithCollectionItem.fromJson(coll),
    hadiths: list
        .whereType<Map<String, dynamic>>()
        .map((e) => LibraryHadithItem.fromJson(e))
        .toList(),
  );
});

dynamic _dataFromResponse(dynamic body) {
  if (body == null) return null;
  if (body is Map<String, dynamic> && body.containsKey('data')) {
    return body['data'];
  }
  return body;
}
