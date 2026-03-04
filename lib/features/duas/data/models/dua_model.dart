import 'package:flutter_app/features/duas/domain/entities/dua_entity.dart';

/// Dua Model (Data Layer)
///
/// JSON serializable model
class DuaModel {
  const DuaModel({
    required this.id,
    required this.category,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    required this.tags,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      source: json['source'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
    );
  }

  final String id;
  final String category;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  final List<String> tags;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'source': source,
      'tags': tags,
    };
  }

  /// Convert to entity
  DuaEntity toEntity() {
    return DuaEntity(
      id: id,
      category: category,
      title: title,
      arabic: arabic,
      transliteration: transliteration,
      translation: translation,
      source: source,
      tags: tags,
    );
  }
}

/// Dua Category Model (API: GET /duas/categories or local JSON)
class DuaCategoryModel {
  const DuaCategoryModel({
    required this.id,
    required this.title,
    this.description,
    required this.iconKey,
    this.iconColor,
    required this.count,
    this.slug,
  });

  /// From backend API (id is int, name, slug, duas_count, icon_key, icon_color)
  factory DuaCategoryModel.fromApiJson(Map<String, dynamic> json) {
    return DuaCategoryModel(
      id: (json['id'] ?? '').toString(),
      title: json['name'] as String? ?? '',
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      iconKey: json['icon_key'] as String? ?? '',
      iconColor: json['icon_color'] as String?,
      count: (json['duas_count'] as int?) ?? 0,
    );
  }

  /// From local JSON (id, title, icon, count)
  factory DuaCategoryModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return DuaCategoryModel(
      id: id is int ? id.toString() : id as String,
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      iconKey: json['icon_key'] as String? ?? json['icon'] as String? ?? '',
      iconColor: json['icon_color'] as String?,
      count: (json['count'] as int?) ?? (json['duas_count'] as int?) ?? 0,
    );
  }

  final String id;
  final String title;
  final String? description;
  final String iconKey;
  final String? iconColor;
  final int count;
  final String? slug;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_key': iconKey,
      'icon_color': iconColor,
      'count': count,
      'slug': slug,
    };
  }

  DuaCategoryEntity toEntity() {
    return DuaCategoryEntity(
      id: id,
      title: title,
      description: description,
      iconKey: iconKey,
      iconColor: iconColor,
      count: count,
      slug: slug,
    );
  }
}
