/// Provider for adhkar list by admin category ID (Library scope=Adhkar).
library;

import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/content/data/models/content_model.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches adhkar for a category from GET /adhkar/by-category/:id.
/// Use for Library > Adhkar > category detail page.
final adhkarByCategoryIdProvider =
    FutureProvider.family<List<DhikrEntity>, String>((ref, categoryId) async {
  final id = int.tryParse(categoryId);
  if (id == null) return [];
  final client = ref.read(apiClientProvider);
  final res = await client.dio.get<dynamic>(AdhkarEndpoints.byCategoryId(id));
  final data = res.data;
  if (data is! Map<String, dynamic>) return [];
  final list = data['data'];
  if (list is! List) return [];
  return list
      .whereType<Map<String, dynamic>>()
      .map((e) => DhikrModel.fromJson(e) as DhikrEntity)
      .toList();
});
