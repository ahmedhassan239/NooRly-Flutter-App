// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_collection_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HadithCollectionDtoImpl _$$HadithCollectionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$HadithCollectionDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      icon: json['icon'] as String?,
      iconKey: json['icon_key'] as String?,
      iconUrl: json['icon_url'] as String?,
    );

Map<String, dynamic> _$$HadithCollectionDtoImplToJson(
        _$HadithCollectionDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'items_count': instance.itemsCount,
      'icon': instance.icon,
      'icon_key': instance.iconKey,
      'icon_url': instance.iconUrl,
    };
