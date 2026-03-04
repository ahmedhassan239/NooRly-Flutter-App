// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CollectionItemDto _$CollectionItemDtoFromJson(Map<String, dynamic> json) {
  return _CollectionItemDto.fromJson(json);
}

/// @nodoc
mixin _$CollectionItemDto {
  int get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String? get translation => throw _privateConstructorUsedError;
  @JsonKey(name: 'surah_name')
  String? get surahName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ayah_number')
  int? get ayahNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CollectionItemDtoCopyWith<CollectionItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionItemDtoCopyWith<$Res> {
  factory $CollectionItemDtoCopyWith(
          CollectionItemDto value, $Res Function(CollectionItemDto) then) =
      _$CollectionItemDtoCopyWithImpl<$Res, CollectionItemDto>;
  @useResult
  $Res call(
      {int id,
      String text,
      String? translation,
      @JsonKey(name: 'surah_name') String? surahName,
      @JsonKey(name: 'ayah_number') int? ayahNumber});
}

/// @nodoc
class _$CollectionItemDtoCopyWithImpl<$Res, $Val extends CollectionItemDto>
    implements $CollectionItemDtoCopyWith<$Res> {
  _$CollectionItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? translation = freezed,
    Object? surahName = freezed,
    Object? ayahNumber = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      translation: freezed == translation
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as String?,
      surahName: freezed == surahName
          ? _value.surahName
          : surahName // ignore: cast_nullable_to_non_nullable
              as String?,
      ayahNumber: freezed == ayahNumber
          ? _value.ayahNumber
          : ayahNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollectionItemDtoImplCopyWith<$Res>
    implements $CollectionItemDtoCopyWith<$Res> {
  factory _$$CollectionItemDtoImplCopyWith(_$CollectionItemDtoImpl value,
          $Res Function(_$CollectionItemDtoImpl) then) =
      __$$CollectionItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String text,
      String? translation,
      @JsonKey(name: 'surah_name') String? surahName,
      @JsonKey(name: 'ayah_number') int? ayahNumber});
}

/// @nodoc
class __$$CollectionItemDtoImplCopyWithImpl<$Res>
    extends _$CollectionItemDtoCopyWithImpl<$Res, _$CollectionItemDtoImpl>
    implements _$$CollectionItemDtoImplCopyWith<$Res> {
  __$$CollectionItemDtoImplCopyWithImpl(_$CollectionItemDtoImpl _value,
      $Res Function(_$CollectionItemDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? translation = freezed,
    Object? surahName = freezed,
    Object? ayahNumber = freezed,
  }) {
    return _then(_$CollectionItemDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      translation: freezed == translation
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as String?,
      surahName: freezed == surahName
          ? _value.surahName
          : surahName // ignore: cast_nullable_to_non_nullable
              as String?,
      ayahNumber: freezed == ayahNumber
          ? _value.ayahNumber
          : ayahNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionItemDtoImpl implements _CollectionItemDto {
  const _$CollectionItemDtoImpl(
      {required this.id,
      required this.text,
      this.translation,
      @JsonKey(name: 'surah_name') this.surahName,
      @JsonKey(name: 'ayah_number') this.ayahNumber});

  factory _$CollectionItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionItemDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String text;
  @override
  final String? translation;
  @override
  @JsonKey(name: 'surah_name')
  final String? surahName;
  @override
  @JsonKey(name: 'ayah_number')
  final int? ayahNumber;

  @override
  String toString() {
    return 'CollectionItemDto(id: $id, text: $text, translation: $translation, surahName: $surahName, ayahNumber: $ayahNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.surahName, surahName) ||
                other.surahName == surahName) &&
            (identical(other.ayahNumber, ayahNumber) ||
                other.ayahNumber == ayahNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, text, translation, surahName, ayahNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionItemDtoImplCopyWith<_$CollectionItemDtoImpl> get copyWith =>
      __$$CollectionItemDtoImplCopyWithImpl<_$CollectionItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionItemDtoImplToJson(
      this,
    );
  }
}

abstract class _CollectionItemDto implements CollectionItemDto {
  const factory _CollectionItemDto(
          {required final int id,
          required final String text,
          final String? translation,
          @JsonKey(name: 'surah_name') final String? surahName,
          @JsonKey(name: 'ayah_number') final int? ayahNumber}) =
      _$CollectionItemDtoImpl;

  factory _CollectionItemDto.fromJson(Map<String, dynamic> json) =
      _$CollectionItemDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get text;
  @override
  String? get translation;
  @override
  @JsonKey(name: 'surah_name')
  String? get surahName;
  @override
  @JsonKey(name: 'ayah_number')
  int? get ayahNumber;
  @override
  @JsonKey(ignore: true)
  _$$CollectionItemDtoImplCopyWith<_$CollectionItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
