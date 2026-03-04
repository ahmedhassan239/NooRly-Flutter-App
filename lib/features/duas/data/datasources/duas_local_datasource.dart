import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/duas/data/models/dua_model.dart';

/// Local JSON Data Source for Duas
///
/// Loads duas from assets/data/duas.json
class DuasLocalDataSource {
  static const String _assetPath = 'assets/data/duas.json';

  List<DuaModel>? _cachedDuas;
  List<DuaCategoryModel>? _cachedCategories;

  /// Get all duas
  Future<List<DuaModel>> getAllDuas() async {
    if (_cachedDuas != null) {
      return _cachedDuas!;
    }

    final jsonString = await rootBundle.loadString(_assetPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final duasList = jsonData['duas'] as List<dynamic>;

    _cachedDuas = duasList
        .map((json) => DuaModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return _cachedDuas!;
  }

  /// Get all categories
  Future<List<DuaCategoryModel>> getCategories() async {
    if (_cachedCategories != null) {
      return _cachedCategories!;
    }

    final jsonString = await rootBundle.loadString(_assetPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final categoriesList = jsonData['categories'] as List<dynamic>;

    _cachedCategories = categoriesList
        .map((json) => DuaCategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return _cachedCategories!;
  }

  /// Clear cache (useful for testing)
  void clearCache() {
    _cachedDuas = null;
    _cachedCategories = null;
  }
}
