/// API response for GET /library/hadith/collections/{id}: { collection, hadiths }.
library;

import 'package:flutter_app/features/library/data/dto/hadith_dto.dart';

class HadithCollectionDetailsResponseDto {
  const HadithCollectionDetailsResponseDto({
    required this.collection,
    required this.hadiths,
  });

  final HadithCollectionMetaDto collection;
  final List<HadithDto> hadiths;

  static HadithCollectionDetailsResponseDto fromJson(Map<String, dynamic> json) {
    final coll = json['collection'];
    final list = json['hadiths'] as List<dynamic>? ?? [];
    return HadithCollectionDetailsResponseDto(
      collection: coll is Map<String, dynamic>
          ? HadithCollectionMetaDto.fromJson(coll)
          : HadithCollectionMetaDto(id: 0, title: '', slug: null, icon: null, color: null),
      hadiths: list
          .whereType<Map<String, dynamic>>()
          .map((e) => HadithDto.fromJson(e))
          .toList(),
    );
  }
}

class HadithCollectionMetaDto {
  const HadithCollectionMetaDto({
    required this.id,
    required this.title,
    this.slug,
    this.icon,
    this.color,
  });

  final int id;
  final String title;
  final String? slug;
  final String? icon;
  final String? color;

  static HadithCollectionMetaDto fromJson(Map<String, dynamic> json) {
    return HadithCollectionMetaDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      slug: json['slug'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
    );
  }
}
