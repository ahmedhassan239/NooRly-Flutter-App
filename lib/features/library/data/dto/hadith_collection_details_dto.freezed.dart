// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadith_collection_details_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HadithCollectionDetailsDto _$HadithCollectionDetailsDtoFromJson(
    Map<String, dynamic> json) {
  return _HadithCollectionDetailsDto.fromJson(json);
}

/// @nodoc
mixin _$HadithCollectionDetailsDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  List<HadithItemDto> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HadithCollectionDetailsDtoCopyWith<HadithCollectionDetailsDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HadithCollectionDetailsDtoCopyWith<$Res> {
  factory $HadithCollectionDetailsDtoCopyWith(HadithCollectionDetailsDto value,
          $Res Function(HadithCollectionDetailsDto) then) =
      _$HadithCollectionDetailsDtoCopyWithImpl<$Res,
          HadithCollectionDetailsDto>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? icon,
      String? color,
      List<HadithItemDto> items});
}

/// @nodoc
class _$HadithCollectionDetailsDtoCopyWithImpl<$Res,
        $Val extends HadithCollectionDetailsDto>
    implements $HadithCollectionDetailsDtoCopyWith<$Res> {
  _$HadithCollectionDetailsDtoCopyWithImpl(this._value, this._then);

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
    Object? items = null,
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
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<HadithItemDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HadithCollectionDetailsDtoImplCopyWith<$Res>
    implements $HadithCollectionDetailsDtoCopyWith<$Res> {
  factory _$$HadithCollectionDetailsDtoImplCopyWith(
          _$HadithCollectionDetailsDtoImpl value,
          $Res Function(_$HadithCollectionDetailsDtoImpl) then) =
      __$$HadithCollectionDetailsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? icon,
      String? color,
      List<HadithItemDto> items});
}

/// @nodoc
class __$$HadithCollectionDetailsDtoImplCopyWithImpl<$Res>
    extends _$HadithCollectionDetailsDtoCopyWithImpl<$Res,
        _$HadithCollectionDetailsDtoImpl>
    implements _$$HadithCollectionDetailsDtoImplCopyWith<$Res> {
  __$$HadithCollectionDetailsDtoImplCopyWithImpl(
      _$HadithCollectionDetailsDtoImpl _value,
      $Res Function(_$HadithCollectionDetailsDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? items = null,
  }) {
    return _then(_$HadithCollectionDetailsDtoImpl(
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
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<HadithItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HadithCollectionDetailsDtoImpl implements _HadithCollectionDetailsDto {
  const _$HadithCollectionDetailsDtoImpl(
      {required this.id,
      required this.title,
      this.icon,
      this.color,
      final List<HadithItemDto> items = const []})
      : _items = items;

  factory _$HadithCollectionDetailsDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$HadithCollectionDetailsDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? icon;
  @override
  final String? color;
  final List<HadithItemDto> _items;
  @override
  @JsonKey()
  List<HadithItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'HadithCollectionDetailsDto(id: $id, title: $title, icon: $icon, color: $color, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HadithCollectionDetailsDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, icon, color,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HadithCollectionDetailsDtoImplCopyWith<_$HadithCollectionDetailsDtoImpl>
      get copyWith => __$$HadithCollectionDetailsDtoImplCopyWithImpl<
          _$HadithCollectionDetailsDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HadithCollectionDetailsDtoImplToJson(
      this,
    );
  }
}

abstract class _HadithCollectionDetailsDto
    implements HadithCollectionDetailsDto {
  const factory _HadithCollectionDetailsDto(
      {required final int id,
      required final String title,
      final String? icon,
      final String? color,
      final List<HadithItemDto> items}) = _$HadithCollectionDetailsDtoImpl;

  factory _HadithCollectionDetailsDto.fromJson(Map<String, dynamic> json) =
      _$HadithCollectionDetailsDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get icon;
  @override
  String? get color;
  @override
  List<HadithItemDto> get items;
  @override
  @JsonKey(ignore: true)
  _$$HadithCollectionDetailsDtoImplCopyWith<_$HadithCollectionDetailsDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
