// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_scope_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentScopeDto _$ContentScopeDtoFromJson(Map<String, dynamic> json) {
  return _ContentScopeDto.fromJson(json);
}

/// @nodoc
mixin _$ContentScopeDto {
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int get displayOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentScopeDtoCopyWith<ContentScopeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentScopeDtoCopyWith<$Res> {
  factory $ContentScopeDtoCopyWith(
          ContentScopeDto value, $Res Function(ContentScopeDto) then) =
      _$ContentScopeDtoCopyWithImpl<$Res, ContentScopeDto>;
  @useResult
  $Res call(
      {String key,
      String label,
      String? icon,
      String? color,
      @JsonKey(name: 'display_order') int displayOrder});
}

/// @nodoc
class _$ContentScopeDtoCopyWithImpl<$Res, $Val extends ContentScopeDto>
    implements $ContentScopeDtoCopyWith<$Res> {
  _$ContentScopeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? displayOrder = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentScopeDtoImplCopyWith<$Res>
    implements $ContentScopeDtoCopyWith<$Res> {
  factory _$$ContentScopeDtoImplCopyWith(_$ContentScopeDtoImpl value,
          $Res Function(_$ContentScopeDtoImpl) then) =
      __$$ContentScopeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String label,
      String? icon,
      String? color,
      @JsonKey(name: 'display_order') int displayOrder});
}

/// @nodoc
class __$$ContentScopeDtoImplCopyWithImpl<$Res>
    extends _$ContentScopeDtoCopyWithImpl<$Res, _$ContentScopeDtoImpl>
    implements _$$ContentScopeDtoImplCopyWith<$Res> {
  __$$ContentScopeDtoImplCopyWithImpl(
      _$ContentScopeDtoImpl _value, $Res Function(_$ContentScopeDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? displayOrder = null,
  }) {
    return _then(_$ContentScopeDtoImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentScopeDtoImpl implements _ContentScopeDto {
  const _$ContentScopeDtoImpl(
      {required this.key,
      required this.label,
      this.icon,
      this.color,
      @JsonKey(name: 'display_order') this.displayOrder = 0});

  factory _$ContentScopeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentScopeDtoImplFromJson(json);

  @override
  final String key;
  @override
  final String label;
  @override
  final String? icon;
  @override
  final String? color;
  @override
  @JsonKey(name: 'display_order')
  final int displayOrder;

  @override
  String toString() {
    return 'ContentScopeDto(key: $key, label: $label, icon: $icon, color: $color, displayOrder: $displayOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentScopeDtoImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, key, label, icon, color, displayOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentScopeDtoImplCopyWith<_$ContentScopeDtoImpl> get copyWith =>
      __$$ContentScopeDtoImplCopyWithImpl<_$ContentScopeDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentScopeDtoImplToJson(
      this,
    );
  }
}

abstract class _ContentScopeDto implements ContentScopeDto {
  const factory _ContentScopeDto(
          {required final String key,
          required final String label,
          final String? icon,
          final String? color,
          @JsonKey(name: 'display_order') final int displayOrder}) =
      _$ContentScopeDtoImpl;

  factory _ContentScopeDto.fromJson(Map<String, dynamic> json) =
      _$ContentScopeDtoImpl.fromJson;

  @override
  String get key;
  @override
  String get label;
  @override
  String? get icon;
  @override
  String? get color;
  @override
  @JsonKey(name: 'display_order')
  int get displayOrder;
  @override
  @JsonKey(ignore: true)
  _$$ContentScopeDtoImplCopyWith<_$ContentScopeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
