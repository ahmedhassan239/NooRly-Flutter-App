// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_collection_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HadithCollectionDetailsDtoImpl _$$HadithCollectionDetailsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$HadithCollectionDetailsDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => HadithItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$HadithCollectionDetailsDtoImplToJson(
        _$HadithCollectionDetailsDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'items': instance.items,
    };
