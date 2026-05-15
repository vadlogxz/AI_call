// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verb_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerbData {

 VerbAuxiliary get auxiliary; String get partizip2; bool get isSeparable; String? get separablePrefix; Map<String, String> get conjugation; GovernsCase? get governs;
/// Create a copy of VerbData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerbDataCopyWith<VerbData> get copyWith => _$VerbDataCopyWithImpl<VerbData>(this as VerbData, _$identity);

  /// Serializes this VerbData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerbData&&(identical(other.auxiliary, auxiliary) || other.auxiliary == auxiliary)&&(identical(other.partizip2, partizip2) || other.partizip2 == partizip2)&&(identical(other.isSeparable, isSeparable) || other.isSeparable == isSeparable)&&(identical(other.separablePrefix, separablePrefix) || other.separablePrefix == separablePrefix)&&const DeepCollectionEquality().equals(other.conjugation, conjugation)&&(identical(other.governs, governs) || other.governs == governs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,auxiliary,partizip2,isSeparable,separablePrefix,const DeepCollectionEquality().hash(conjugation),governs);

@override
String toString() {
  return 'VerbData(auxiliary: $auxiliary, partizip2: $partizip2, isSeparable: $isSeparable, separablePrefix: $separablePrefix, conjugation: $conjugation, governs: $governs)';
}


}

/// @nodoc
abstract mixin class $VerbDataCopyWith<$Res>  {
  factory $VerbDataCopyWith(VerbData value, $Res Function(VerbData) _then) = _$VerbDataCopyWithImpl;
@useResult
$Res call({
 VerbAuxiliary auxiliary, String partizip2, bool isSeparable, String? separablePrefix, Map<String, String> conjugation, GovernsCase? governs
});




}
/// @nodoc
class _$VerbDataCopyWithImpl<$Res>
    implements $VerbDataCopyWith<$Res> {
  _$VerbDataCopyWithImpl(this._self, this._then);

  final VerbData _self;
  final $Res Function(VerbData) _then;

/// Create a copy of VerbData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? auxiliary = null,Object? partizip2 = null,Object? isSeparable = null,Object? separablePrefix = freezed,Object? conjugation = null,Object? governs = freezed,}) {
  return _then(_self.copyWith(
auxiliary: null == auxiliary ? _self.auxiliary : auxiliary // ignore: cast_nullable_to_non_nullable
as VerbAuxiliary,partizip2: null == partizip2 ? _self.partizip2 : partizip2 // ignore: cast_nullable_to_non_nullable
as String,isSeparable: null == isSeparable ? _self.isSeparable : isSeparable // ignore: cast_nullable_to_non_nullable
as bool,separablePrefix: freezed == separablePrefix ? _self.separablePrefix : separablePrefix // ignore: cast_nullable_to_non_nullable
as String?,conjugation: null == conjugation ? _self.conjugation : conjugation // ignore: cast_nullable_to_non_nullable
as Map<String, String>,governs: freezed == governs ? _self.governs : governs // ignore: cast_nullable_to_non_nullable
as GovernsCase?,
  ));
}

}


