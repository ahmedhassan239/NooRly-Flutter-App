/// Help Now API - fetches categories with items and single item (locale via Accept-Language).
library;

import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/help_now/data/help_now_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches all help categories with nested items.
Future<List<HelpCategoryModel>> fetchHelpNowCategories(Ref ref) async {
  final client = ref.read(apiClientProvider);
  // Use dynamic so the List from json['data'] is not incorrectly cast to Map
  final response = await client.get<dynamic>(HelpNowEndpoints.list);
  if (!response.status || response.data == null) {
    return [];
  }
  // response.data is already json['data'] (the List) from ApiResponse.fromJson
  final list = response.data as List?;
  if (list == null) return [];
  return list
      .map((e) => HelpCategoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
}

/// Fetches a single help item by slug.
Future<HelpItemModel?> fetchHelpNowItem(Ref ref, String slug) async {
  final client = ref.read(apiClientProvider);
  // Single item response: json['data'] is a Map — use Map type
  final response = await client.get<Map<String, dynamic>>(
    HelpNowEndpoints.item(slug),
  );
  if (!response.status || response.data == null) return null;
  return HelpItemModel.fromJson(response.data!);
}
