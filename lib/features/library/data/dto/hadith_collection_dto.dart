/// DTO for hadith collection list item (from GET /library/hadith/collections).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadith_collection_dto.freezed.dart';
part 'hadith_collection_dto.g.dart';

@freezed
class HadithCollectionDto with _$HadithCollectionDto {
  const factory HadithCollectionDto({
    required int id,
    required String title,
    @JsonKey(name: 'items_count') @Default(0) int itemsCount,
    String? icon,
    @JsonKey(name: 'icon_key') String? iconKey,
    @JsonKey(name: 'icon_url') String? iconUrl,
  }) = _HadithCollectionDto;

  factory HadithCollectionDto.fromJson(Map<String, dynamic> json) =>
      _$HadithCollectionDtoFromJson(json);
}
