// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adjective_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdjectiveData {

 String get comparative; String get superlative;
/// Create a copy of AdjectiveData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdjectiveDataCopyWith<AdjectiveData> get copyWith => _$AdjectiveDataCopyWithImpl<AdjectiveData>(this as AdjectiveData, _$identity);

  /// Serializes this AdjectiveData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdjectiveData&&(identical(other.comparative, comparative) || other.comparative == comparative)&&(identical(other.superlative, superlative) || other.superlative == superlative));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,comparative,superlative);

@override
String toString() {
  return 'AdjectiveData(comparative: $comparative, superlative: $superlative)';
}


}

/// @nodoc
abstract mixin class $AdjectiveDataCopyWith<$Res>  {
  factory $AdjectiveDataCopyWith(AdjectiveData value, $Res Function(AdjectiveData) _then) = _$AdjectiveDataCopyWithImpl;
@useResult
$Res call({
 String comparative, String superlative
});




}
/// @nodoc
class _$AdjectiveDataCopyWithImpl<$Res>
    implements $AdjectiveDataCopyWith<$Res> {
  _$AdjectiveDataCopyWithImpl(this._self, this._then);

  final AdjectiveData _self;
  final $Res Function(AdjectiveData) _then;

/// Create a copy of AdjectiveData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comparative = null,Object? superlative = null,}) {
  return _then(_self.copyWith(
comparative: null == comparative ? _self.comparative : comparative // ignore: cast_nullable_to_non_nullable
as String,superlative: null == superlative ? _self.superlative : superlative // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdjectiveData].
extension AdjectiveDataPatterns on AdjectiveData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdjectiveData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdjectiveData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdjectiveData value)  $default,){
final _that = this;
switch (_that) {
case _AdjectiveData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdjectiveData value)?  $default,){
final _that = this;
switch (_that) {
case _AdjectiveData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String comparative,  String superlative)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdjectiveData() when $default != null:
return $default(_that.comparative,_that.superlative);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String comparative,  String superlative)  $default,) {final _that = this;
switch (_that) {
case _AdjectiveData():
return $default(_that.comparative,_that.superlative);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String comparative,  String superlative)?  $default,) {final _that = this;
switch (_that) {
case _AdjectiveData() when $default != null:
return $default(_that.comparative,_that.superlative);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdjectiveData implements AdjectiveData {
  const _AdjectiveData({required this.comparative, required this.superlative});
  factory _AdjectiveData.fromJson(Map<String, dynamic> json) => _$AdjectiveDataFromJson(json);

@override final  String comparative;
@override final  String superlative;

/// Create a copy of AdjectiveData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdjectiveDataCopyWith<_AdjectiveData> get copyWith => __$AdjectiveDataCopyWithImpl<_AdjectiveData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdjectiveDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdjectiveData&&(identical(other.comparative, comparative) || other.comparative == comparative)&&(identical(other.superlative, superlative) || other.superlative == superlative));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,comparative,superlative);

@override
String toString() {
  return 'AdjectiveData(comparative: $comparative, superlative: $superlative)';
}


}

/// @nodoc
abstract mixin class _$AdjectiveDataCopyWith<$Res> implements $AdjectiveDataCopyWith<$Res> {
  factory _$AdjectiveDataCopyWith(_AdjectiveData value, $Res Function(_AdjectiveData) _then) = __$AdjectiveDataCopyWithImpl;
@override @useResult
$Res call({
 String comparative, String superlative
});




}
/// @nodoc
class __$AdjectiveDataCopyWithImpl<$Res>
    implements _$AdjectiveDataCopyWith<$Res> {
  __$AdjectiveDataCopyWithImpl(this._self, this._then);

  final _AdjectiveData _self;
  final $Res Function(_AdjectiveData) _then;

/// Create a copy of AdjectiveData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comparative = null,Object? superlative = null,}) {
  return _then(_AdjectiveData(
comparative: null == comparative ? _self.comparative : comparative // ignore: cast_nullable_to_non_nullable
as String,superlative: null == superlative ? _self.superlative : superlative // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
