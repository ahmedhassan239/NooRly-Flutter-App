/// Dua Entity (Domain Model)
///
/// Pure business logic representation of a Dua
class DuaEntity {
  const DuaEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    required this.tags,
  });

  final String id;
  final String category;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  final List<String> tags;
}

/// Dua Category Entity
class DuaCategoryEntity {
  const DuaCategoryEntity({
    required this.id,
    required this.title,
    this.description,
    required this.iconKey,
    this.iconColor,
    required this.count,
    this.slug,
  });

  final String id;
  final String title;
  /// Optional subtitle/description from API.
  final String? description;
  /// Lucide/Material icon key (e.g. "moon", "book", "bed"). Use [iconFromKey] to get IconData.
  final String iconKey;
  /// Optional hex or theme color key from backend.
  final String? iconColor;
  final int count;
  /// Slug for routing (optional).
  final String? slug;
}
