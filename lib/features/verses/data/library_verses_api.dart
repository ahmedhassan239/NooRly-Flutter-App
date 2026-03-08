/// Library Verses API (categories → collections → verses). No mock data.
library;

import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryVerseCategory {
  const LibraryVerseCategory({
    required this.id,
    required this.name,
    this.slug,
    this.description,
  });
  final int id;
  final String name;
  final String? slug;
  final String? description;

  static LibraryVerseCategory fromJson(Map<String, dynamic> json) {
    return LibraryVerseCategory(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String?,
      description: json['description'] as String?,
    );
  }
}

class LibraryVerseCollectionItem {
  const LibraryVerseCollectionItem({
    required this.id,
    required this.title,
    this.slug,
    this.displayOrder,
    this.itemsCount,
    this.icon,
  });
  final int id;
  final String title;
  final String? slug;
  final int? displayOrder;
  final int? itemsCount;
  final String? icon;

  static LibraryVerseCollectionItem fromJson(Map<String, dynamic> json) {
    return LibraryVerseCollectionItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt(),
      itemsCount: (json['items_count'] as num?)?.toInt(),
      icon: json['icon'] as String?,
    );
  }
}

class LibraryVerseItem {
  const LibraryVerseItem({
    required this.id,
    this.surahNumber,
    this.ayahNumber,
    this.ayahKey,
    this.reference,
    this.surahNameEn,
    this.surahNameAr,
    this.textAr,
    this.textEn,
    this.text,
  });
  final int id;
  final int? surahNumber;
  final int? ayahNumber;
  final String? ayahKey;
  final String? reference;
  final String? surahNameEn;
  final String? surahNameAr;
  final String? textAr;
  final String? textEn;
  final String? text;

  /// Formatted reference: "An-Nisa (النساء) 83" (en) or "سورة النساء (An-Nisa) 83" (ar). Ayah number only.
  String referenceDisplay(bool isArabic) {
    final an = ayahNumber;
    if (an == null) return reference ?? '';
    final en = surahNameEn ?? '';
    final ar = surahNameAr ?? '';
    if (isArabic) {
      return 'سورة $ar ($en) $an';
    }
    return '$en ($ar) $an';
  }

  static LibraryVerseItem fromJson(Map<String, dynamic> json) {
    return LibraryVerseItem(
      id: (json['id'] as num).toInt(),
      surahNumber: (json['surah_number'] as num?)?.toInt(),
      ayahNumber: (json['ayah_number'] as num?)?.toInt(),
      ayahKey: json['ayah_key'] as String?,
      reference: json['reference'] as String?,
      surahNameEn: json['surah_name_en'] as String?,
      surahNameAr: json['surah_name_ar'] as String?,
      textAr: json['text_ar'] as String?,
      textEn: json['text_en'] as String?,
      text: json['text'] as String?,
    );
  }
}

final libraryVersesCategoriesProvider =
    FutureProvider<List<LibraryVerseCategory>>((ref) async {
  ref.keepAlive();
  final client = ref.watch(apiClientProvider);
  final res = await client.dio.get<dynamic>(LibraryVersesEndpoints.categories);
  final data = _dataFromResponse(res.data);
  final list = data as List<dynamic>? ?? [];
  return list
      .whereType<Map<String, dynamic>>()
      .map((e) => LibraryVerseCategory.fromJson(e))
      .toList();
});

/// All verse collections from GET /library/verses/collections (no category). Kept alive for tab switch.
final verseCollectionsAllProvider =
    FutureProvider<List<LibraryVerseCollectionItem>>((ref) async {
  ref.keepAlive();
  final client = ref.watch(apiClientProvider);
  final res = await client.dio.get<dynamic>(LibraryVersesEndpoints.collectionsAll);
  final data = _dataFromResponse(res.data);
  final list = data as List<dynamic>? ?? [];
  return list
      .whereType<Map<String, dynamic>>()
      .map((e) => LibraryVerseCollectionItem.fromJson(e))
      .toList();
});

final libraryVersesCollectionsProvider =
    FutureProvider.family<List<LibraryVerseCollectionItem>, int>((ref, id) async {
  final client = ref.watch(apiClientProvider);
  final res = await client.dio
      .get<dynamic>(LibraryVersesEndpoints.collectionsByCategory(id));
  final data = _dataFromResponse(res.data);
  final list = data as List<dynamic>? ?? [];
  return list
      .whereType<Map<String, dynamic>>()
      .map((e) => LibraryVerseCollectionItem.fromJson(e))
      .toList();
});

class LibraryVerseCollectionDetail {
  const LibraryVerseCollectionDetail({
    required this.collection,
    required this.verses,
  });
  final LibraryVerseCollectionItem collection;
  final List<LibraryVerseItem> verses;
}

final libraryVerseCollectionDetailProvider =
    FutureProvider.family<LibraryVerseCollectionDetail?, int>((ref, id) async {
  final client = ref.watch(apiClientProvider);
  final res = await client.dio.get<dynamic>(LibraryVersesEndpoints.collection(id));
  final data = _dataFromResponse(res.data);
  if (data is! Map<String, dynamic>) return null;
  final coll = data['collection'] as Map<String, dynamic>?;
  final list = data['verses'] as List<dynamic>? ?? [];
  if (coll == null) return null;
  return LibraryVerseCollectionDetail(
    collection: LibraryVerseCollectionItem.fromJson(coll),
    verses: list
        .whereType<Map<String, dynamic>>()
        .map((e) => LibraryVerseItem.fromJson(e))
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
