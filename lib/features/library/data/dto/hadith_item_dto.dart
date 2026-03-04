/// DTO for a single hadith item inside a collection.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadith_item_dto.freezed.dart';
part 'hadith_item_dto.g.dart';

@freezed
class HadithItemDto with _$HadithItemDto {
  const factory HadithItemDto({
    required int id,
    required String title,
    required String content,
    String? source,
    String? grade,
  }) = _HadithItemDto;

  factory HadithItemDto.fromJson(Map<String, dynamic> json) =>
      _$HadithItemDtoFromJson(json);
}
