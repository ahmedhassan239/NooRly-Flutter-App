/// Models for Ramadan Guide API (localized from backend).
library;

/// Single Ramadan guide section (accordion item).
class RamadanGuideItemModel {
  const RamadanGuideItemModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.content,
    required this.icon,
    required this.sortOrder,
  });

  final int id;
  final String slug;
  final String title;
  final String description;
  final String content;
  final String icon;
  final int sortOrder;

  factory RamadanGuideItemModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return RamadanGuideItemModel(
      id: (data['id'] as num?)?.toInt() ?? 0,
      slug: data['slug'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      content: data['content'] as String? ?? '',
      icon: data['icon'] as String? ?? 'moon',
      sortOrder: (data['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  static List<RamadanGuideItemModel> listFromJson(dynamic json) {
    if (json == null) return [];
    final list = json is List ? json : (json['data'] as List?);
    if (list == null) return [];
    return list
        .map((e) => RamadanGuideItemModel.fromJson({'data': e}))
        .toList();
  }
}
