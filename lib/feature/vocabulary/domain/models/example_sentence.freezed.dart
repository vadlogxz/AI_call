// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_sentence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExampleSentence {

 String get de; String get uk;
/// Create a copy of ExampleSentence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleSentenceCopyWith<ExampleSentence> get copyWith => _$ExampleSentenceCopyWithImpl<ExampleSentence>(this as ExampleSentence, _$identity);

  /// Serializes this ExampleSentence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleSentence&&(identical(other.de, de) || other.de == de)&&(identical(other.uk, uk) || other.uk == uk));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,de,uk);

@override
String toString() {
  return 'ExampleSentence(de: $de, uk: $uk)';
}


}

/// @nodoc
abstract mixin class $ExampleSentenceCopyWith<$Res>  {
  factory $ExampleSentenceCopyWith(ExampleSentence value, $Res Function(ExampleSentence) _then) = _$ExampleSentenceCopyWithImpl;
@useResult
$Res call({
 String de, String uk
});




}
/// @nodoc
class _$ExampleSentenceCopyWithImpl<$Res>
    implements $ExampleSentenceCopyWith<$Res> {
  _$ExampleSentenceCopyWithImpl(this._self, this._then);

  final ExampleSentence _self;
  final $Res Function(ExampleSentence) _then;

/// Create a copy of ExampleSentence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? de = null,Object? uk = null,}) {
  return _then(_self.copyWith(
de: null == de ? _self.de : de // ignore: cast_nullable_to_non_nullable
as String,uk: null == uk ? _self.uk : uk // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExampleSentence].
extension ExampleSentencePatterns on ExampleSentence {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleSentence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleSentence() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleSentence value)  $default,){
final _that = this;
switch (_that) {
case _ExampleSentence():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleSentence value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleSentence() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String de,  String uk)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleSentence() when $default != null:
return $default(_that.de,_that.uk);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String de,  String uk)  $default,) {final _that = this;
switch (_that) {
case _ExampleSentence():
return $default(_that.de,_that.uk);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String de,  String uk)?  $default,) {final _that = this;
switch (_that) {
case _ExampleSentence() when $default != null:
return $default(_that.de,_that.uk);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExampleSentence implements ExampleSentence {
  const _ExampleSentence({required this.de, required this.uk});
  factory _ExampleSentence.fromJson(Map<String, dynamic> json) => _$ExampleSentenceFromJson(json);

@override final  String de;
@override final  String uk;

/// Create a copy of ExampleSentence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleSentenceCopyWith<_ExampleSentence> get copyWith => __$ExampleSentenceCopyWithImpl<_ExampleSentence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExampleSentenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleSentence&&(identical(other.de, de) || other.de == de)&&(identical(other.uk, uk) || other.uk == uk));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,de,uk);

@override
String toString() {
  return 'ExampleSentence(de: $de, uk: $uk)';
}


}

/// @nodoc
abstract mixin class _$ExampleSentenceCopyWith<$Res> implements $ExampleSentenceCopyWith<$Res> {
  factory _$ExampleSentenceCopyWith(_ExampleSentence value, $Res Function(_ExampleSentence) _then) = __$ExampleSentenceCopyWithImpl;
@override @useResult
$Res call({
 String de, String uk
});




}
/// @nodoc
class __$ExampleSentenceCopyWithImpl<$Res>
    implements _$ExampleSentenceCopyWith<$Res> {
  __$ExampleSentenceCopyWithImpl(this._self, this._then);

  final _ExampleSentence _self;
  final $Res Function(_ExampleSentence) _then;

/// Create a copy of ExampleSentence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? de = null,Object? uk = null,}) {
  return _then(_ExampleSentence(
de: null == de ? _self.de : de // ignore: cast_nullable_to_non_nullable
as String,uk: null == uk ? _self.uk : uk // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
