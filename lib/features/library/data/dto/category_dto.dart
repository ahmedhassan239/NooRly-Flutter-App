/// DTO for library category (per tab).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

@freezed
class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    required int id,
    String? title,
    String? icon,
    String? color,
    @JsonKey(name: 'items_count') @Default(0) int itemsCount,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}

extension CategoryDtoX on CategoryDto {
  String get displayTitle => title ?? '';
}
