/// DTO for library tab (content scope).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_scope_dto.freezed.dart';
part 'content_scope_dto.g.dart';

@freezed
class ContentScopeDto with _$ContentScopeDto {
  const factory ContentScopeDto({
    required String key,
    required String label,
    String? icon,
    @JsonKey(name: 'icon_key') String? iconKey,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? color,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
  }) = _ContentScopeDto;

  factory ContentScopeDto.fromJson(Map<String, dynamic> json) =>
      _$ContentScopeDtoFromJson(json);
}
