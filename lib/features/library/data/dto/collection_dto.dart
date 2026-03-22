/// DTO for library collection (list item).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_dto.freezed.dart';
part 'collection_dto.g.dart';

@freezed
class CollectionDto with _$CollectionDto {
  const factory CollectionDto({
    required int id,
    required String title,
    @JsonKey(name: 'items_count') @Default(0) int itemsCount,
    String? icon,
    @JsonKey(name: 'icon_key') String? iconKey,
    @JsonKey(name: 'icon_url') String? iconUrl,
  }) = _CollectionDto;

  factory CollectionDto.fromJson(Map<String, dynamic> json) =>
      _$CollectionDtoFromJson(json);
}
