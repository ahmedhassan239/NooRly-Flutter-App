/// Ramadan Guide API - fetches list and single item (locale via Accept-Language).
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/ramadan_guide/data/ramadan_guide_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches Ramadan guide list from API.
Future<List<RamadanGuideItemModel>> fetchRamadanGuideList(Ref ref) async {
  final client = ref.read(apiClientProvider);
  final path = RamadanGuideEndpoints.list;
  if (kDebugMode) {
    debugPrint('[RamadanGuide] GET ${client.baseUrl}$path');
  }
  // Use dynamic so the List from json['data'] is not incorrectly cast to Map
  final response = await client.get<dynamic>(path);
  if (!response.status || response.data == null) {
    return [];
  }
  // response.data is already json['data'] (the List) from ApiResponse.fromJson
  final list = response.data as List?;
  if (list == null) return [];
  return list
      .map((e) => RamadanGuideItemModel.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Fetches a single Ramadan guide item by slug.
Future<RamadanGuideItemModel?> fetchRamadanGuideItem(
  Ref ref,
  String slug,
) async {
  final client = ref.read(apiClientProvider);
  final response = await client.get<Map<String, dynamic>>(
    RamadanGuideEndpoints.item(slug),
  );
  if (!response.status || response.data == null) return null;
  return RamadanGuideItemModel.fromJson(response.data!);
}