/// Adds pattern-matching-related methods to [VerbData].
extension VerbDataPatterns on VerbData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerbData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerbData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerbData value)  $default,){
final _that = this;
switch (_that) {
case _VerbData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerbData value)?  $default,){
final _that = this;
switch (_that) {
case _VerbData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VerbAuxiliary auxiliary,  String partizip2,  bool isSeparable,  String? separablePrefix,  Map<String, String> conjugation,  GovernsCase? governs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerbData() when $default != null:
return $default(_that.auxiliary,_that.partizip2,_that.isSeparable,_that.separablePrefix,_that.conjugation,_that.governs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VerbAuxiliary auxiliary,  String partizip2,  bool isSeparable,  String? separablePrefix,  Map<String, String> conjugation,  GovernsCase? governs)  $default,) {final _that = this;
switch (_that) {
case _VerbData():
return $default(_that.auxiliary,_that.partizip2,_that.isSeparable,_that.separablePrefix,_that.conjugation,_that.governs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VerbAuxiliary auxiliary,  String partizip2,  bool isSeparable,  String? separablePrefix,  Map<String, String> conjugation,  GovernsCase? governs)?  $default,) {final _that = this;
switch (_that) {
case _VerbData() when $default != null:
return $default(_that.auxiliary,_that.partizip2,_that.isSeparable,_that.separablePrefix,_that.conjugation,_that.governs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerbData implements VerbData {
  const _VerbData({required this.auxiliary, required this.partizip2, required this.isSeparable, this.separablePrefix, required final  Map<String, String> conjugation, this.governs}): _conjugation = conjugation;
  factory _VerbData.fromJson(Map<String, dynamic> json) => _$VerbDataFromJson(json);

@override final  VerbAuxiliary auxiliary;
@override final  String partizip2;
@override final  bool isSeparable;
@override final  String? separablePrefix;
 final  Map<String, String> _conjugation;
@override Map<String, String> get conjugation {
  if (_conjugation is EqualUnmodifiableMapView) return _conjugation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_conjugation);
}

@override final  GovernsCase? governs;

/// Create a copy of VerbData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerbDataCopyWith<_VerbData> get copyWith => __$VerbDataCopyWithImpl<_VerbData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerbDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerbData&&(identical(other.auxiliary, auxiliary) || other.auxiliary == auxiliary)&&(identical(other.partizip2, partizip2) || other.partizip2 == partizip2)&&(identical(other.isSeparable, isSeparable) || other.isSeparable == isSeparable)&&(identical(other.separablePrefix, separablePrefix) || other.separablePrefix == separablePrefix)&&const DeepCollectionEquality().equals(other._conjugation, _conjugation)&&(identical(other.governs, governs) || other.governs == governs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,auxiliary,partizip2,isSeparable,separablePrefix,const DeepCollectionEquality().hash(_conjugation),governs);

@override
String toString() {
  return 'VerbData(auxiliary: $auxiliary, partizip2: $partizip2, isSeparable: $isSeparable, separablePrefix: $separablePrefix, conjugation: $conjugation, governs: $governs)';
}


}

/// @nodoc
abstract mixin class _$VerbDataCopyWith<$Res> implements $VerbDataCopyWith<$Res> {
  factory _$VerbDataCopyWith(_VerbData value, $Res Function(_VerbData) _then) = __$VerbDataCopyWithImpl;
@override @useResult
$Res call({
 VerbAuxiliary auxiliary, String partizip2, bool isSeparable, String? separablePrefix, Map<String, String> conjugation, GovernsCase? governs
});




}
/// @nodoc
class __$VerbDataCopyWithImpl<$Res>
    implements _$VerbDataCopyWith<$Res> {
  __$VerbDataCopyWithImpl(this._self, this._then);

  final _VerbData _self;
  final $Res Function(_VerbData) _then;

/// Create a copy of VerbData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? auxiliary = null,Object? partizip2 = null,Object? isSeparable = null,Object? separablePrefix = freezed,Object? conjugation = null,Object? governs = freezed,}) {
  return _then(_VerbData(
auxiliary: null == auxiliary ? _self.auxiliary : auxiliary // ignore: cast_nullable_to_non_nullable
as VerbAuxiliary,partizip2: null == partizip2 ? _self.partizip2 : partizip2 // ignore: cast_nullable_to_non_nullable
as String,isSeparable: null == isSeparable ? _self.isSeparable : isSeparable // ignore: cast_nullable_to_non_nullable
as bool,separablePrefix: freezed == separablePrefix ? _self.separablePrefix : separablePrefix // ignore: cast_nullable_to_non_nullable
as String?,conjugation: null == conjugation ? _self._conjugation : conjugation // ignore: cast_nullable_to_non_nullable
as Map<String, String>,governs: freezed == governs ? _self.governs : governs // ignore: cast_nullable_to_non_nullable
as GovernsCase?,
  ));
}


}

// dart format on
