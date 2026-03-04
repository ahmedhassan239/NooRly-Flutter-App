/// DTO for a single item inside a collection (verse/hadith).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_item_dto.freezed.dart';
part 'collection_item_dto.g.dart';

@freezed
class CollectionItemDto with _$CollectionItemDto {
  const factory CollectionItemDto({
    required int id,
    required String text,
    String? translation,
    @JsonKey(name: 'surah_name') String? surahName,
    @JsonKey(name: 'ayah_number') int? ayahNumber,
  }) = _CollectionItemDto;

  factory CollectionItemDto.fromJson(Map<String, dynamic> json) =>
      _$CollectionItemDtoFromJson(json);
}

extension CollectionItemDtoX on CollectionItemDto {
  String get referenceLabel {
    if (surahName != null && surahName!.isNotEmpty && ayahNumber != null) {
      return '$surahName • $ayahNumber';
    }
    if (surahName != null && surahName!.isNotEmpty) return surahName!;
    if (ayahNumber != null) return ayahNumber.toString();
    return '';
  }
}
