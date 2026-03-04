/// DTO for collection detail (title + items).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'collection_item_dto.dart';

part 'collection_details_dto.freezed.dart';
part 'collection_details_dto.g.dart';

@freezed
class CollectionDetailsDto with _$CollectionDetailsDto {
  const factory CollectionDetailsDto({
    required int id,
    required String title,
    @Default([]) List<CollectionItemDto> items,
  }) = _CollectionDetailsDto;

  factory CollectionDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$CollectionDetailsDtoFromJson(json);
}
