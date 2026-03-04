// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_scope_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentScopeDtoImpl _$$ContentScopeDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentScopeDtoImpl(
      key: json['key'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ContentScopeDtoImplToJson(
        _$ContentScopeDtoImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'icon': instance.icon,
      'color': instance.color,
      'display_order': instance.displayOrder,
    };
