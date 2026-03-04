// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_details_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CollectionDetailsDto _$CollectionDetailsDtoFromJson(Map<String, dynamic> json) {
  return _CollectionDetailsDto.fromJson(json);
}

/// @nodoc
mixin _$CollectionDetailsDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<CollectionItemDto> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CollectionDetailsDtoCopyWith<CollectionDetailsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionDetailsDtoCopyWith<$Res> {
  factory $CollectionDetailsDtoCopyWith(CollectionDetailsDto value,
          $Res Function(CollectionDetailsDto) then) =
      _$CollectionDetailsDtoCopyWithImpl<$Res, CollectionDetailsDto>;
  @useResult
  $Res call({int id, String title, List<CollectionItemDto> items});
}

/// @nodoc
class _$CollectionDetailsDtoCopyWithImpl<$Res,
        $Val extends CollectionDetailsDto>
    implements $CollectionDetailsDtoCopyWith<$Res> {
  _$CollectionDetailsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
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
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CollectionItemDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollectionDetailsDtoImplCopyWith<$Res>
    implements $CollectionDetailsDtoCopyWith<$Res> {
  factory _$$CollectionDetailsDtoImplCopyWith(_$CollectionDetailsDtoImpl value,
          $Res Function(_$CollectionDetailsDtoImpl) then) =
      __$$CollectionDetailsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, List<CollectionItemDto> items});
}

/// @nodoc
class __$$CollectionDetailsDtoImplCopyWithImpl<$Res>
    extends _$CollectionDetailsDtoCopyWithImpl<$Res, _$CollectionDetailsDtoImpl>
    implements _$$CollectionDetailsDtoImplCopyWith<$Res> {
  __$$CollectionDetailsDtoImplCopyWithImpl(_$CollectionDetailsDtoImpl _value,
      $Res Function(_$CollectionDetailsDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? items = null,
  }) {
    return _then(_$CollectionDetailsDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CollectionItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionDetailsDtoImpl implements _CollectionDetailsDto {
  const _$CollectionDetailsDtoImpl(
      {required this.id,
      required this.title,
      final List<CollectionItemDto> items = const []})
      : _items = items;

  factory _$CollectionDetailsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionDetailsDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  final List<CollectionItemDto> _items;
  @override
  @JsonKey()
  List<CollectionItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CollectionDetailsDto(id: $id, title: $title, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionDetailsDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionDetailsDtoImplCopyWith<_$CollectionDetailsDtoImpl>
      get copyWith =>
          __$$CollectionDetailsDtoImplCopyWithImpl<_$CollectionDetailsDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionDetailsDtoImplToJson(
      this,
    );
  }
}

abstract class _CollectionDetailsDto implements CollectionDetailsDto {
  const factory _CollectionDetailsDto(
      {required final int id,
      required final String title,
      final List<CollectionItemDto> items}) = _$CollectionDetailsDtoImpl;

  factory _CollectionDetailsDto.fromJson(Map<String, dynamic> json) =
      _$CollectionDetailsDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  List<CollectionItemDto> get items;
  @override
  @JsonKey(ignore: true)
  _$$CollectionDetailsDtoImplCopyWith<_$CollectionDetailsDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
