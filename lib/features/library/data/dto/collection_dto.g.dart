// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollectionDtoImpl _$$CollectionDtoImplFromJson(Map<String, dynamic> json) =>
    _$CollectionDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$CollectionDtoImplToJson(_$CollectionDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'items_count': instance.itemsCount,
      'icon': instance.icon,
    };
