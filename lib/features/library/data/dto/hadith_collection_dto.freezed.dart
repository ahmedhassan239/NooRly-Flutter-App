// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadith_collection_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HadithCollectionDto _$HadithCollectionDtoFromJson(Map<String, dynamic> json) {
  return _HadithCollectionDto.fromJson(json);
}

/// @nodoc
mixin _$HadithCollectionDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_count')
  int get itemsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HadithCollectionDtoCopyWith<HadithCollectionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HadithCollectionDtoCopyWith<$Res> {
  factory $HadithCollectionDtoCopyWith(
          HadithCollectionDto value, $Res Function(HadithCollectionDto) then) =
      _$HadithCollectionDtoCopyWithImpl<$Res, HadithCollectionDto>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? icon,
      String? color,
      @JsonKey(name: 'items_count') int itemsCount});
}

/// @nodoc
class _$HadithCollectionDtoCopyWithImpl<$Res, $Val extends HadithCollectionDto>
    implements $HadithCollectionDtoCopyWith<$Res> {
  _$HadithCollectionDtoCopyWithImpl(this._value, this._then);

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
abstract class _$$HadithCollectionDtoImplCopyWith<$Res>
    implements $HadithCollectionDtoCopyWith<$Res> {
  factory _$$HadithCollectionDtoImplCopyWith(_$HadithCollectionDtoImpl value,
          $Res Function(_$HadithCollectionDtoImpl) then) =
      __$$HadithCollectionDtoImplCopyWithImpl<$Res>;
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
class __$$HadithCollectionDtoImplCopyWithImpl<$Res>
    extends _$HadithCollectionDtoCopyWithImpl<$Res, _$HadithCollectionDtoImpl>
    implements _$$HadithCollectionDtoImplCopyWith<$Res> {
  __$$HadithCollectionDtoImplCopyWithImpl(_$HadithCollectionDtoImpl _value,
      $Res Function(_$HadithCollectionDtoImpl) _then)
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
    return _then(_$HadithCollectionDtoImpl(
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
class _$HadithCollectionDtoImpl implements _HadithCollectionDto {
  const _$HadithCollectionDtoImpl(
      {required this.id,
      required this.title,
      this.icon,
      this.color,
      @JsonKey(name: 'items_count') this.itemsCount = 0});

  factory _$HadithCollectionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HadithCollectionDtoImplFromJson(json);

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
    return 'HadithCollectionDto(id: $id, title: $title, icon: $icon, color: $color, itemsCount: $itemsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HadithCollectionDtoImpl &&
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
  _$$HadithCollectionDtoImplCopyWith<_$HadithCollectionDtoImpl> get copyWith =>
      __$$HadithCollectionDtoImplCopyWithImpl<_$HadithCollectionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HadithCollectionDtoImplToJson(
      this,
    );
  }
}

abstract class _HadithCollectionDto implements HadithCollectionDto {
  const factory _HadithCollectionDto(
          {required final int id,
          required final String title,
          final String? icon,
          final String? color,
          @JsonKey(name: 'items_count') final int itemsCount}) =
      _$HadithCollectionDtoImpl;

  factory _HadithCollectionDto.fromJson(Map<String, dynamic> json) =
      _$HadithCollectionDtoImpl.fromJson;

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
  _$$HadithCollectionDtoImplCopyWith<_$HadithCollectionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
