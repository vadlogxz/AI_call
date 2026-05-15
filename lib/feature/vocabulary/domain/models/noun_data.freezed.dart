// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'noun_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NounData {

 String get article; String get plural; String get genitive;
/// Create a copy of NounData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NounDataCopyWith<NounData> get copyWith => _$NounDataCopyWithImpl<NounData>(this as NounData, _$identity);

  /// Serializes this NounData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NounData&&(identical(other.article, article) || other.article == article)&&(identical(other.plural, plural) || other.plural == plural)&&(identical(other.genitive, genitive) || other.genitive == genitive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,article,plural,genitive);

@override
String toString() {
  return 'NounData(article: $article, plural: $plural, genitive: $genitive)';
}


}

/// @nodoc
abstract mixin class $NounDataCopyWith<$Res>  {
  factory $NounDataCopyWith(NounData value, $Res Function(NounData) _then) = _$NounDataCopyWithImpl;
@useResult
$Res call({
 String article, String plural, String genitive
});




}
/// @nodoc
class _$NounDataCopyWithImpl<$Res>
    implements $NounDataCopyWith<$Res> {
  _$NounDataCopyWithImpl(this._self, this._then);

  final NounData _self;
  final $Res Function(NounData) _then;

/// Create a copy of NounData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? article = null,Object? plural = null,Object? genitive = null,}) {
  return _then(_self.copyWith(
article: null == article ? _self.article : article // ignore: cast_nullable_to_non_nullable
as String,plural: null == plural ? _self.plural : plural // ignore: cast_nullable_to_non_nullable
as String,genitive: null == genitive ? _self.genitive : genitive // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NounData].
extension NounDataPatterns on NounData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NounData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NounData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NounData value)  $default,){
final _that = this;
switch (_that) {
case _NounData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NounData value)?  $default,){
final _that = this;
switch (_that) {
case _NounData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String article,  String plural,  String genitive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NounData() when $default != null:
return $default(_that.article,_that.plural,_that.genitive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String article,  String plural,  String genitive)  $default,) {final _that = this;
switch (_that) {
case _NounData():
return $default(_that.article,_that.plural,_that.genitive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String article,  String plural,  String genitive)?  $default,) {final _that = this;
switch (_that) {
case _NounData() when $default != null:
return $default(_that.article,_that.plural,_that.genitive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NounData implements NounData {
  const _NounData({required this.article, required this.plural, required this.genitive});
  factory _NounData.fromJson(Map<String, dynamic> json) => _$NounDataFromJson(json);

@override final  String article;
@override final  String plural;
@override final  String genitive;

/// Create a copy of NounData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NounDataCopyWith<_NounData> get copyWith => __$NounDataCopyWithImpl<_NounData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NounDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NounData&&(identical(other.article, article) || other.article == article)&&(identical(other.plural, plural) || other.plural == plural)&&(identical(other.genitive, genitive) || other.genitive == genitive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,article,plural,genitive);

@override
String toString() {
  return 'NounData(article: $article, plural: $plural, genitive: $genitive)';
}


}

/// @nodoc
abstract mixin class _$NounDataCopyWith<$Res> implements $NounDataCopyWith<$Res> {
  factory _$NounDataCopyWith(_NounData value, $Res Function(_NounData) _then) = __$NounDataCopyWithImpl;
@override @useResult
$Res call({
 String article, String plural, String genitive
});




}
/// @nodoc
class __$NounDataCopyWithImpl<$Res>
    implements _$NounDataCopyWith<$Res> {
  __$NounDataCopyWithImpl(this._self, this._then);

  final _NounData _self;
  final $Res Function(_NounData) _then;

/// Create a copy of NounData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? article = null,Object? plural = null,Object? genitive = null,}) {
  return _then(_NounData(
article: null == article ? _self.article : article // ignore: cast_nullable_to_non_nullable
as String,plural: null == plural ? _self.plural : plural // ignore: cast_nullable_to_non_nullable
as String,genitive: null == genitive ? _self.genitive : genitive // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
