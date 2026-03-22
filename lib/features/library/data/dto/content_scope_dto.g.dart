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
      iconKey: json['icon_key'] as String?,
      iconUrl: json['icon_url'] as String?,
      color: json['color'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ContentScopeDtoImplToJson(
        _$ContentScopeDtoImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'icon': instance.icon,
      'icon_key': instance.iconKey,
      'icon_url': instance.iconUrl,
      'color': instance.color,
      'display_order': instance.displayOrder,
    };
