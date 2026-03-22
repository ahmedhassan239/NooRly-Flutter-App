/// Saved items API: list by type (with pagination), save, unsave.
/// Backend routes: GET /saved?type=..., POST /saved/{type}/{id}, DELETE /saved/{type}/{id}
/// Supported types: 'dua', 'hadith', 'verse', 'lesson', 'adhkar'
library;

import 'package:dio/dio.dart';
import 'package:flutter_app/core/content/library_reference_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool get _debugSavedApi => kDebugMode;
const int _logBodyChars = 300;

void _log(String msg) {
  if (_debugSavedApi) debugPrint('[SavedApi] $msg');
}

String _truncate(dynamic body, [int maxLen = 300]) {
  final s = body is String ? body : body.toString();
  return s.length <= maxLen ? s : '${s.substring(0, maxLen)}...';
}

// =============================================================================
// Models
// =============================================================================

/// Generic saved item (for list endpoints that return item_id only).
class SavedItem {
  const SavedItem({
    required this.id,
    required this.itemType,
    required this.itemId,
    this.createdAt,
  });
  final int id;
  final String itemType;
  final String itemId;
  final DateTime? createdAt;

  static SavedItem? fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final itemType = json['item_type'] as String?;
    final itemId = json['item_id']?.toString();
    if (id == null || itemId == null) return null;
    DateTime? createdAt;
    if (json['created_at'] != null) {
      try {
        createdAt = DateTime.tryParse(json['created_at'] as String);
      } catch (_) {}
    }
    return SavedItem(
      id: (id is num) ? id.toInt() : id as int,
      itemType: itemType ?? 'hadith',
      itemId: itemId,
      createdAt: createdAt,
    );
  }
}

