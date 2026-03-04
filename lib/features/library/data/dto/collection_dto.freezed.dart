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
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_count')
  int get itemsCount => throw _privateConstructorUsedError;

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
      String? icon,
      String? color,
      @JsonKey(name: 'items_count') int itemsCount});
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
    Object? icon = freezed,
    Object? color = freezed,
    Object? itemsCount = null,
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
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      itemsCount: null == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
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
      String? icon,
      String? color,
      @JsonKey(name: 'items_count') int itemsCount});
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
    Object? icon = freezed,
    Object? color = freezed,
    Object? itemsCount = null,
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
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      itemsCount: null == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionDtoImpl implements _CollectionDto {
  const _$CollectionDtoImpl(
      {required this.id,
      required this.title,
      this.icon,
      this.color,
      @JsonKey(name: 'items_count') this.itemsCount = 0});

  factory _$CollectionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? icon;
  @override
  final String? color;
  @override
  @JsonKey(name: 'items_count')
  final int itemsCount;

  @override
  String toString() {
    return 'CollectionDto(id: $id, title: $title, icon: $icon, color: $color, itemsCount: $itemsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, icon, color, itemsCount);

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
          final String? icon,
          final String? color,
          @JsonKey(name: 'items_count') final int itemsCount}) =
      _$CollectionDtoImpl;

  factory _CollectionDto.fromJson(Map<String, dynamic> json) =
      _$CollectionDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get icon;
  @override
  String? get color;
  @override
  @JsonKey(name: 'items_count')
  int get itemsCount;
  @override
  @JsonKey(ignore: true)
  _$$CollectionDtoImplCopyWith<_$CollectionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
