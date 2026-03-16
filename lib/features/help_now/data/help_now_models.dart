/// Models for Help Now API (localized from backend).
library;

/// Single help item (situation) under a category.
class HelpItemModel {
  const HelpItemModel({
    required this.id,
    required this.slug,
    required this.categoryId,
    required this.categorySlug,
    required this.title,
    this.subtitle,
    required this.content,
    required this.sortOrder,
  });

  final int id;
  final String slug;
  final int categoryId;
  final String? categorySlug;
  final String title;
  final String? subtitle;
  final String content;
  final int sortOrder;

  factory HelpItemModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return HelpItemModel(
      id: (data['id'] as num?)?.toInt() ?? 0,
      slug: data['slug'] as String? ?? '',
      categoryId: (data['category_id'] as num?)?.toInt() ?? 0,
      categorySlug: data['category_slug'] as String?,
      title: data['title'] as String? ?? '',
      subtitle: data['subtitle'] as String?,
      content: data['content'] as String? ?? '',
      sortOrder: (data['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  /// From nested item in category list (no category_slug usually).
  factory HelpItemModel.fromCategoryItemJson(Map<String, dynamic> json) {
    return HelpItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      slug: json['slug'] as String? ?? '',
      categoryId: (json['category_id'] as num?)?.toInt() ?? 0,
      categorySlug: json['category_slug'] as String?,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      content: json['content'] as String? ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Help category with nested items.
class HelpCategoryModel {
  const HelpCategoryModel({
    required this.id,
    required this.slug,
    required this.title,
    this.description,
    required this.icon,
    required this.sortOrder,
    required this.items,
  });

  final int id;
  final String slug;
  final String title;
  final String? description;
  final String icon;
  final int sortOrder;
  final List<HelpItemModel> items;

  factory HelpCategoryModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List? ?? [];
    return HelpCategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      icon: json['icon'] as String? ?? 'heart',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      items: itemsJson
          .map((e) => HelpItemModel.fromCategoryItemJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  static List<HelpCategoryModel> listFromJson(dynamic json) {
    if (json == null) return [];
    final list = json is List ? json : (json['data'] as List?);
    if (list == null) return [];
    return list
        .map((e) =>
            HelpCategoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
