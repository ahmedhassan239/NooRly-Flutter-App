// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CollectionDto _$CollectionDtoFromJson(Map<String, dynamic> json) {
  return _CollectionDto.fromJson(json);
}

/// @nodoc
mixin _$CollectionDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_count')
  int get itemsCount => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_key')
  String? get iconKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CollectionDtoCopyWith<CollectionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionDtoCopyWith<$Res> {
  factory $CollectionDtoCopyWith(
          CollectionDto value, $Res Function(CollectionDto) then) =
      _$CollectionDtoCopyWithImpl<$Res, CollectionDto>;
  @useResult
  $Res call(
      {int id,
      String title,
      @JsonKey(name: 'items_count') int itemsCount,
      String? icon,
      @JsonKey(name: 'icon_key') String? iconKey,
      @JsonKey(name: 'icon_url') String? iconUrl});
}

/// @nodoc
class _$CollectionDtoCopyWithImpl<$Res, $Val extends CollectionDto>
    implements $CollectionDtoCopyWith<$Res> {
  _$CollectionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? itemsCount = null,
    Object? icon = freezed,
    Object? iconKey = freezed,
    Object? iconUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      itemsCount: null == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      iconKey: freezed == iconKey
          ? _value.iconKey
          : iconKey // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollectionDtoImplCopyWith<$Res>
    implements $CollectionDtoCopyWith<$Res> {
  factory _$$CollectionDtoImplCopyWith(
          _$CollectionDtoImpl value, $Res Function(_$CollectionDtoImpl) then) =
      __$$CollectionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      @JsonKey(name: 'items_count') int itemsCount,
      String? icon,
      @JsonKey(name: 'icon_key') String? iconKey,
      @JsonKey(name: 'icon_url') String? iconUrl});
}

/// @nodoc
class __$$CollectionDtoImplCopyWithImpl<$Res>
    extends _$CollectionDtoCopyWithImpl<$Res, _$CollectionDtoImpl>
    implements _$$CollectionDtoImplCopyWith<$Res> {
  __$$CollectionDtoImplCopyWithImpl(
      _$CollectionDtoImpl _value, $Res Function(_$CollectionDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? itemsCount = null,
    Object? icon = freezed,
    Object? iconKey = freezed,
    Object? iconUrl = freezed,
  }) {
    return _then(_$CollectionDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      itemsCount: null == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      iconKey: freezed == iconKey
          ? _value.iconKey
          : iconKey // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionDtoImpl implements _CollectionDto {
  const _$CollectionDtoImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'items_count') this.itemsCount = 0,
      this.icon,
      @JsonKey(name: 'icon_key') this.iconKey,
      @JsonKey(name: 'icon_url') this.iconUrl});

  factory _$CollectionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  @JsonKey(name: 'items_count')
  final int itemsCount;
  @override
  final String? icon;
  @override
  @JsonKey(name: 'icon_key')
  final String? iconKey;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;

  @override
  String toString() {
    return 'CollectionDto(id: $id, title: $title, itemsCount: $itemsCount, icon: $icon, iconKey: $iconKey, iconUrl: $iconUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.iconKey, iconKey) || other.iconKey == iconKey) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, itemsCount, icon, iconKey, iconUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionDtoImplCopyWith<_$CollectionDtoImpl> get copyWith =>
      __$$CollectionDtoImplCopyWithImpl<_$CollectionDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionDtoImplToJson(
      this,
    );
  }
}

abstract class _CollectionDto implements CollectionDto {
  const factory _CollectionDto(
      {required final int id,
      required final String title,
      @JsonKey(name: 'items_count') final int itemsCount,
      final String? icon,
      @JsonKey(name: 'icon_key') final String? iconKey,
      @JsonKey(name: 'icon_url') final String? iconUrl}) = _$CollectionDtoImpl;

  factory _CollectionDto.fromJson(Map<String, dynamic> json) =
      _$CollectionDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'items_count')
  int get itemsCount;
  @override
  String? get icon;
  @override
  @JsonKey(name: 'icon_key')
  String? get iconKey;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  @JsonKey(ignore: true)
  _$$CollectionDtoImplCopyWith<_$CollectionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
