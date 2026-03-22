/// Models for Ramadan Guide API (localized from backend).
library;

String? _jsonString(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    final s = value.trim();
    return s.isEmpty ? null : s;
  }
  final s = value.toString().trim();
  return s.isEmpty ? null : s;
}

/// Single Ramadan guide section (accordion item).
class RamadanGuideItemModel {
  const RamadanGuideItemModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.content,
    required this.iconKey,
    this.iconUrl,
    required this.sortOrder,
  });

  final int id;
  final String slug;
  final String title;
  final String description;
  final String content;

  /// Canonical icon key (filename slug). Same as API `icon_key` / legacy `icon`.
  final String iconKey;

  /// Absolute URL to icon asset (SVG/PNG) when provided by API.
  final String? iconUrl;

  final int sortOrder;

  /// Alias for older code paths; prefer [iconKey].
  String get icon => iconKey;

  factory RamadanGuideItemModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    // Prefer explicit icon_key; support camelCase; avoid defaulting every row to legacy `moon`.
    final iconKey = _jsonString(data['icon_key']) ??
        _jsonString(data['iconKey']) ??
        _jsonString(data['icon']) ??
        'ramadhan-night-icon';
    return RamadanGuideItemModel(
      id: (data['id'] as num?)?.toInt() ?? 0,
      slug: data['slug'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      content: data['content'] as String? ?? '',
      iconKey: iconKey,
      iconUrl: _jsonString(data['icon_url']) ?? _jsonString(data['iconUrl']),
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
