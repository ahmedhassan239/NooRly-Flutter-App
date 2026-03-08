/// DTO for hadith collection detail (title + hadith items).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_app/features/library/data/dto/hadith_item_dto.dart';

part 'hadith_collection_details_dto.freezed.dart';
part 'hadith_collection_details_dto.g.dart';

@freezed
class HadithCollectionDetailsDto with _$HadithCollectionDetailsDto {
  const factory HadithCollectionDetailsDto({
    required int id,
    required String title,
    @Default([]) List<HadithItemDto> items,
  }) = _HadithCollectionDetailsDto;

  factory HadithCollectionDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$HadithCollectionDetailsDtoFromJson(json);
}