/// Full hadith item as returned by GET /saved?type=hadith (hydrated).
class SavedHadithItem {
  const SavedHadithItem({
    required this.id,
    this.collection,
    this.collectionName,
    this.collectionNameAr,
    this.hadithNumber,
    this.chapterNumber,
    this.textAr,
    this.textEn,
    this.text,
    this.isSaved = true,
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
  final bool isSaved;

  static SavedHadithItem fromJson(Map<String, dynamic> json) {
    final rawId = json['item_id'] ?? json['id'];
    final int contentId = rawId is num
        ? rawId.toInt()
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    return SavedHadithItem(
      id: contentId,
      collection: json['collection'] as String?,
      collectionName: json['collection_name'] as String?,
      collectionNameAr: json['collection_name_ar'] as String?,
      hadithNumber: json['hadith_number'],
      chapterNumber: json['chapter_number'],
      textAr: json['text_ar'] as String?,
      textEn: json['text_en'] as String?,
      text: json['text'] as String?,
      isSaved: json['is_saved'] as bool? ?? true,
    );
  }
}

/// Result of fetchSavedHadith (items + total + meta).
class SavedHadithListResult {
  const SavedHadithListResult({
    required this.items,
    required this.total,
    this.currentPage = 1,
    this.perPage = 20,
    this.hasMore = false,
  });
  final List<SavedHadithItem> items;
  final int total;
  final int currentPage;
  final int perPage;
  final bool hasMore;
}

/// Full verse item as returned by GET /saved?type=verse (hydrated).
class SavedVerseItem {
  const SavedVerseItem({
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
    this.isSaved = true,
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
  final bool isSaved;

  String referenceDisplay(String languageCode) {
    return formatLibraryVerseReference(
      languageCode: languageCode,
      apiReference: reference,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      surahNameEn: surahNameEn,
      surahNameAr: surahNameAr,
    );
  }

  static SavedVerseItem fromJson(Map<String, dynamic> json) {
    final rawId = json['item_id'] ?? json['id'];
    final int contentId = rawId is num
        ? rawId.toInt()
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    return SavedVerseItem(
      id: contentId,
      surahNumber: (json['surah_number'] as num?)?.toInt(),
      ayahNumber: (json['ayah_number'] as num?)?.toInt(),
      ayahKey: json['ayah_key'] as String?,
      reference: json['reference'] as String?,
      surahNameEn: json['surah_name_en'] as String?,
      surahNameAr: json['surah_name_ar'] as String?,
      textAr: json['text_ar'] as String?,
      textEn: json['text_en'] as String?,
      text: json['text'] as String?,
      isSaved: json['is_saved'] as bool? ?? true,
    );
  }
}

/// Result of fetchSavedVerses (items + total + meta).
class SavedVerseListResult {
  const SavedVerseListResult({
    required this.items,
    required this.total,
    this.currentPage = 1,
    this.perPage = 20,
    this.hasMore = false,
  });
  final List<SavedVerseItem> items;
  final int total;
  final int currentPage;
  final int perPage;
  final bool hasMore;
}

/// Full adhkar item as returned by GET /saved?type=adhkar (hydrated).
class SavedAdhkarItem {
  const SavedAdhkarItem({
    required this.id,
    this.title,
    this.text,
    this.textAr,
    this.count,
    this.reward,
    this.source,
    this.audioUrl,
    this.categoryKey,
    this.category,
    this.isSaved = true,
  });
  final int id;
  final String? title;
  final String? text;
  final String? textAr;
  final int? count;
  final String? reward;
  final String? source;
  final String? audioUrl;
  final String? categoryKey;
  final Map<String, dynamic>? category;
  final bool isSaved;

  static SavedAdhkarItem fromJson(Map<String, dynamic> json) {
    final content = json['content'] is Map<String, dynamic>
        ? json['content'] as Map<String, dynamic>
        : null;
    final textMap = content?['text'] is Map ? content!['text'] as Map : null;
    final rewardMap = content?['reward'] is Map ? content!['reward'] as Map : null;

    String? text;
    String? textAr;
    String? reward;
    int? count;
    if (textMap != null) {
      textAr = (textMap['ar'] ?? '').toString().isNotEmpty
          ? (textMap['ar'] ?? '').toString()
          : null;
      text = (textMap['en'] ?? '').toString().isNotEmpty
          ? (textMap['en'] ?? '').toString()
          : textAr;
      reward = rewardMap != null
          ? ((rewardMap['en'] ?? rewardMap['ar'] ?? '').toString().isNotEmpty
              ? (rewardMap['en'] ?? rewardMap['ar'] ?? '').toString()
              : null)
          : null;
      count = (json['repeat_count'] as num?)?.toInt() ??
          (json['count'] as num?)?.toInt();
    } else {
      text = json['text'] as String? ?? json['english_text'] as String?;
      textAr = json['text_ar'] as String? ?? json['arabic_text'] as String?;
      reward = json['reward'] is String
          ? json['reward'] as String?
          : (json['reward'] is Map
              ? ((json['reward'] as Map)['en'] ?? (json['reward'] as Map)['ar'])?.toString()
              : null);
      count = (json['count'] as num?)?.toInt() ?? (json['repeat_count'] as num?)?.toInt();
    }

    final rawId = json['item_id'] ?? json['id'];
    final int contentId = rawId is num
        ? rawId.toInt()
        : int.tryParse(rawId?.toString() ?? '') ?? 0;

    return SavedAdhkarItem(
      id: contentId,
      title: json['title'] as String?,
      text: text,
      textAr: textAr,
      count: count,
      reward: reward,
      source: (json['source'] as String?) ?? '',
      audioUrl: json['audio_url'] as String?,
      categoryKey: json['category_key'] as String?,
      category: json['category'] is Map<String, dynamic>
          ? json['category'] as Map<String, dynamic>
          : null,
      isSaved: json['is_saved'] as bool? ?? true,
    );
  }
}

/// Result of fetchSavedAdhkar (items + total + meta).
class SavedAdhkarListResult {
  const SavedAdhkarListResult({
    required this.items,
    required this.total,
    this.currentPage = 1,
    this.perPage = 20,
    this.hasMore = false,
  });
  final List<SavedAdhkarItem> items;
  final int total;
  final int currentPage;
  final int perPage;
  final bool hasMore;
}

/// Full dua item as returned by GET /saved?type=dua (hydrated).
class SavedDuaItem {
  const SavedDuaItem({
    required this.id,
    this.title,
    this.titleAr,
    this.text,
    this.textAr,
    this.transliteration,
    this.source,
    this.sourceAr,
    this.categoryId,
    this.categoryName,
    this.isSaved = true,
  });
  final int id;
  final String? title;
  final String? titleAr;
  final String? text;
  final String? textAr;
  final String? transliteration;
  final String? source;
  final String? sourceAr;
  final int? categoryId;
  final String? categoryName;
  final bool isSaved;

  static SavedDuaItem fromJson(Map<String, dynamic> json) {
    final rawId = json['item_id'] ?? json['id'];
    final int contentId = rawId is num
        ? rawId.toInt()
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    final String? titleRaw = json['title'] as String? ?? json['title_en'] as String?;
    final String? textEn = json['text'] as String? ?? json['text_en'] as String?;
    final String? textAr = json['text_ar'] as String?;
    final String? title = (titleRaw != null && titleRaw.isNotEmpty)
        ? titleRaw
        : _preview(textEn ?? textAr, 40);
    return SavedDuaItem(
      id: contentId,
      title: title,
      titleAr: json['title_ar'] as String?,
      text: textEn,
      textAr: textAr,
      transliteration: json['transliteration'] as String?,
      source: json['source'] as String?,
      sourceAr: json['source_ar'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
      categoryName: json['category_name'] as String?,
      isSaved: json['is_saved'] as bool? ?? true,
    );
  }

  static String? _preview(String? s, int maxLen) {
    if (s == null || s.isEmpty) return null;
    final t = s.trim();
    if (t.length <= maxLen) return t;
    return '${t.substring(0, maxLen)}…';
  }
}

/// Result of fetchSavedDuas (items + total + meta).
class SavedDuaListResult {
  const SavedDuaListResult({
    required this.items,
    required this.total,
    this.currentPage = 1,
    this.perPage = 20,
    this.hasMore = false,
  });
  final List<SavedDuaItem> items;
  final int total;
  final int currentPage;
  final int perPage;
  final bool hasMore;
}

/// Full lesson item as returned by GET /saved?type=lesson (hydrated).
class SavedLessonItem {
  const SavedLessonItem({
    required this.id,
    this.title,
    this.titleAr,
    this.description,
    this.descriptionAr,
    this.weekNumber,
    this.dayNumber,
    this.contentType,
    this.thumbnailUrl,
    this.isSaved = true,
  });
  final int id;
  final String? title;
  final String? titleAr;
  final String? description;
  final String? descriptionAr;
  final int? weekNumber;
  final int? dayNumber;
  final String? contentType;
  final String? thumbnailUrl;
  final bool isSaved;

  static SavedLessonItem fromJson(Map<String, dynamic> json) {
    final rawId = json['item_id'] ?? json['id'];
    final int contentId = rawId is num
        ? rawId.toInt()
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    return SavedLessonItem(
      id: contentId,
      title: json['title'] as String? ?? json['title_en'] as String?,
      titleAr: json['title_ar'] as String?,
      description: json['description'] as String? ?? json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      weekNumber: (json['week_number'] as num?)?.toInt(),
      dayNumber: (json['day_number'] as num?)?.toInt(),
      contentType: json['content_type'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      isSaved: json['is_saved'] as bool? ?? true,
    );
  }
}

/// Result of fetchSavedLessons (items + total + meta).
class SavedLessonListResult {
  const SavedLessonListResult({
    required this.items,
    required this.total,
    this.currentPage = 1,
    this.perPage = 20,
    this.hasMore = false,
  });
  final List<SavedLessonItem> items;
  final int total;
  final int currentPage;
  final int perPage;
  final bool hasMore;
}

/// Unified saved item from GET /saved?type=all (all types in one shape).
class UnifiedSavedItem {
  const UnifiedSavedItem({
    required this.id,
    required this.type,
    required this.title,
    this.arabic,
    this.translation,
    this.source,
    required this.referenceId,
  });
  final int id;
  final String type;
  final String title;
  final String? arabic;
  final String? translation;
  final String? source;
  final dynamic referenceId;

  static UnifiedSavedItem fromJson(Map<String, dynamic> json) {
    final refId = json['reference_id'];
    return UnifiedSavedItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'dua',
      title: json['title'] as String? ?? '',
      arabic: json['arabic'] as String?,
      translation: json['translation'] as String?,
      source: json['source'] as String?,
      referenceId: refId is num ? refId.toInt() : refId?.toString(),
    );
  }

  String get snippet {
    final t = translation ?? arabic ?? '';
    if (t.length <= 80) return t;
    return '${t.substring(0, 80)}…';
  }
}

/// Result of fetchSavedAll (unified list + pagination).
class SavedAllListResult {
  const SavedAllListResult({
    required this.items,
    required this.pagination,
  });
  final List<UnifiedSavedItem> items;
  final SavedAllPagination pagination;
}

class SavedAllPagination {
  const SavedAllPagination({
    this.page = 1,
    this.perPage = 20,
    this.total = 0,
    this.hasMore = false,
  });
  final int page;
  final int perPage;
  final int total;
  final bool hasMore;

  static SavedAllPagination fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SavedAllPagination();
    return SavedAllPagination(
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

// =============================================================================
// Response helpers (support both legacy wrapper and Laravel pagination)
// =============================================================================

Map<String, dynamic>? _metaFromResponse(dynamic body) {
  if (body is Map<String, dynamic>) {
    final meta = body['meta'];
    if (meta is Map<String, dynamic>) return meta;
  }
  return null;
}

List<dynamic> _extractItems(dynamic body) {
  if (body == null) return const [];
  if (body is List) return body;

  if (body is! Map<String, dynamic>) return const [];

  final data = body['data'];

  if (data is List) return data;

  if (data is Map<String, dynamic>) {
    final items = data['items'];
    if (items is List) return items;
    final inner = data['data'];
    if (inner is List) return inner;
  }

  final topItems = body['items'];
  if (topItems is List) return topItems;

  return const [];
}

int _extractTotal(dynamic body, {int fallback = 0}) {
  if (body is! Map<String, dynamic>) return fallback;

  final meta = _metaFromResponse(body);
  final totalFromMeta = meta?['total'];
  if (totalFromMeta is num) return totalFromMeta.toInt();

  final data = body['data'];
  if (data is Map<String, dynamic>) {
    final total = data['total'];
    if (total is num) return total.toInt();
  }
  return fallback;
}

int _extractCurrentPage(dynamic body, {required int fallback}) {
  final meta = _metaFromResponse(body);
  final cp = meta?['current_page'];
  if (cp is num) return cp.toInt();
  return fallback;
}

int _extractLastPage(dynamic body, {required int fallback}) {
  final meta = _metaFromResponse(body);
  final lp = meta?['last_page'];
  if (lp is num) return lp.toInt();
  return fallback;
}

int _extractPerPage(dynamic body, {required int fallback}) {
  final meta = _metaFromResponse(body);
  final pp = meta?['per_page'];
  if (pp is num) return pp.toInt();
  return fallback;
}

bool _extractHasMore(
  dynamic body, {
  required int currentPage,
  required int lastPage,
  required int total,
  required int perPage,
}) {
  final meta = _metaFromResponse(body);
  final hm = meta?['has_more'];
  if (hm is bool) return hm;

  if (lastPage > 0) return currentPage < lastPage;

  return currentPage * perPage < total;
}

// =============================================================================
// Fetchers
// =============================================================================

/// GET /saved?type=all — unified list of all saved items (paginated).
Future<SavedAllListResult> fetchSavedAll({
  required Ref ref,
  int page = 1,
  int perPage = 20,
}) async {
  final client = ref.read(apiClientProvider);
  final url = SavedEndpoints.list;
  final query = {'type': 'all', 'page': page, 'per_page': perPage};
  _log('GET $url query=$query');

  final res = await client.dio.get<dynamic>(url, queryParameters: query);
  final raw = res.data;
  _log('GET $url status=${res.statusCode} body=${_truncate(raw, _logBodyChars)}');

  if (raw is! Map<String, dynamic>) {
    return const SavedAllListResult(items: [], pagination: SavedAllPagination());
  }
  final data = raw['data'];
  if (data is! Map<String, dynamic>) {
    return const SavedAllListResult(items: [], pagination: SavedAllPagination());
  }
  final itemsList = data['items'] as List<dynamic>? ?? [];
  final paginationMap = data['pagination'] as Map<String, dynamic>?;
  final list = itemsList
      .whereType<Map<String, dynamic>>()
      .map((e) => UnifiedSavedItem.fromJson(e))
      .toList();
  final pagination = SavedAllPagination.fromJson(paginationMap);
  _log('GET all parsed items=${list.length} total=${pagination.total}');
  return SavedAllListResult(items: list, pagination: pagination);
}

/// GET /saved?type=hadith — paginated hydrated hadith list.
Future<SavedHadithListResult> fetchSavedHadith({
  required Ref ref,
  int page = 1,
  int perPage = 100,
}) async {
  final client = ref.read(apiClientProvider);
  final url = SavedEndpoints.list;
  final query = {'type': 'hadith', 'page': page, 'per_page': perPage};
  _log('GET $url query=$query');

  final res = await client.dio.get<dynamic>(url, queryParameters: query);

  final raw = res.data;
  _log('GET $url status=${res.statusCode} query=$query body=${_truncate(raw, _logBodyChars)}');

  final items = _extractItems(raw);
  final total = _extractTotal(raw, fallback: items.length);

  final currentPage = _extractCurrentPage(raw, fallback: page);
  final perPageActual = _extractPerPage(raw, fallback: perPage);
  final lastPage = _extractLastPage(raw, fallback: currentPage);

  final hasMore = _extractHasMore(
    raw,
    currentPage: currentPage,
    lastPage: lastPage,
    total: total,
    perPage: perPageActual,
  );

  final list = items
      .whereType<Map<String, dynamic>>()
      .map((e) => SavedHadithItem.fromJson(e))
      .toList();
  _log('GET hadith parsed items=${list.length} total=$total hasMore=$hasMore');

  return SavedHadithListResult(
    items: list,
    total: total,
    currentPage: currentPage,
    perPage: perPageActual,
    hasMore: hasMore,
  );
}

/// GET /saved?type=verse — paginated hydrated verse list.
Future<SavedVerseListResult> fetchSavedVerses({
  required Ref ref,
  int page = 1,
  int perPage = 100,
}) async {
  final client = ref.read(apiClientProvider);
  final url = SavedEndpoints.list;
  final query = {'type': 'verse', 'page': page, 'per_page': perPage};
  _log('GET $url query=$query');

  final res = await client.dio.get<dynamic>(url, queryParameters: query);

  final raw = res.data;
  _log('GET $url status=${res.statusCode} query=$query body=${_truncate(raw, _logBodyChars)}');

  final items = _extractItems(raw);
  final total = _extractTotal(raw, fallback: items.length);

  final currentPage = _extractCurrentPage(raw, fallback: page);
  final perPageActual = _extractPerPage(raw, fallback: perPage);
  final lastPage = _extractLastPage(raw, fallback: currentPage);

  final hasMore = _extractHasMore(
    raw,
    currentPage: currentPage,
    lastPage: lastPage,
    total: total,
    perPage: perPageActual,
  );

  final list = items
      .whereType<Map<String, dynamic>>()
      .map((e) => SavedVerseItem.fromJson(e))
      .toList();
  _log('GET verse parsed items=${list.length} total=$total hasMore=$hasMore');

  return SavedVerseListResult(
    items: list,
    total: total,
    currentPage: currentPage,
    perPage: perPageActual,
    hasMore: hasMore,
  );
}

/// GET /saved?type=adhkar — paginated hydrated saved adhkar list.
Future<SavedAdhkarListResult> fetchSavedAdhkar({
  required Ref ref,
  int page = 1,
  int perPage = 100,
}) async {
  final client = ref.read(apiClientProvider);
  final url = SavedEndpoints.list;
  final query = {'type': 'adhkar', 'page': page, 'per_page': perPage};
  _log('GET $url query=$query');

  final res = await client.dio.get<dynamic>(url, queryParameters: query);

  final raw = res.data;
  _log('GET $url status=${res.statusCode} query=$query body=${_truncate(raw, _logBodyChars)}');

  final items = _extractItems(raw);
  final total = _extractTotal(raw, fallback: items.length);

  final currentPage = _extractCurrentPage(raw, fallback: page);
  final perPageActual = _extractPerPage(raw, fallback: perPage);
  final lastPage = _extractLastPage(raw, fallback: currentPage);

  final hasMore = _extractHasMore(
    raw,
    currentPage: currentPage,
    lastPage: lastPage,
    total: total,
    perPage: perPageActual,
  );

  final list = items
      .whereType<Map<String, dynamic>>()
      .map((e) => SavedAdhkarItem.fromJson(e))
      .toList();
  _log('GET adhkar parsed items=${list.length} total=$total hasMore=$hasMore');

  return SavedAdhkarListResult(
    items: list,
    total: total,
    currentPage: currentPage,
    perPage: perPageActual,
    hasMore: hasMore,
  );
}

/// GET /saved?type=dua — paginated hydrated saved dua list.
Future<SavedDuaListResult> fetchSavedDuas({
  required Ref ref,
  int page = 1,
  int perPage = 100,
}) async {
  final client = ref.read(apiClientProvider);
  final url = SavedEndpoints.list;
  final query = {'type': 'dua', 'page': page, 'per_page': perPage};
  _log('GET $url query=$query');

  final res = await client.dio.get<dynamic>(url, queryParameters: query);

  final raw = res.data;
  _log('GET $url status=${res.statusCode} query=$query body=${_truncate(raw, _logBodyChars)}');

  final items = _extractItems(raw);
  final total = _extractTotal(raw, fallback: items.length);

  final currentPage = _extractCurrentPage(raw, fallback: page);
  final perPageActual = _extractPerPage(raw, fallback: perPage);
  final lastPage = _extractLastPage(raw, fallback: currentPage);

  final hasMore = _extractHasMore(
    raw,
    currentPage: currentPage,
    lastPage: lastPage,
    total: total,
    perPage: perPageActual,
  );

  final list = items
      .whereType<Map<String, dynamic>>()
      .map((e) => SavedDuaItem.fromJson(e))
      .toList();
  _log('GET dua parsed items=${list.length} total=$total hasMore=$hasMore');

  return SavedDuaListResult(
    items: list,
    total: total,
    currentPage: currentPage,
    perPage: perPageActual,
    hasMore: hasMore,
  );
}

/// GET /saved?type=lesson — paginated hydrated saved lesson list.
Future<SavedLessonListResult> fetchSavedLessons({
  required Ref ref,
  int page = 1,
  int perPage = 100,
}) async {
  final client = ref.read(apiClientProvider);
  final url = SavedEndpoints.list;
  final query = {'type': 'lesson', 'page': page, 'per_page': perPage};
  _log('GET $url query=$query');

  final res = await client.dio.get<dynamic>(url, queryParameters: query);

  final raw = res.data;
  _log('GET $url status=${res.statusCode} query=$query body=${_truncate(raw, _logBodyChars)}');

  final items = _extractItems(raw);
  final total = _extractTotal(raw, fallback: items.length);

  final currentPage = _extractCurrentPage(raw, fallback: page);
  final perPageActual = _extractPerPage(raw, fallback: perPage);
  final lastPage = _extractLastPage(raw, fallback: currentPage);

  final hasMore = _extractHasMore(
    raw,
    currentPage: currentPage,
    lastPage: lastPage,
    total: total,
    perPage: perPageActual,
  );

  final list = items
      .whereType<Map<String, dynamic>>()
      .map((e) => SavedLessonItem.fromJson(e))
      .toList();
  _log('GET lesson parsed items=${list.length} total=$total hasMore=$hasMore');

  return SavedLessonListResult(
    items: list,
    total: total,
    currentPage: currentPage,
    perPage: perPageActual,
    hasMore: hasMore,
  );
}

/// POST /saved/{type}/{itemId} — save item.
Future<void> saveItem({
  required Ref ref,
  required String type,
  required String itemId,
}) async {
  final client = ref.read(apiClientProvider);
  final url = SavedEndpoints.save(type, itemId);
  _log('POST $url');

  try {
    final res = await client.dio.post<dynamic>(url);
    _log('POST $url status=${res.statusCode} body=${_truncate(res.data, _logBodyChars)}');
  } on DioException catch (e) {
    final status = e.response?.statusCode;
    final body = e.response?.data;
    _log('POST $url FAILED status=$status body=${_truncate(body, _logBodyChars)}');
    rethrow;
  }
}

/// DELETE /saved/{type}/{itemId} — unsave item.
Future<void> unsaveItem({
  required Ref ref,
  required String type,
  required String itemId,
}) async {
  final client = ref.read(apiClientProvider);
  final url = SavedEndpoints.unsave(type, itemId);
  _log('DELETE $url');

  try {
    final res = await client.dio.delete<dynamic>(url);
    _log('DELETE $url status=${res.statusCode} body=${_truncate(res.data, _logBodyChars)}');
  } on DioException catch (e) {
    final status = e.response?.statusCode;
    final body = e.response?.data;
    _log('DELETE $url FAILED status=$status body=${_truncate(body, _logBodyChars)}');
    rethrow;
  }
}
