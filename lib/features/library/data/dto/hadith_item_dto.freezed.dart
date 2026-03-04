// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadith_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HadithItemDto _$HadithItemDtoFromJson(Map<String, dynamic> json) {
  return _HadithItemDto.fromJson(json);
}

/// @nodoc
mixin _$HadithItemDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  String? get grade => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HadithItemDtoCopyWith<HadithItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HadithItemDtoCopyWith<$Res> {
  factory $HadithItemDtoCopyWith(
          HadithItemDto value, $Res Function(HadithItemDto) then) =
      _$HadithItemDtoCopyWithImpl<$Res, HadithItemDto>;
  @useResult
  $Res call(
      {int id, String title, String content, String? source, String? grade});
}

/// @nodoc
class _$HadithItemDtoCopyWithImpl<$Res, $Val extends HadithItemDto>
    implements $HadithItemDtoCopyWith<$Res> {
  _$HadithItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? source = freezed,
    Object? grade = freezed,
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
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HadithItemDtoImplCopyWith<$Res>
    implements $HadithItemDtoCopyWith<$Res> {
  factory _$$HadithItemDtoImplCopyWith(
          _$HadithItemDtoImpl value, $Res Function(_$HadithItemDtoImpl) then) =
      __$$HadithItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, String title, String content, String? source, String? grade});
}

/// @nodoc
class __$$HadithItemDtoImplCopyWithImpl<$Res>
    extends _$HadithItemDtoCopyWithImpl<$Res, _$HadithItemDtoImpl>
    implements _$$HadithItemDtoImplCopyWith<$Res> {
  __$$HadithItemDtoImplCopyWithImpl(
      _$HadithItemDtoImpl _value, $Res Function(_$HadithItemDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? source = freezed,
    Object? grade = freezed,
  }) {
    return _then(_$HadithItemDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HadithItemDtoImpl implements _HadithItemDto {
  const _$HadithItemDtoImpl(
      {required this.id,
      required this.title,
      required this.content,
      this.source,
      this.grade});

  factory _$HadithItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HadithItemDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String content;
  @override
  final String? source;
  @override
  final String? grade;

  @override
  String toString() {
    return 'HadithItemDto(id: $id, title: $title, content: $content, source: $source, grade: $grade)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HadithItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.grade, grade) || other.grade == grade));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, content, source, grade);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HadithItemDtoImplCopyWith<_$HadithItemDtoImpl> get copyWith =>
      __$$HadithItemDtoImplCopyWithImpl<_$HadithItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HadithItemDtoImplToJson(
      this,
    );
  }
}

abstract class _HadithItemDto implements HadithItemDto {
  const factory _HadithItemDto(
      {required final int id,
      required final String title,
      required final String content,
      final String? source,
      final String? grade}) = _$HadithItemDtoImpl;

  factory _HadithItemDto.fromJson(Map<String, dynamic> json) =
      _$HadithItemDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get content;
  @override
  String? get source;
  @override
  String? get grade;
  @override
  @JsonKey(ignore: true)
  _$$HadithItemDtoImplCopyWith<_$HadithItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
