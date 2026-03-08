/// Content scopes provider (Library tabs: Duas, Hadith, Verses, Adhkar).
library;

import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/content/data/models/content_scope_model.dart';
import 'package:flutter_app/core/content/domain/entities/content_scope_entity.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Active content scopes from API. Used for Library tabs.
/// Order and label from API. Icon uses shared icon system (scope-key fallback when API does not send icon).
/// On API failure or empty response, returns empty list (no fallback tabs).
final contentScopesProvider =
    FutureProvider<List<ContentScopeEntity>>((ref) async {
  final client = ref.watch(apiClientProvider);
  try {
    final response =
        await client.dio.get<dynamic>(ContentScopeEndpoints.libraryTabs);
    final body = response.data;
    if (body == null) return <ContentScopeEntity>[];
    List<dynamic> list;
    if (body is List) {
      list = body;
    } else if (body is Map<String, dynamic>) {
      final raw = body['data'];
      list = raw is List ? raw : (body['scopes'] as List? ?? <dynamic>[]);
    } else {
      return <ContentScopeEntity>[];
    }
    if (list.isEmpty) return <ContentScopeEntity>[];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => ContentScopeModel.fromJson(e).toEntity())
        .toList();
  } catch (_) {
    return <ContentScopeEntity>[];
  }
});
